class MembershipsController < ApplicationController

  def update
    @membership = Membership.find(params[:id])
    @group = @membership.group
    authorize_user
    @membership.update_attributes(membership_params)
    render  "_update.js.erb", locals: { membership: @membership }
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
