class TwitterClient
    attr_reader :authentication

    def initialize(authentication)
      @authentication = authentication
    end

    def client
      @client ||= Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV['TWITTER_CLIENT_ID']
        config.consumer_secret     = ENV['TWITTER_CLIENT_SECRET']
        config.access_token        = authentication.access_token
        config.access_token_secret = extract_token_secret
      end
    end

    def post(text)
      client.update(text)
    end

    private

    def extract_token_secret
      if authentication.info && authentication.info['credentials']
        authentication.info['credentials']['token_secret']
      end
  end
end
