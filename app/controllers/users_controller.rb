class UsersController < ApplicationController
  def main
    if session[:current_user] && session[:current_user] != []
      redirect_to '/groups'
    end
    if session[:errors]
      @errors = []
      session[:errors].each do |error|
        @errors.push(error)
      end
      session[:errors] = []
    end
  end
  def login
    user = User.find_by(email: params[:user][:email])
    if !user || user.authenticate(params[:user][:password]) == false
      session[:errors] = ['Invalid Combination']
      redirect_to '/'
    else
      session[:current_user] = user.id
      redirect_to '/groups/'
    end
  end
  def create
    @user = User.create(user_params)
    @user.save
    if @user.valid?
      session[:current_user] = @user.id
      redirect_to '/groups/'
    else
      session[:errors] = @user.errors.to_a
      redirect_to '/'
    end
  end
  def logout
    session[:current_user] = []
    redirect_to '/'
  end
  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end
