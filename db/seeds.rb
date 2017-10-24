# Create Bot
Bot.create!([
  { username: "bot1", posting_key: '5THISISNOTAREALKEY' }
])

# Create Admin User
@admin = User.create!(username: 'admin',
                      email: 'admin@admin.com',
                      admin: true,
                      password: 'welcomeadmin',
                      password_confirmation: 'welcomeadmin')

# Setup Permissions For Vote/Comment/Resteem on All Bots
Bot.all.each do |bot|
  x = Permission.create!(action: "vote", bot: bot)
  y = Permission.create!(action: "comment", bot: bot)
  z = Permission.create!(action: "resteem", bot: bot)
  [x,y,z].each do |perm|
    UserPermission.create!(user_id: @admin.id, permission_id: perm.id)
  end
end

Rails.logger.info { "Created #{Bot.count} bot(s), #{Permission.count} permission(s), and #{User.count} user(s)." }
