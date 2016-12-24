def login(user)
  visit login_path
  fill_in 'Username', with: user.username
  fill_in 'Password', with: user.password
  click_button 'Log In'
end

def direct_login(user)
  session[:user_id] = user.id
end

def current_user
  User.find(session[:user_id]) if session[:user_id]
end

def current_user?(user)
  current_user == user
end

def logged_in?
  !session[:user_id].nil?
end