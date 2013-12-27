class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  has_many :replies, foreign_key: "to_id", class_name: "Micropost"

  before_save { self.email = email.downcase }
  before_create :create_remember_token
  VALID_NAME_REGEX = /\A[^_]{2,20}\Z/              
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true, 
                   format: { with: VALID_NAME_REGEX },
                   uniqueness: { case_sensitive: false }
  
  validates :email, presence: true,
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, length: { minimum: 6 }

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def feed
    Micropost.from_users_followed_by(self)
  end

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy!
  end

  def send_password_reset
    self.password_reset_token = User.new_token
    self.password_reset_sent_at = Time.zone.now
    self.save(validate: false)
    UserMailer.password_reset(self).deliver
  end

  def shorthand
   # name.gsub(/\s*/,"")
   name.gsub(/ /,"_")
  end

  def self.shorthand_to_name(sh)
   # name.gsub(/\s*/,"")
   sh.gsub(/_/," ")
  end

  def self.find_by_shorthand(shorthand_name)
    all = where(name: User.shorthand_to_name(shorthand_name))
    return nil if all.empty?
    all.first
  end

  def self.search(search)
    if search
      where('name LIKE ?', "%#{search}%")
    else
      scoped
    end
  end
  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_token)
    end
end
