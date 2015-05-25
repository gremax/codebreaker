# Codebreaker [![Build Status](https://travis-ci.org/gremax/codebreaker.svg)](https://travis-ci.org/gremax/codebreaker)

Codebreaker is a logic game in which a code-breaker tries to break a secret code created by a code-maker. The code-maker, which will be played by the application we’re going to write, creates a secret code of four numbers between 1 and 6.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'codebreaker', :git => "git://github.com/gremax/codebreaker"
```

And then execute:

    $ bundle

## Usage

Start an example console game:

    $ bundle --binstubs
    $ bundle exec bin/codebreaker

Or write own:

```ruby
require "bundler/setup"
require "codebreaker"

Attempts = 10

game = Codebreaker::Game.new(Attempts)
game.start

loop do
  puts "\nEnter guess (? for help):"
  guess = gets.chomp

  case guess
  when "hint"
    puts game.hint
  when "start"
    game.start
  when "scores"
    begin
      puts "Score table:".underline
      game.scores.each do |s|
        puts "/ #{s.username} / Attempts: #{s.attempts} / Time: #{(s.finish_at - s.start_at).to_i}s."
      end
    rescue => e
      puts e
    end
  when ""
    exit
  else
    begin
      submit = game.submit(guess)
    rescue => e
      puts e
      next
    end
    puts submit

    if submit == "Game over" || submit == "++++"
      puts "\nSave your score? (y/n)"
      case gets.chomp
      when "y"
        puts "Enter username:"
        game.save(gets.chomp)
      end

      puts "\nRestart Codebreaker? (y/n)"
      case gets.chomp
      when "y"
        game.start
      when "n"
        puts "Bye!"
        exit
      end
    end
  end
end
```

## Tests

    $ bundle exec rspec

Or

    $ bundle exec rake

## Rake

     $ rake -T db

```bash
rake db:remove  # Remove database file
rake db:reset   # Reset database
```

## Contributing

1. Fork it ( https://github.com/gremax/codebreaker/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
