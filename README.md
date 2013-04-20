### Properly capitalize titles in Portuguese

ActiveSupport gives us the `titleize` method to create nice looking titles, but sometimes the result may not be what you excepted:

```ruby
"GUIA DE SOBREVIVÊNCIA".titleize # => "Guia De SobrevivÊncia"
"órgão emissor".titleize # => "órgão Emissor"
"HTTP request".titleize  # => "Http Request"
```

Though this may not be hard to solve:

```ruby
"GUIA DE SOBREVIVÊNCIA".mb_chars.titleize   # => "Guia De Sobrevivência"
"órgão emissor".mb_chars.titleize # => "Órgão Emissor"
ActiveSupport::Inflector.inflections { |inflect| inflect.acronym "HTTP" }
"HTTP request".titleize # => "HTTP Request"
```

The [`titleize`](https://github.com/granth/titleize) gem does some extra work to properly capitalize titles in English:

```ruby
# ActiveSupport titleize method
"a lovely and talented title".titleize # => "A Lovely And Talented Title"

# Using the titleize gem
"a lovely and talented title".titleize # => "A Lovely and Talented Title"
```

This gem is not nearly as advanced as the `titleize` gem but knows how to deal with unicode characters and titles in Portuguese:

```ruby
"GUIA DE SOBREVIVÊNCIA".titleize_pt # => "Guia de Sobrevivência"
"proposta para uma directiva da UE".titleize_pt # => "Proposta para uma Directiva da UE"
"a lovely and talented title".titleize_locale(:en) # => "A Lovely and Talented Title"
```

### Usage

The gem requires ActiveSupport, so it's more suitable for Ruby on Rails projects. Add to your Gemfile and run `bundle`:

    gem "titleize_pt"

### Credits

Some tests and code copied from [granth/titleize](https://github.com/granth/titleize).
