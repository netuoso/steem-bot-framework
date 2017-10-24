require 'openssl'
require 'base64'

class SslService
  def self.encrypt(data)
    public_key_file = Rails.root + 'ssl/key.pub';

    public_key = OpenSSL::PKey::RSA.new(File.read(public_key_file))
    encrypted_string = Base64.encode64(public_key.public_encrypt(data))
  end

  def self.decrypt(data)
    private_key_file = Rails.root + 'ssl/key.pem';

    encrypted_string = %Q{#{data}}

    private_key = OpenSSL::PKey::RSA.new(File.read(private_key_file))
    string = private_key.private_decrypt(Base64.decode64(encrypted_string))
  end
end