class Bot < ApplicationRecord
  has_many :permissions
  has_many :documents

  scope :has_posting_key, lambda { where('posting_key is not NULL') }
  before_save :encrypt_posting_key, if: -> (record) { record.posting_key.present? && record.posting_key.length < 52 }

  def name
    self.username
  end

  def vote(options)
    return unless self.posting_key
    Rails.logger.info { "[Vote] Options: #{options}" }

    comment_permlink_with_timestamp = "this-post-received-an-upvote-from-#{Settings.framework_name.downcase.gsub(/(\s|_)/,'-')}-#{Time.now.to_i}"

    tx = Radiator::Transaction.new(url: Settings.primary_steemd_node, wif: self.decrypted_posting_key)
    vote_tx = generate_vote_tx(options.fetch(:author), options.fetch(:permlink), options.fetch(:power))

    framework_attribution_text = "This post received a #{options.fetch(:power)}\% vote by @#{self.username} courtesy of @#{options.fetch(:app_user)}."

    attribution_comment_tx = generate_comment_tx(
                              self.username,
                              comment_permlink_with_timestamp,
                              "This post received an upvote from #{Settings.framework_name}.",
                              framework_attribution_text,
                              options.fetch(:permlink),
                              options.fetch(:author),
                              nil)

    tx.operations << vote_tx
    tx.operations << attribution_comment_tx
    tx.operations << beneficiary_op(self.username, comment_permlink_with_timestamp) if Settings.framework_beneficiary_enabled
    tx.process(true)
  end

  def comment(options)
    return unless self.posting_key
    Rails.logger.info { "[Comment] Options: #{options}" }

    comment_permlink_with_timestamp = "#{options.fetch(:permlink)}-#{Time.now.to_i}"

    tx = Radiator::Transaction.new(url: Settings.primary_steemd_node, wif: self.decrypted_posting_key)
    comment_tx = generate_comment_tx(
                  options.fetch(:author),
                  comment_permlink_with_timestamp,
                  options.fetch(:title),
                  options.fetch(:body),
                  options.fetch(:parent_permlink),
                  options.fetch(:parent_author),
                  options.fetch(:tags))

    tx.operations << comment_tx
    tx.operations << beneficiary_op(self.username, comment_permlink_with_timestamp) if Settings.framework_beneficiary_enabled
    tx.process(true)
  end

  def resteem(options)
    return unless self.posting_key
    Rails.logger.info { "[Resteem] Options: #{options}" }

    comment_permlink_with_timestamp = "this-post-has-been-resteemed-from-#{Settings.framework_name.downcase.gsub(/(\s|_)/,'-')}-#{Time.now.to_i}"

    tx = Radiator::Transaction.new(url: Settings.primary_steemd_node, wif: self.decrypted_posting_key)
    reblog_tx = generate_reblog_tx(options.fetch(:author), options.fetch(:permlink))

    framework_attribution_text = "This post has been resteemed by @#{self.username} courtesy of #{Settings.framework_name}."

    attribution_comment_tx = generate_comment_tx(
                              self.username,
                              comment_permlink_with_timestamp,
                              "This post has been resteemed from #{Settings.framework_name}.",
                              framework_attribution_text,
                              options.fetch(:permlink),
                              options.fetch(:author),
                              nil)

    tx.operations << reblog_tx
    tx.operations << attribution_comment_tx
    tx.operations << beneficiary_op(self.username, comment_permlink_with_timestamp) if Settings.framework_beneficiary_enabled
    tx.process(true)
  end

  def self.stream(tx_types=:account_witness_vote)
    # transfer_to_vesting, withdraw_vesting, interest, transfer, liquidity_reward, author_reward
    # curation_reward, transfer_to_savings, transfer_from_savings, cancel_transfer_from_savings
    # escrow_transfer, escrow_approve, escrow_dispute, escrow_release, comment, limit_order_create
    # limit_order_cancel, fill_convert_request, fill_order, vote, account_witness_vote
    # account_witness_proxy, account_create, account_update, witness_update, pow

    stream = Radiator::Stream.new(url: Settings.primary_steemd_node)

    Rails.logger.info { "[Stream] Started streaming. Use Ctrl+C to exit." }

    stream.operations(tx_types) do |tx|
      puts tx
    end
  end

  private

  # Posting Key Security
  def encrypt_posting_key
    self.posting_key = SslService.encrypt(self.posting_key)
  end

  # Posting Key Security
  def decrypted_posting_key
    SslService.decrypt(self[:posting_key]) if self.posting_key.present?
  end

  # Vote Action
  def generate_vote_tx(author, permlink, power)
    {
      type: :vote,
      voter: self.username,
      author: author,
      permlink: permlink,
      weight: power.to_i*100
    }.merge(framework_attribution)
  end

  # Comment Action
  def generate_comment_tx(author, permlink, title, body, parent_permlink, parent_author, tags)
    {
      type: :comment,
      author: author,
      permlink: permlink,
      title: title,
      body: body,
      parent_permlink: parent_permlink ? parent_permlink : tags,
      parent_author: parent_author,
    }.merge(framework_attribution(tags))
  end

  # Resteem Action
  def generate_reblog_tx(author, permlink)
    {
      type: :custom_json,
      required_auths: [],
      required_posting_auths: [self.username],
      id: 'follow',
      json: ['reblog',{account: self.username, author: author, permlink: permlink}].to_json
    }.merge(framework_attribution)
  end

  # Beneficiary Option
  def beneficiary_op(author, permlink)
      Radiator::Operation.new(
        type: :comment_options,
        author: author,
        permlink: permlink,
        max_accepted_payout: '1000000.000 SBD',
        percent_steem_dollars: 10000,
        allow_replies: true,
        allow_votes: true,
        allow_curation_rewards: true,
        extensions: Radiator::Type::Beneficiaries.new(Settings.framework_beneficiary => 500)
      )
  end

  def framework_attribution(tags=[])
    {
      json_metadata: {
        tags: tags&.class == Array ? tags.append(Settings.default_posting_tags.split(',')) : Settings.default_posting_tags.split(','),
        app: "#{Settings.framework_name}",
        format: 'markdown+html',
        community: "#{Settings.community_name}"
      }.to_json
    }
  end

end
