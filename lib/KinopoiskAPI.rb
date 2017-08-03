require 'net/http'
require 'KinopoiskAPI/api_error'
require 'KinopoiskAPI/agent'
require 'KinopoiskAPI/film'
require 'KinopoiskAPI/people'
require 'KinopoiskAPI/category'
require 'KinopoiskAPI/today'
require 'KinopoiskAPI/top'
require 'KinopoiskAPI/global_search'
require 'KinopoiskAPI/film_search'
require 'KinopoiskAPI/people_search'


#require 'KinopoiskAPI/reviews'
#require 'KinopoiskAPI/gallery'
#require 'KinopoiskAPI/similar'

require 'KinopoiskAPI/version'


module KinopoiskAPI
  DOMAINS = {
      api: 'http://kp_api.alphav.ru',

      kinopoisk: {
          main: 'https://www.kinopoisk.ru',
          poster: {
              film: 'https://st.kp.yandex.net/images/film_iphone/iphone360',
              name: 'https://st.kp.yandex.net/images/actor_iphone/iphone360',
              gallery: 'https://st.kp.yandex.net/images'
          }
      }
  }

  METHODS = {
      get_film: {
        method: 'getKPFilmDetailView',
        id: 'filmID'
      },
      get_staff: {
        method: 'getStaffList',
        id: 'filmID'
      },
      get_gallery: {
          method: 'getGallery',
          id: 'filmID'
      },
      get_similar: {
          method: 'getKPFilmsList',
          type: 'kp_similar_films',
          id: 'filmID'
      },

      navigator_filters:{
        method: 'navigatorFilters'
      },

      get_reviews: {
          method: 'getKPReviews',
          id: 'filmID'
      },
      get_review_detail: {
          method: 'getReviewDetail',
          id: 'reviewID'
      },

      get_people: {
          method: 'getKPPeopleDetailView',
          id:     'peopleID'

      },
      get_today_films: {
          method: 'getKPTodayFilms'
      },
      get_cinemas: {
          method: 'getCinemas'
      },
      get_cinema_detail: {
          method: 'getCinemaDetail',
          id: 'cinemaID'
      },
      get_seance: {
          method: 'getSeance',
          id: 'filmID'
      },
      get_dates_for_detail_cinema: {
          method: 'getDatesForDetailCinema',
          id: 'filmID'
      },
      get_soon_films: {
          method: 'getSoonFilms'
      },
      get_soon_dvd: {
          method: 'getSoonDVD'
      },
      get_dates_for_soon_films: {
          method: 'getDatesForSoonFilms'
      },
      get_dates_for_soon_dvd: {
          method: 'getDatesForSoonDVD'
      },

      get_top: {
        method: 'getKPTop',
        page:   'page',
        type:   'type',
        types: {
          popular_films:   'kp_item_top_popular_films',
          best_films:      'kp_item_top_best_films',
          await_films:     'kp_item_top_await',
          popular_people:  'kp_item_top_popular_people',

        }
      },

      get_best_films_list: {
          method: 'getBestFilmsList'
      },



      search_global: {
          method: 'getKPGlobalSearch',
          keyword: 'keyword'
      },
      search_film: {
          method: 'getKPSearchInFilms',
          keyword: 'keyword',
          page:    'page'
      },
      search_people: {
          method:  'getKPSearchInPeople',
          keyword: 'keyword',
          page:    'page'
      },

      search_cinemas: {
          method: 'searchCinemas',
          keyword: 'keyword'
      },
      news: {
          method: 'getNews'
      },
      get_news_detail: {
          method: 'getNewsDetail'
      }
  }

  def self.api_access(url)
    #uri = URI.parse(url)
    #http = Net::HTTP.new(uri.host, uri.port)
    #response = http.request_head(uri.path)
    #
    #if response.code == '200'
    #  true
    #else
    #  false
    #end
    raise ToDo
  end

  def self.valid_json?(j)
    begin
      JSON.parse(j)
      return true
    rescue JSON::ParserError => e
      return false
    end
  end

end
