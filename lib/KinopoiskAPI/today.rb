module KinopoiskAPI
  class Today < Agent
    attr_accessor :url

    def initialize
      @url = "#{DOMAINS[:api]}/#{METHODS[:get_today_films][:method]}?cityID=1"
      @json = json
    end

    def view
      films.map do |film|
        {
          id:                     int_data(String, film['id'          ]),
          kp_type:                str_data(String, film['type'        ]),
          name_ru:                str_data(String, film['nameRU'      ]),
          name_en:                str_data(String, film['nameEN'      ]),
          slogan:                 str_data(String, film['slogan'      ]),
          description:            str_data(String, film['description' ]),
          poster_url:             url_data(String, film['posterURL'   ], film["id"], :film),
          year:                   int_data(String, film['year'        ]),
          reviews_count:          int_data(String, film['reviewsCount']),
          duration:               min_data(String, film['filmLength'  ]),
          countries:              arr_data(String, film['country'     ]),
          genres:                 arr_data(String, film['genre'       ]),
          video:                  film['videoURL'],
          is_sequel_or_prequel:   bool_data(String, film['hasSequelsAndPrequelsFilms']),
          is_similar_films:       bool_data(String, film['hasRelatedFilms'           ]),
          is_imax:                bool_data(String, film['isIMAX'                    ]),
          is_3d:                  bool_data(String, film['is3D'                      ]),
          rating_mpaa:            str_data(String,  film['ratingMPAA'                ]),
          minimal_age:            int_data(String,  film['ratingAgeLimits'           ])
        }
      end
    end

    def film_ids
      films.map{|film| int_data(String, film['id'], nil) }.compact
    end

    private

      def films
        @json['filmsData']
      end

  end
end
