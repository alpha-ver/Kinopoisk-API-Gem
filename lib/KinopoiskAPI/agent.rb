module KinopoiskAPI
  class Agent

    def status
      @json[:resultCode].nil? ? true : false
    end

    def status2
      @json[:resultCode].nil? ? true : false
    end

    def data
      @json
    end

    def data2
      @json2
    end

    ####
    ####
    ####

    #For paginate
    def next_page
      if @page < @page_count
        @page += 1
        gen_url
        @json = json
        true
      else
        false
      end
    end

    def page_count
      @page_count
    end

    def current_page
      @page
    end




    #private

      def json(url=nil, bu=true)
        if url.nil?
          uri       = URI(@url)
        else
          uri       = URI(url)
        end

        #if bu
        #  query     = URI.decode_www_form(String(uri.query))
        #  #uuid      = Digest::MD5.hexdigest("--#{rand(10000)}--#{Time.now}--")
        #  uuid      = DOMAINS[:uuid]
        #  query     << ["uuid", uuid]
        #  uri.query = URI.encode_www_form(query)
        #end

        #path = uri.to_s.gsub("#{DOMAINS[:api]}/","") + DOMAINS[:salt]
        #key  = Digest::MD5.hexdigest(path)

        #query     = URI.decode_www_form(String(uri.query)) << ["key", key]
        #uri.query = URI.encode_www_form(query)

        print "[GET] -> " + uri.to_s
        get_time = Time.now

        http              = Net::HTTP.new(uri.host, uri.port)
        http.read_timeout = 10
        if uri.scheme == "https"
          http.use_ssl      = true
        end
        response          = http.get(uri.request_uri, DOMAINS[:headers])

        print " <- [#{(Time.now-get_time).round 3}s]\n"

        if KinopoiskAPI::valid_json?(response.body)
          j = JSON.parse(response.body)
          if j['resultCode'] == 0
            j['data']
          else
            j
          end
        else
          {:resultCode => -1, :message=> "Error method require", :data => { :code => response.code, :body => response.body} }
        end
      end

      def json2
        if @json2.nil?
          @json2 = json(@url2)
        end
      end


      def s2a(str)
        if str.nil?
          []
        else
          str.split(',').map { |i| i.strip }
        end
      end

      def int_data(data, name, none=0, type=Integer)
        s = dn(data, name)

        if s.nil?
          none
        else
          r = s
          if r.class == String
            r = s.gsub(/[\ \%\$]/i, '')
          end

          if type == Integer
            r.to_i == 0 ? none : r.to_i
          elsif type == Float
            r.to_f == 0 ? none : r.to_f
          else
            r
          end
        end
      end

      def year_data(data, name, point=:start)
        s = dn(data, name)

        if s.nil?
          nil
        else
          if s.size == 4 && point == :start
            s.to_i
          else s.size == 9
            arr = s.scan(/(\d{4})/).flatten
            if point == :start
              arr[0].to_i
            elsif point == :end
              arr[1].to_i
            end
          end
        end
      end

      def time_data(data, name)
        s = dn(data, name)
        if !s.nil?

          if s.size == 10
            d=Date.parse(s) rescue nil
            if d.nil?
              s=s.gsub('00.', '01.')
              d=Date.parse(s) rescue nil
            end
            d
          else
            year = s.scan(/\d{4}/)[0]
            if !year.nil?
              Date.parse("01.01.#{year}") #only year???
            end
          end

        end
      end

      def arr_data(data, name)
        s = dn(data, name)
        if s.nil?
          []
        else
          s.split(',').map { |genre| genre.strip }
        end
      end

      def str_data(data, name)
        s = dn(data, name)

        if s.class == String
          s
        elsif s.class == NilClass
          nil
        else
          s.to_s
        end
      end

      def bool_data(data, name)
        s = dn(data, name)

        if s.class == String
          s = s.to_i
        end

        if s.class == TrueClass || s.class == FalseClass
          s
        else
          s.present? && s == 1 ? true : false
        end
      end

      def min_data(data, name)
        s = dn(data, name)
        begin
          s.present? ? Time.parse(s).seconds_since_midnight.to_i / 60 : 0
        rescue
        end
      end

      def url_data(data, name, id, poster_name)
        s = dn(data, name)
        s.nil? ? nil : "#{DOMAINS[:kinopoisk][:poster][poster_name]}_#{id}.jpg"
      end


      def film_hash(h, id='filmID')
        {
          id:                     int_data(String,  h[id            ]),
          kp_type:                str_data(String,  h['type'        ]),
          name_ru:                str_data(String,  h['nameRU'      ]),
          name_en:                str_data(String,  h['nameEN'      ]),
          slogan:                 str_data(String,  h['slogan'      ]),
          description:            str_data(String,  h['description' ]),
          poster_url:             url_data(String,  h['posterURL'   ], h[id], :film),
          year:                   year_data(String, h['year'        ], :start),
          year_end:               year_data(String, h['year'        ], :end),
          reviews_count:          int_data(String,  h['reviewsCount']),
          duration:               min_data(String,  h['filmLength'  ]),
          countries:              arr_data(String,  h['country'     ]),
          genres:                 arr_data(String,  h['genre'       ]),
          video:                  h['videoURL'],
          is_sequel_or_prequel:   bool_data(String, h['hasSequelsAndPrequelsFilms']),
          is_similar_films:       bool_data(String, h['hasRelatedFilms'           ]),
          is_imax:                bool_data(String, h['isIMAX'                    ]),
          is_3d:                  bool_data(String, h['is3D'                      ]),
          rating_mpaa:            str_data(String,  h['ratingMPAA'                ]),
          minimal_age:            int_data(String,  h['ratingAgeLimits'           ])
        }
      end

      def people_hash(h)
        {
          :id          => int_data(String,      h['id'        ]),
          :kp_type     => str_data(String,      h['type'      ]),
          :name_ru     => str_data(String,      h['nameRU'    ]),
          :name_en     => str_data(String,      h['nameEN'    ]),
          :poster_url  => url_data(String,      h['posterURL' ], @id, :name),
          :sex         => str_data(String,      h['sex'       ]),
          :growth      => int_data(String,      h['growth'    ]),
          :birthday    => time_data(String,     h['birthday'  ]),
          :birthplace  => str_data(String,      h['sex'       ]),
          :has_awards  => bool_data(String,     h['has_awards']),
          :profession  => s2a(str_data(String,  h['profession']))
        }
      end

      def dn(data, name)
        if data.nil?
          r = @json[name]
        elsif data == String
          r = name
        else
          if @json[data].nil?
            r = nil
          else
            r = @json[data][name]
          end
        end
        r
      end



  end
end
