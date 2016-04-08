class ConfirmUnclaimedAccount

  lev_handler

  protected

  def setup
    @user_state = options[:user_state]
  end

  def authorized?
    true
  end

  # Plan: signing in here and leaving in an unclaimed state will get caught by `finish_sign_up`
  # which will redirect them to `signup/invited`.  That will post to CustomIdentity which will
  # call `SignupPassword` (will need a change to know `signup/invited` is an OK path).
  # SignupPassword can probably work like normal? (thought it might need to call MergedUnclaimedUsers
  # but that might actually be ok just from ContactInfosConfirm).
  # Need to make sure that if someone clicks link in email but doesn't finish signup that they
  # can click the link in the email again later and get back to finish sign up; worried that
  # will get an error when trying to confirm the email a second time
  # Invited sign up needs some kind of banner "Thanks for clicking, etc"
  # Check SessionsCallback that the sign in states are correct (unclaimed users are different
  # than password users b/c they are already logged in)
  #
  # Maybe this shouldn't be called "ConfirmUnclaimed" it is really more of accepting the invite.
  # change file names and DB name.  When move it, split confirm_unclaimed.html.erb into two
  # pages.
  #
  # `can_log_in` is OBE
  #
  # Signup handlers should use template method -- all three need different parts of the puzzle

  def handle
    fatal_error(code: :no_contact_info_for_code,  # TODO duplicated in ContactInfosConfirm
                message: 'Unable to verify email address') if params[:code].nil?

    contact_info = ContactInfo.where(confirmation_code: params[:code]).first

    fatal_error(code: :no_contact_info_for_code,
                message: 'Unable to verify email address') \
      if contact_info.nil? || !contact_info.user.is_unclaimed?

    outputs[:email_address] = contact_info.value

    run(MarkContactInfoVerified, contact_info)
    sign_in!(contact_info.user)
  end

  protected

  def sign_in!(user)
    @user_state.sign_in!(user)
  end

end
