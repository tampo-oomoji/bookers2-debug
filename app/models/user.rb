class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :books, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :messages, dependent: :destroy
  
  has_many :entries, dependent: :destroy

  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy

  has_many :followings, through: :relationships, source: :followed
  has_many :followers, through: :reverse_of_relationships, source: :follower



  has_one_attached :profile_image

  validates :name, presence: true

  validates :introduction, length:  { maximum: 50 }
  validates :name, length: { in: 2..20 }, uniqueness: true





  # def get_profile_image
  #   (profile_image.attached?) ? profile_image : 'no_image.jpg'
  # end
  def follow(user)
    relationships.create(followed_id: user.id)
  end

  def unfollow(user)
    relationships.find_by(followed_id: user.id).destroy
  end

  def following?(user)
    followings.include?(user)
  end

   def get_profile_image(width, height)
     unless profile_image.attached?
     file_path = Rails.root.join('app/assets/images/no_image.jpg')
     profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
     end
     profile_image.variant(resize_to_limit: [width, height]).processed
   end

   def self.search_for(content, method)
     if method == 'perfect'
       @user = User.where("name LIKE?", "#{content}" )
     elsif method == 'forward'
       @user = User.where("name LIKE?", "#{content}%" )
     elsif method == 'backward'
       @user = User.where('name LIKE?', "%#{content}" )
     elsif method == "partical"
       @user = User.where('name LIKE?', "%#{content}%" )
     else 
       @user = User.all
     end
   end


end
