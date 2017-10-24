[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

# STEEM Bot Framework

### Author
- [Github](https://github.com/@netuoso)
- [SteemIt](https://steemit.com/@netuoso)
- [Twitter](https://twitter.com/@netuoso)

### Features
- Default tags
- Failure logging
- Comment/Vote/Resteem
- Add comment beneficiary
- Custom json_metadata
- Customizable configuration
- Complete administration panel
- Automatic retry for certain failures

### Dependencies
- Ruby ~> 2.0
- Bundler ~> 1.14
- Linux/Mac/Windows

## Configuration Files
- Default Settings
	- `config/settings.yml`
- Environment Specific (takes precendence over defaults)
	- `config/environments/test.yml`
	- `config/environments/production.yml`
	- `config/environments/development.yml`

### Default Admin User
- user: `admin`
- password: `welcomeadmin`

### Quickstart Guide
- Click 'Deploy to Heroku' at the top of this Repo
- Log into your Heroku account
- Name your application
- Customize the environment variables
- Login with user: `admin`, password: `welcomeadmin`
- Go to https://your-app-name.herokuapp.com/admin and be sure to change your admin user's password

### Getting Started with Development
- `git clone https://github.com/netuoso/steem-bot-framework`
- `cd steem-bot-framework`
- `bundle exec rails sbf:setup`
- `bundle exec rails s`
- `http://localhost:3000/`

### Admin Interface
- `http://localhost:3000/admin`

### How to Regenerate SSL Certificate:
- `bundle exec rails sbf:create_certs`
- answer `yes` if replacing old certificate with new
	- replacing the SSL certificate will cause previously encrypted passwords to require a reset