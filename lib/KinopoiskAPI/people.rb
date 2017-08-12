module KinopoiskAPI
  class People < Agent
    attr_accessor :id, :url

    def initialize(id)
      @id = id.to_i
      @url = "#{DOMAINS[:api]}/#{METHODS[:get_people][:method]}?#{METHODS[:get_people][:id]}=#{id}"
      @json = json

      unless status
        raise APIerror.new(@json[:mesage], @json[:data])
      end
    end

    def view
      {
        :id          => @id,
        :kp_type     => str_data(nil, 'class'),
        :name_ru     => str_data(nil, 'nameRU'),
        :name_en     => str_data(nil, 'nameEN'),
        :poster_url  => url_data(nil, 'posterURL', @id, :name),
        :sex         => str_data(nil, 'sex'),
        :growth      => int_data(nil, 'growth'),
        :birthday    => time_data(nil, 'birthday'),
        :birthplace  => str_data(nil, 'birthplace'),
        :has_awards  => bool_data(nil, 'has_awards'),
        :profession  => s2a(str_data(nil, 'profession'))
      }
    end

    def films
      filmography.map do |film|
        {
          :id                 =>  int_data(String, film['filmID'         ]),
          :rating             =>  int_data(String, film['rating'         ], nil, Float),
          :rating_vote_count  =>  int_data(String, film['ratingVoteCount']),
          :description        =>  str_data(String, film['description'    ]),
          :profession_text    =>  str_data(String, film['professionText ']),
          :profession_key     =>  str_data(String, film['professionKey'  ]),
          :name_ru            =>  str_data(String, film['nameRU'         ]),
          :name_en            =>  str_data(String, film['nameEN'         ]),
          :year               =>  int_data(String, film['year'           ])
        }
      end
    end

    def film_ids
      filmography.map {|film| int_data(String, film['filmID']) }
    end

    private

      def filmography
        if !@json['filmography'].nil?
          @json['filmography'].flatten
        end
      end




  end
end
