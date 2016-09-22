class AuthenticationController < ApplicationController

  protect_from_forgery :except => [:authenticate_user]

  def authenticate_user
    user = User.find_for_database_authentication(email: params[:email])
    if user.valid_password?(params[:password])
      render json: { success: true, email: user.email, id: user.uuid }
    else
      render json: { success: false,  errors: ['Invalid Username/Password']}, status: :unauthorized
    end
  end

end
