require 'adwords_api'

module AdsCommon
  module Auth
    OAuth2Handler.class_eval do
      # Overrides base get_token method to account for the token expiration.
      def get_token(credentials = nil)
        token = super(credentials)
        unless @client.nil?
          @client.issued_at = Time.parse(@client.issued_at) if @client.issued_at.class.name == 'String'
          token = refresh_token! if @client.expired?
        end
        return token
      end
    end
  end
end