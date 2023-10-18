class DemoSessionsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_user

  def create
    sign_in(@user)
    redirect_to root_path
  end

  def set_user
    @user = User.find_by(email: "alice@fake.com")
  end
end
