module KinopoiskAPI
  class PeopleSearch < Agent
    attr_accessor :keyword, :url

    def initialize(keyword)
      @keyword    = URI.encode(keyword)
      @page       = 1
      gen_url
      @json       = json
      @page_count = @json['pagesCount']
    end

    def peoples_count
      @json['searchPeoplesCountResult']
    end

    def view
      @json['searchPeople'].map do |film|
        people_hash(film)
      end
    end

    private

      def gen_url
        @url = [
          "#{DOMAINS[:api]}/#{METHODS[:search_people][:method]}",
          "?#{METHODS[:search_people][:keyword]}=#{@keyword}",
          "&#{METHODS[:search_people][:page]}=#{@page}"
        ].join('')
      end

  end
end
