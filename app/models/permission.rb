class Permission < ApplicationRecord
  has_paper_trail

  belongs_to :bot

  default_scope { joins(:bot) }

  def name
    bot ? "#{self.action}_#{self.bot.username.gsub('-','_')}" : ""
  end

end