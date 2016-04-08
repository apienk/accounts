require 'rails_helper'

feature 'User claims an unclaimed account', js: true do

  scenario 'a new user signs up and completes profile when an account is waiting', js: true do
    unclaimed_user = FindOrCreateUnclaimedUser.call(
      email:'unclaimeduser@example.com', username: 'therulerofallthings',
      password: "apassword", password_confirmation: "apassword"
    ).outputs[:user]
    visit '/'
    click_password_sign_up
    fill_in 'Email Address', with: 'unclaimedtestuser@example.com'
    fill_in 'Username', with: 'unclaimedtestuser'
    fill_in 'Password *', with: 'password'
    fill_in 'Confirm Password *', with: 'password'
    fill_in 'First Name', with: 'Test'
    fill_in 'Last Name', with: 'User'
    agree_and_click_create

    new_user = User.find_by_username('unclaimedtestuser')
    expect(new_user).to_not be_nil

    expect{
      create_email_address_for new_user, "unclaimeduser@example.com", '4242'
      visit '/confirm?code=4242'
      expect(page).to have_content('Thank you for verifying your email address')
    }.to change(User, :count).by(-1)
    expect{
        unclaimed_user.reload
    }.to raise_error(ActiveRecord::RecordNotFound)

  end

  xscenario 'a user is invited with password preset and accepts invitation' do
    address = 'unclaimeduser@example.com'

    unclaimed_user = FindOrCreateUnclaimedUser.call(
      email: address, username: 'user',
      password: "apassword", password_confirmation: "apassword"
    ).outputs[:user]

    open_email(address)

    click_email_link(reference: "Join OpenStax")

    # TODO instead of Invite verification page, sign them in and redirect them to profile page with
    # "Thanks for joining OpenStax" notice.

    expect(page).to have_content('Invite Verification')
    expect(page).to have_content('You can now sign in to your new account')
  end

  xscenario 'a user is invited WITHOUT password preset and accepts invitation' do
    address = 'unclaimeduser@example.com'

    unclaimed_user = FindOrCreateUnclaimedUser.call(
      email: address, username: 'user'
    ).outputs[:user]

    open_email(address)

    expect(unclaimed_user.email_addresses.first).not_to be_verified

    click_email_link(reference: "Join OpenStax")
# debugger
    expect(unclaimed_user.email_addresses.first).to be_verified
    expect(unclaimed_user.state).to eq 'unclaimed'

    expect(page).to have_content("Thanks for accepting")
# debugger
    fill_in 'Username', with: 'unclaimedtestuser'
    fill_in 'Password *', with: 'password'
    fill_in 'Confirm Password *', with: 'password'
    fill_in 'First Name', with: 'Test'
    fill_in 'Last Name', with: 'User'
    agree_and_click_create

    expect(page).to have_content("Your account")

  end

  def click_email_link(email: current_email, reference:)
    # This method exists because current_email.click_link('blah') fails for
    # unknown reasons

    link = email.find_link(reference)
    uri = URI.parse(link[:href])
    visit "#{uri.path}#{'?' + uri.query if uri.query.present?}"
  end
end
