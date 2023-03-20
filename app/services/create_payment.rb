class CreatePayment
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def execute
    user.payments.create!
  end
end