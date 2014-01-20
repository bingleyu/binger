class Micropost < ActiveRecord::Base
  @@reply_to_regexp = /\A@([^\s]*)/
  belongs_to :user
  belongs_to :to, class_name: "User"
  has_many :comments, dependent: :destroy
  
  default_scope -> { order('created_at DESC') }
  before_save :extract_in_reply_to
  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true

  # Returns microposts from the users being followed by the given user.
  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id OR to_id = :user_id",
          user_id: user.id)
  end

  private
    def extract_in_reply_to
      if match = @@reply_to_regexp.match(content)
        user = User.find_by_shorthand(match[1])
        self.to=user if user
      end
    end
end
