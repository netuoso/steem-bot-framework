class User < ApplicationRecord
  has_paper_trail

  devise :database_authenticatable, :recoverable, 
         :rememberable, :trackable, :validatable

  has_many :user_permissions
  has_many :permissions, through: :user_permissions

  validates :username, presence: true, uniqueness: { case_sensitive: false }

  before_create :assign_api_key
  before_save :assign_api_key, if: ->(record) {!record.api_key.present?}

  def name
    self.email
  end

  def bots
    permissions.includes(:bot).collect { |x| x.bot if x.bot.posting_key? }.reject { |x| x.nil? }.uniq
  end

  def list_permissions
    self.permissions.pluck(:action).uniq
  end

  private

  def assign_api_key
    self.api_key = (0..30).map { (65 + rand(26)).chr }.join
  end

end
