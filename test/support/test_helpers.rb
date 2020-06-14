module TestHelpers

  def self.ec2_client(region: 'us-east-1')
    Aws::EC2::Client.new(
      stub_responses: true,
      credentials: ::Aws::Credentials.new('access_key_id', 'secret_access_key'),
      # credentials: ::Aws::Credentials.new('AKIAJHDRQTHCWDPVDZAQ', 'Jrye4lzgzAsrHEiq606qXPTqv6PypGz0GyCOVu+R'),
      region: region,
    )
  end

  def self.logger
    Logger.new(RUBY_PLATFORM != 'i386-mingw32' ? '/dev/null' : 'NUL')
  end

end
