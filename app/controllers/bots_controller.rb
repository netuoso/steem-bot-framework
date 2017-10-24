class BotsController < BaseController

  def index
    @permitted_bots = current_user.bots.pluck(:username)
    @permitted_actions = current_user.permissions.collect { |permission| permission.action }.uniq
  end

  def perform_action
    params[:bots].each do |bot|
      authorize current_user, "#{bot.gsub('-','_')}_#{params[:bot_action]}_allowed?"
    end

    bots = Bot.where(username: params[:bots])

    bots.each do |bot|
      action_options =
        case params[:bot_action]
        when 'vote'
            {
              app_user: vote_params[:app_user].present? ? vote_params[:app_user] : current_user.username,
              author: vote_params[:author],
              permlink: vote_params[:permlink],
              power: vote_params[:power]
            }

        when 'comment'
            {
              app_user: current_user.username,
              author: bot.username,
              permlink: comment_params[:permlink],
              title: comment_params[:title],
              body: comment_params[:body],
              parent_permlink: comment_params[:parent_permlink],
              parent_author: comment_params[:parent_author],
              tags: comment_params[:tags]
            }

        when 'resteem'
            {
              app_user: resteem_params[:app_user].present? ? resteem_params[:app_user] : current_user.username,
              author: resteem_params[:author],
              permlink: resteem_params[:permlink]
            }
        end

      Rails.logger.info { "[BotsController] Scheduling #{bot.username} to #{params[:bot_action]} with options: #{action_options}" }
      ProcessActionJob.set(wait_until: 5.seconds.from_now).perform_later(bot,params[:bot_action],action_options)
    end

    redirect_to root_path, notice: "Bot(s) #{params[:bots].join(', ')} scheduled to #{params[:bot_action]} as soon as possible."
  end

  def parse_url
    begin
      render json: {success: true, response: parse_steem_url(params.permit(:steemit_url)['steemit_url'])}
    rescue => e
      Rails.logger.error { "[ParseURL] Error: #{e}. Backtrace: #{e.backtrace.first(10)}"}
      render json: {success: false, error: e, backtrace: e.backtrace.first(10)}
    end
  end

  private

  def vote_params
    params.permit(:app_user,:bots,:author,:permlink,:power)
  end

  def comment_params
    params.permit(:permlink,:title,:body,:parent_permlink,:parent_author,:tags)
  end

  def resteem_params
    params.permit(:app_user,:bots,:author,:permlink)
  end

end
