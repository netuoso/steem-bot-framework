module ApplicationHelper

  def bootstrap_class_for(flash_type)
    case flash_type
    when "success"
      "alert-success"   # Green
    when "error"
      "alert-danger"    # Red
    when "alert"
      "alert-warning"   # Yellow
    when "notice"
      "alert-info"      # Blue
    else
      flash_type.to_s
    end
  end

  def current_user_is_admin?
    current_user && current_user.is_admin?
  end

  def parse_steem_url(url='')
    # Parses a SteemIt.com url and returns the supported actions and matched groups
    if url.match(/^https:\/\/steemit\.com\/(?<post_parent_permlink>(\w|\d|-)*)\/@(?<post_author>(\w|\d|-|\.)*)\/(?<post_permlink>(\w|\d|-)*)$/).present?
      regex_match = url.match(/^https:\/\/steemit\.com\/(?<post_parent_permlink>(\w|\d|-)*)\/@(?<post_author>(\w|\d|-|\.)*)\/(?<post_permlink>(\w|\d|-)*)$/)
      supported_actions = ['actions',['vote','resteem','comment']]
    elsif url.match(/^https:\/\/steemit\.com\/(?<post_parent_permlink>(\w|\d|-)*)\/@(?<post_author>(\w|\d|-|\.)*)\/(?<post_permlink>(\w|\d|-)*)#@(?<comment_author>(\w|\d|-)*)\/(?<comment_permlink>(\w|\d|-)*)$/).present?
      regex_match = url.match(/^https:\/\/steemit\.com\/(?<post_parent_permlink>(\w|\d|-)*)\/@(?<post_author>(\w|\d|-|\.)*)\/(?<post_permlink>(\w|\d|-)*)#@(?<comment_author>(\w|\d|-)*)\/(?<comment_permlink>(\w|\d|-)*)$/)
      supported_actions = ['actions',['vote','resteem','comment']]
    end

    if regex_match
      captured_groups = regex_match.names
      captured_values = regex_match.captures
      Rails.logger.info { "[ParseUrl]: Group Names: #{captured_groups}, Captured Values: #{captured_values}, Action: #{supported_actions}"}
      Hash[captured_groups.zip(captured_values).push(supported_actions)]
    end
  end

end
