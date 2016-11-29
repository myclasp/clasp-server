class MembershipsController < ApplicationController

  def update
    @membership = Membership.find(params[:id])
    @group = @membership.group
    authorize_user
    @membership.update_attributes(membership_params)
    render  "_update.js.erb", locals: { membership: @membership }
  end

  def create
    @group = Group.find(params[:group_id])
    @membership = @group.memberships.build(role: "member")
    authorize_user

    user = User.find_by(email: params[:email])

    notice = "Couldn't add user"
    notice = "Couldn't find user with email #{params[:email]}" if user.blank?

    @membership.user = user
    
    if @membership.save
      redirect_to edit_group_path(@group)
    else
      flash[:notice] = notice
      redirect_to edit_group_path(@group)
    end
  end

  private

  def authorize_user
    unless current_user and (current_user.is_admin or @group.is_admin?(current_user))
      flash[:notice] = "You're not authorised to view this page."
      redirect_to root_path 
    end
  end

  def membership_params
    params.require(:membership).permit(:role)
  end


end
