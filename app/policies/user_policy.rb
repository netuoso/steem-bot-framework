class UserPolicy < ApplicationPolicy

  def is_admin?
    user&.admin?
  end

  def verify_api_key
    Rails.logger.info { "[UserPolicy] Verify Api Key -- User: #{user.username}, ProvidedApiKey: #{user.provided_api_key}, ActualApiKey: #{user.api_key}"}
    user && user.api_key == user.reload.provided_api_key
  end

  Bot.pluck(:username).each do |bot_name|
    define_method "#{bot_name.gsub('-','_')}_vote_allowed?" do
      user ? user.permissions.where(action: 'vote').map(&:bot).include?(Bot.find_by(username: bot_name)) : false
    end
    define_method "#{bot_name.gsub('-','_')}_comment_allowed?" do
      user ? user.permissions.where(action: 'comment').map(&:bot).include?(Bot.find_by(username: bot_name)) : false
    end
    define_method "#{bot_name.gsub('-','_')}_resteem_allowed?" do
      user ? user.permissions.where(action: 'resteem').map(&:bot).include?(Bot.find_by(username: bot_name)) : false
    end
  end

end