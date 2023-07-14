class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user
  has_many :post_comments, dependent: :destroy
  has_many :week_favorites, -> { where(created_at: 1.week.ago.beginning_of_day..Time.current.end_of_day) }
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
  
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end 
  
  def self.search_for(content, method)
    if method == 'perfect'
     @book = Book.where("title LIKE?","#{content}")
    elsif method == 'forward'
     @book = Book.where("title LIKE?","#{content}%")
    elsif method == 'backward'
     @book = Book.where("title LIKE?","%#{content}")
    elsif search == "partial_match"
     @book = Book.where("title LIKE?","%#{content}%")
    
  else
    @book = Book.all
    end 
  end 
end
