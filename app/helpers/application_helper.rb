module ApplicationHelper
  def welcome_message
    if user_signed_in?
      "Welcome, #{current_user.email}"
    else
      "Welcome to Story Time! Sign in or Sign up."
    end
  end
end
