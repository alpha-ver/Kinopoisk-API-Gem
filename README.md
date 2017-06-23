# КиноПоиск API (Gem)

Этот gem создан для упрощения работы с КиноПоиск API в проектах Ruby on Rails.

Гем основан официальном API от кинопоиска. Используется не официально, прикидываясь андройдом. Данный гем являеться форком проекта afuno/Kinopoisk-API-Gem, но т.к http://api.kinopoisk.cf/ не работает, то пришлось переделать для работы на прямую с кинопоиском.

Используется версия api 3.11.0 (планируется перевести на 5.0.0)

## Установка

Добавьте эту строку в Gemfile вашего приложения:

```ruby
gem 'KinopoiskAPI'
```

Затем выполните:

    $ bundle


## Использование

### Глабальные функции

```ruby
api = KinopoiskAPI::Class 
```

```ruby
api.status 
#   > true  [Полученна следующая станица]
#   > false [Достигли конца пагинации]
```

```ruby
#   Оригинальный хеш кинопоиска
api.data 
```

```ruby
#   Оригинальный хеш кинопоиска (используется в некоторых классах для дополнительного запроса). 
#   Пример: __film.peoples_full__)
api.data2 
```


```ruby
#   Статус парсинга json 
#   Boolean
api.status 
```

```ruby
#   Статус парсинга json дополнительного запроса.
#   Boolean
api.status2
```

### Исключения 

При ошибке выбасывается исключение __KinopoiskAPI::APIerror__. Доступные методы.

```ruby
# http код ответа
e.code
=> "404"
```

```ruby
# Тело ответа
e.body
=> [key:false]
```


## Классы 

### Фильм

```ruby
film = KinopoiskAPI::Film.new(film_id)
```

```ruby
#   Вся информация о фильме(включая rating, rent, budget).
film.view
```
```ruby
# Рейтинги фильма и т.д.
film.rating
```
```ruby
# Даты премьер и т.д.
film.rent
```

```ruby
# Бюджет и сборы.
film.budget
```

```ruby
# Люди связанные с фильмом(Не полный список, смотрите ниже).
film.peoples
```

```ruby
# Люди связанные с фильмом(Полный список). Генерирует новый запрос к API.
film.peoples_full
```


### Люди(Режисеры, актеры, операторы и т.д.).

```ruby
people = KinopoiskAPI::People.new(people_id)
```

```ruby
# Детальная информация о человеке.
people.view
```

```ruby
# Фильмы связанные с конкретным человеком.
people.films
```

```ruby
# Массив id фильмов связанных с конкретным человеком.
people.films_ids
```


### Категории

```ruby
category = KinopoiskAPI::Category.new
```

```ruby
# Страны
category.countries
```

```ruby
# Жанры
category.genres
```


### Сегодня в кино

```ruby
today = KinopoiskAPI::TodayFilms.new
```

```ruby
#   Список фильмов
today.view
```

```ruby
#   Массив id фильмов
today.film_ids
```

### Глобальный поиск

```ruby
search = KinopoiskAPI::GlobalSearch.new('Q')
```
```ruby
#   Скорее всего вы искали этот фильм
search.exactly
```
```ruby
#   Возможно, вы искали эти фильмы
search.maybe
```
```ruby
#   Или даже этих людей
search.peoples
```


### Поиск по фильмам

```ruby
search = KinopoiskAPI::FilmSearch.new('Q')
```

```ruby
#   Список фильмов (не более 20)
search.view
```

```ruby
#   Колличество найденных фильмов
search.films_count
```

```ruby
#   Текущая страница
search.current_page
```

```ruby
#   Колличество страниц
search.page_count
```

```ruby
#   Следующая страница
search.next_page
#   > true  [Полученна следующая станица]
#   > false [Достигли конца пагинации]
```


### Поиск по людям

```ruby
search = KinopoiskAPI::PeopleSearch.new('Q')
```

```ruby
#   Список людей (не более 20)
search.view
```

```ruby
#   Колличество найденных фильмов
search.peoples_count
```

```ruby
#   Текущая страница
search.current_page
```

```ruby
#   Колличество страниц
search.page_count
```

```ruby
#   Следующая страница
search.next_page
#   > true  [Полученна следующая станица]
#   > false [Достигли конца пагинации]
```

## Возвращаеммые данные 

###Фильм




## Баги

### Дата

Иногда кинопоиск отдаёт неправильную дату релиза такого вида. "00.00.2005". соответсветно возникает эксепшен ArgumentError: invalid date. Если такое поризойдёт то дата будет сконвертированна "00.00.2005" -> "01.01.2005".

_______________________________________________________________________________



## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

