require 'openssl'
require 'base64'

class SslService
  def self.encrypt(data)
    Base64.encode64(data.encrypt(ENV['SECRET_KEY_BASE']))
  end

  def self.decrypt(data)
    Base64.decode64(data).decrypt(ENV['SECRET_KEY_BASE'])
  end
end

class String
  def encrypt(key)
    cipher = OpenSSL::Cipher::Cipher.new('DES-EDE3-CBC').encrypt
    cipher.key = Digest::SHA1.hexdigest key
    s = cipher.update(self) + cipher.final

    s.unpack('H*')[0].upcase
  end

  def decrypt(key)
    cipher = OpenSSL::Cipher::Cipher.new('DES-EDE3-CBC').decrypt
    cipher.key = Digest::SHA1.hexdigest key
    s = [self].pack("H*").unpack("C*").pack("c*")

    cipher.update(s) + cipher.final
  end
end