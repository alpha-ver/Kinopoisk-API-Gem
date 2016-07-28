module KinopoiskAPI
  class GlobalSearch
    attr_accessor :keyword, :url, :json

    def initialize(keyword)
      @keyword = keyword
      @url = "#{DOMAINS[:api]}/#{METHODS[:search_global][:method]}?#{METHODS[:search_global][:keyword]}=#{keyword}"
      @json = json
    end

    def keyword
      @json['keyword']
    end

    def number_of_films
      @json['searchFilmsCountResult']
    end

    def number_of_names
      @json['searchPeoplesCountResult']
    end

    def exactly
      # rating_array = json['rating'].delete(' ').split('(')
      # {
      #     title: json['nameRU'],
      #     original_title: json['nameEN'],
      #     info: json['description'],
      #     duration: json['filmLength'],
      #     year: json['year'],
      #     countries: json['country'],
      #     genres: json['genre'],
      #     rating: rating_array.first,
      #     number_of_rated: rating_array.last.delete(')'),
      #     poster: "#{DOMAINS[:kinopoisk][:poster][:film]}_#{json['id']}.jpg"
      # }

      json['rating']

      json
    end

    def maybe
      correctly = []
      json_films.each do |film|
        rating_array = film['rating'].delete(' ').split('(')
        new_item = {
            title: film['nameRU'],
            original_title: film['nameEN'],
            info: film['description'],
            duration: film['filmLength'],
            year: film['year'],
            countries: film['country'],
            genres: film['genre'],
            rating: rating_array.first,
            number_of_rated: rating_array.last.delete(')'),
            poster: "#{DOMAINS[:kinopoisk][:poster][:film]}_#{film['id']}.jpg"
        }
        correctly.push(new_item)
      end
      correctly
    end

    def names
      correctly = []
      json_names.each do |name|
        new_item = {
            full_name: name['nameRU'],
            original_full_name: name['nameEN'],
            info: name['description'],
            duration: name['filmLength'],
            poster: "#{DOMAINS[:kinopoisk][:poster][:name]}_#{name['id']}.jpg"
        }
        correctly.push(new_item)
      end
      correctly
    end

    private

    def json
      uri = URI(URI.encode(@url))
      response = Net::HTTP.get(uri)

      JSON.parse(response)
    end

    def json_films
      @json['searchFilms']
    end

    def json_names
      @json['searchPeople']
    end

  end
end