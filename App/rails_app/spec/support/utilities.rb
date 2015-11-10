include ApplicationHelper

def sign_in(user)
  visit signin_path 
  fill_in "Email",      with: user.email
  fill_in "Password",   with: user.password
  click_button "Sign in" 
  # Sign in when not using capybara as well
  cookies[:remember_token] = user.remember_token
end

def fill_with_valid_information(user)
  fill_in "Name",       with: user.name
  fill_in "Email",      with: user.email
  fill_in "Password",   with: user.password
  fill_in "Confirm Password",   with: user.password_confirmation
end

def invalid_email_addresses
  %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
end

def valid_email_addresses
  %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-error', text: message)
  end
end

RSpec::Matchers.define :have_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-success', text: message)
  end
end

RSpec::Matchers.define :have_title do |title|
  match do |page|
    page.should have_selector('title', text: title)
  end
end

RSpec::Matchers.define :have_valid_email do |email|
  match do |user|
    user.email = email 
    user.valid?
  end
end
