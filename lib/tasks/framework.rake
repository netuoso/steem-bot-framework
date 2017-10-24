namespace :sbf do
  desc 'Set up the project, clear out database and recreate'
  task :setup => :environment do
    system 'bundle install'
    ['db:drop','db:create','db:migrate','db:seed'].each { |cmd| system "bundle exec rails #{cmd} RAILS_ENV=#{Rails.env}" }
    system 'bundle exec rails sbf:create_certs'
  end

  desc 'Generate SSL certificates for encrypting posting keys'
  task :create_certs => :environment do
    if File.file?("#{Rails.root}/ssl/key.pem")
      puts 'WARNING: Certificate already exists. Continue anyway? [no/yes]'
      case STDIN.gets.chomp
      when 'yes'
        Dir.chdir("#{Rails.root}/ssl") do
          system 'openssl genrsa -out key.pem 4096'
          system 'openssl rsa -in key.pem -pubout > key.pub'
        end
      when 'no'
        puts 'Aborted due to user request.'
      else
        puts 'Please enter yes or no. Aborted.'
      end
    else
      Dir.chdir("#{Rails.root}/ssl") do
        system 'openssl genrsa -out key.pem 4096'
        system 'openssl rsa -in key.pem -pubout > key.pub'
      end
    end
  end
end
