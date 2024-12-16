class UsersController < ApplicationController
  include ActionView::Helpers::DateHelper

  def about_me
    me = current_user
    render json: {
      nickname: me.nickname,
      email: me.email,
      registered_since: time_ago_in_words(me.created_at),
      last_update: time_ago_in_words(me.updated_at)
    }
  end
end
