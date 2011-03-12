require 'oauth/tokens/access_token'

module OStatus
  class Feed
    def initialize(access_token, url)
      @url = url
      @access_token = access_token
    end

    def retrieve_atom
      @access_token.get(@url)
    end

    def entries
      atom = retrieve_atom()

    end
  end
end
