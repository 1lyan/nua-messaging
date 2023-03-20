class MarkMessageRead
  attr_reader :message
  def initialize(message)
    @message = message
  end

  def execute
    message.update(read: true)
  end
end