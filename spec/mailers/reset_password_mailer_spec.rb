require 'rails_helper'

describe ResetPasswordMailer, type: :mailer do
  describe 'reset_password' do
    before :each do
      @user = FactoryGirl.create :user, username: 'user1', first_name: 'John', last_name: 'Doe', suffix: 'Jr.'
      @email = FactoryGirl.create :email_address, user: @user
      @mail = ResetPasswordMailer.reset_password @email, '1234'
    end

    it 'renders the headers' do
      expect(@mail.subject).to eq('[OpenStax] Reset your password')
      expect(@mail.header['to'].to_s).to eq("\"John Doe Jr.\" <#{@email.value}>")
      expect(@mail.from).to eq(['noreply@openstax.org'])
    end

    it 'renders the body' do
      expect(@mail.body.encoded).to include('Hi John')
      expect(@mail.body.encoded).to include('http://nohost/reset_password?code=1234')
    end
  end
end