class Comment
  attr_reader :user, :message, :date

  def initialize(user, date, message)
    @user = user
    @message = message
    @date = date
  end

end