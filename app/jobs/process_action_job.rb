class ProcessActionJob < ApplicationJob
  queue_as :process_action

  attr_reader :response

  after_perform do |job|
    bot, action, options = job.arguments[0], job.arguments[1], job.arguments[2]

    if @response.error.present? && @response.error.message.match(/bandwidth/)
      # Happens when an account is over bandwidth; could also indicate Steem network issues
      Rails.logger.error { "[ProcessActionJob - Bandwidth Error] #{bot.username} is over bandwidth limit. Waiting 60 seconds and retrying." }
      ProcessActionJob.set(wait_until: 60.seconds.from_now).perform_later(bot, action, options)

    elsif @response.error.present? && @response.error.message.match(/trx\.ref_block_prefix\s==\stapos_block_summary\.block_id\._hash/)
      # Random error that happens when a TX hits a node in a fork
      Rails.logger.error { "[ProcessActionJob - Fork Error] #{bot.username} ran into an error while trying to #{action} with options: #{options}."\
                           "Error: #{@response.error.message}" }
      ProcessActionJob.set(wait_until: 60.seconds.from_now).perform_later(bot, action, options)

    elsif @response.error.present? && @response.error.message.match(/STEEMIT_MIN_ROOT_COMMENT_INTERVAL/)
      # Happens when an account is posting faster than once every 300 seconds
      Rails.logger.error { "[ProcessActionJob - Post Error] #{bot.username} is posting too fast. Waiting 305 seconds and retrying." }
      ProcessActionJob.set(wait_until: 305.seconds.from_now).perform_later(bot, action, options)

    elsif @response.error.present? && @response.error.message.match(/STEEMIT_MIN_REPLY_INTERVAL/)
      # Happens when an account is commenting faster than once every 20 seconds
      Rails.logger.error { "[ProcessActionJob - Comment Error] #{bot.username} is commenting too fast. Waiting 25 seconds and retrying." }
      ProcessActionJob.set(wait_until: 25.seconds.from_now).perform_later(bot, action, options)

    elsif @response.error.present? && @response.error.message.match(/STEEMIT_MIN_VOTE_INTERVAL_SEC/)
      # Happens when an account is voting faster than once every 3 seconds
      Rails.logger.error { "[ProcessActionJob - Vote Error] #{bot.username} is commenting too fast. Waiting 4 seconds and retrying." }
      ProcessActionJob.set(wait_until: 4.seconds.from_now).perform_later(bot, action, options)

    elsif @response.error.present? && @response.error.message.match(/You\shave\salready\svoted\sin\sa\ssimilar\sway/)
      # Happens when an account has already voted on the post/comment with the same weight
      Rails.logger.error { "[ProcessActionJob - Vote Error] #{bot.username} has already voted in a similar way. Skipping." }

    elsif @response.error.present?
      # Unknown, unhandled errors
      Rails.logger.error { "[ProcessActionJob - Unknown] #{bot.username} ran into an error while trying to #{action} with options: #{options}."\
                           "Error: #{@response.error.message}" }
    end
  end

  def perform(bot, action, options)
    @response = bot.send(action, options)
  end
end