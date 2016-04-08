class SignupBase

  lev_handler

  uses_routine CreateUser,
               translations: { inputs: {scope: :signup} }
  uses_routine CreateIdentity,
               translations: { inputs:  {scope: :signup},
                               outputs: {type: :verbatim}  }
  uses_routine AddEmailToUser,
               translations: { inputs: {scope: :signup} }
  uses_routine AgreeToTerms

  protected

  attr_accessor :user

  def authorized?
    OSU::AccessPolicy.action_allowed?(:signup, caller, caller)
  end

  def create_password_user
    run(CreateUser, username: signup_params.username,
                    title: (signup_params.title if signup_params.title.blank?),
                    first_name: signup_params.first_name,
                    last_name: signup_params.last_name,
                    suffix: (signup_params.suffix if !signup_params.suffix.blank?),
                    state: 'activated')
    self.user = outputs[[:create_user, :user]]

    # Create an Identity, but not an Authentication -- that is done in SessionsCallback
    run(CreateIdentity,
        password:              signup_params.password,
        password_confirmation: signup_params.password_confirmation,
        user_id:               user.id)
  end

  def update_user
    user.username = signup_params.username
    user.title = signup_params.title if !signup_params.title.blank?
    user.first_name = signup_params.first_name
    user.last_name = signup_params.last_name
    user.suffix = signup_params.suffix if !signup_params.suffix.blank?
    user.state = 'activated' # was 'new_social'
    user.save

    transfer_errors_from(user, {type: :verbatim}, true)
  end

  def add_email
    if user.email_addresses.empty?
      if signup_params.email_address.blank?
        fatal_error(code: :email_address_required,
                    message: 'You must provide an email address to create your account.')
      else
        run(AddEmailToUser, signup_params.email_address, user)
      end
    end
  end

  def agree_to_terms
    if options[:contracts_required]
      if !signup_params.i_agree
        fatal_error(code: :did_not_agree, message: 'You must agree to the terms to create your account.')
      end

      run(AgreeToTerms, signup_params.contract_1_id, user, no_error_if_already_signed: true)
      run(AgreeToTerms, signup_params.contract_2_id, user, no_error_if_already_signed: true)
    end
  end

end
