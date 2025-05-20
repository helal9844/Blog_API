class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  
  has_many :post_tags
  has_many :tags, through: :post_tags

  validates :title, presence: true
  validates :body, presence: true
  validate :must_have_at_least_one_tag

  # after_create_commit :schedule_deletion

  # def schedule_deletion
  #   DeleteExpiredPostsJob.perform_in(24.hours)
  # end

  private

  def must_have_at_least_one_tag
    errors.add(:tags, "must have at least one tag") if tags.empty?
  end
end
