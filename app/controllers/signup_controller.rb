class SignupController < ApplicationController

  protect_from_forgery :except => [:create_user]
  respond_to :json

  def create_user
    user = User.new(user_params)

    if user.save
      render :json => { success:true, email: user.email, id: user.uuid }, status: 201
      return
    else
      warden.custom_failure!
      render :json => { success:false, errors: user.errors }, status: 422
    end
  end

  def user_params
    params[:user][:password_confirmation] = "" unless params[:user].has_key? :password_confirmation 
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

end
