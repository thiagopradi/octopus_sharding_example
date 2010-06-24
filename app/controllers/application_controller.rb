class ApplicationController < ActionController::Base
  around_filter :select_shard

  protect_from_forgery
  layout 'application'

  def select_shard()
    if user_signed_in?
      using(current_user.country.to_sym) { yield }
    else
      yield     
    end
  end
end
