class HomeController < ApplicationController
  allow_unauthenticated_access only: [ :joke ]
  def hello
    render plain: "Oi #{current_user.nickname}"
  end

  def joke
    redirect_to "https://youtu.be/dQw4w9WgXcQ?si=M2P5XEkDp4aLAX3g&autoplay=1", allow_other_host: true
  end
end
