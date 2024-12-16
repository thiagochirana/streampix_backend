class HomeController < ApplicationController
  def hello
    render plain: "Oi #{current_user.nickname}"
  end
end
