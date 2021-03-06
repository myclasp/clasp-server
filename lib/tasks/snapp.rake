namespace :snapp do

  desc "Creates dummy data for development purposes"
  task :dummy => :environment do

    moments = [{:latitude=>54.044558361609226, :longitude=>-2.786117792129517}, {:latitude=>54.043654373599495, :longitude=>-2.78404176235199}, {:latitude=>54.04407014753034, :longitude=>-2.7832317352294926}, {:latitude=>54.04416464102545, :longitude=>-2.7818101644515996}, {:latitude=>54.0451158635757, :longitude=>-2.7829688787460327}, {:latitude=>54.045745800301034, :longitude=>-2.7830386161804204}, {:latitude=>54.04560406537037, :longitude=>-2.7814131975173955}, {:latitude=>54.04535839034537, :longitude=>-2.781203985214234}, {:latitude=>54.0457174533536, :longitude=>-2.7808606624603276}, {:latitude=>54.04625289242788, :longitude=>-2.7800345420837402}, {:latitude=>54.047386740635915, :longitude=>-2.779390811920166}, {:latitude=>54.047833972254374, :longitude=>-2.780088186264038}, {:latitude=>54.04797255008896, :longitude=>-2.781440019607544}, {:latitude=>54.047018243361656, :longitude=>-2.7892398834228516}, {:latitude=>54.04823395701881, :longitude=>-2.790967226028443}, {:latitude=>54.043585077539966, :longitude=>-2.7851092815399174}, {:latitude=>54.04419613880943, :longitude=>-2.781826257705689}, {:latitude=>54.04560721504072, :longitude=>-2.78204083442688}, {:latitude=>54.045298546209054, :longitude=>-2.793349027633667}, {:latitude=>54.04833473997424, :longitude=>-2.798949480056763}, {:latitude=>54.04912839720646, :longitude=>-2.7966320514678955}, {:latitude=>54.05057709750882, :longitude=>-2.7958810329437256}, {:latitude=>54.0494874276412, :longitude=>-2.804925441741944}, {:latitude=>54.04912839720646, :longitude=>-2.804421186447144}, {:latitude=>54.04744658176521, :longitude=>-2.7982413768768315}]

    puts "Creating groups"
    g1 = Group.create(name: "Walking Tour", description: "Literary walking tours around Lancaster", image_url: "https://static.pexels.com/photos/5151/man-people-walking-park-large.jpg")
    g2 = Group.create(name: "Safety in Spokes", description: "Campaigning for safer cycling", image_url: "https://pixabay.com/static/uploads/photo/2016/03/09/15/19/bicycles-1246597_960_720.jpg")

    puts "Creating users"
    users = []
    users << User.create(email: "test1@test.com", password: "passwurd", password_confirmation: "passwurd")
    users << User.create(email: "test2@test.com", password: "passwurd", password_confirmation: "passwurd")
    users << User.create(email: "test3@test.com", password: "passwurd", password_confirmation: "passwurd")
    users << User.create(email: "test4@test.com", password: "passwurd", password_confirmation: "passwurd")

    i=0
    users.each do |u|
      puts "Adding moments to user: #{u.email}"
      moments.each do |m|
        i+=1
        m[:latitude]   = m[:latitude] + ((rand(2) * 2 - 1) * (rand(10)/10000.0))
        m[:longitude]  = m[:longitude] + ((rand(2) * 2 - 1) * (rand(10)/10000.0))
        m[:timestamp]  = Time.now-(rand(1000000))
        m[:identifier] = i
        m[:state]   = rand.round
        u.moments.create(m)
      end

      if g1.users.count >> g2.users.count
        puts "Adding user to group: #{g1.name}"
        g2.users << u
      else
        puts "Adding user to group: #{g2.name}"
        g1.users << u
      end
    end

    puts "Dummy data imported"
  end


  task :import => :environment do 
    require 'csv'

    STDOUT.puts "Please enter the user's email address: "

    email = STDIN.gets.strip    
    user = User.find_by(email: email)

    unless user 
      STDOUT.puts "Error: Couldn't find user with email '#{email}'."
      next
    end

    STDOUT.puts "Please enter the location of the file to import (or use default 'import/clicks.txt'): "
    filepath = STDIN.gets.strip
    filepath = "import/clicks.txt" if filepath.blank?

    arr_of_arrs = CSV.read(filepath)
    arr_of_arrs.delete_at(0)
    arr_of_arrs.delete_at(0)

    STDOUT.puts "#{arr_of_arrs.size} moments found" 

    for row in arr_of_arrs 
      result = {}
      result[:identifier] = row[0].to_i

      if row[-1].eql?("1") #skip marked for delete
        STDOUT.puts "Skipping marked for delete moment with id: #{result[:identifier]}"
        next
      end

      result[:timestamp] = Time.at(row[-2].to_i)

      clicks = row[1].to_i
      state = 0 #meaning 'down'
      state = 1 if clicks.eql?(1) #meaning 'up'
      result[:state] = state

      result[:longitude] = row[3].to_f
      result[:latitude]  = row[2].to_f
      
      m = user.moments.create(result)

      if m.valid? 
        STDOUT.puts "Imported moment with id: #{result[:identifier]}"
      else
        STDOUT.puts "Failed to import moment with id: #{result[:identifier]}\n\t #{m.errors.messages.to_s}"
      end
    end

  end
end