class UsersController < ApplicationController
  def sign_up
    permitted_params = params[:user].permit(:email, :password)
    user = User.create(permitted_params)
    token = user.tokens.create

    response = {
      token: {
        value: token.value
      }
    }

    render json: response, status: :created
  end
end
