class SignupSocial < SignupBase

  paramify :signup do
    attribute :i_agree, type: boolean
    attribute :username, type: String
    validates :username, presence: true
    attribute :title, type: String
    attribute :first_name, type: String
    validates :first_name, presence: true
    attribute :last_name, type: String
    validates :last_name, presence: true
    attribute :email_address, type: String
    attribute :suffix, type: String
    attribute :contract_1_id, type: Integer
    attribute :contract_2_id, type: Integer
  end

  protected

  def handle
    self.user = caller

    add_email
    update_user
    agree_to_terms
  end

end
