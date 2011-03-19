class ApplicationController < ActionController::Base
  around_filter :select_shard

  protect_from_forgery
  layout 'application'

  def select_shard(&block)
    if user_signed_in?
      Octopus.using(current_user.country.to_sym, &block)
    else
      yield     
    end
  end
  
  def after_sign_in_path_for(resource)
    resource.is_a?(User) ? items_path : super  
  end
end
