class Message < ApplicationRecord

  belongs_to :inbox
  belongs_to :outbox

  validates :body, presence: true
  validates :body, length: { maximum: 500 }

  scope :unread, -> { where(read: false) }

  def sent_more_than_a_week_ago?
    created_at < DateTime.current.ago(7.days)
  end

  def sent_less_than_a_week_ago?
    !sent_more_than_a_week_ago?
  end

  self.per_page = 10

end