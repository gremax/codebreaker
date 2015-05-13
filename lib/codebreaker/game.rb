module Codebreaker
  class Game
    Attempts = 5

    def initialize(numbers = "")
      @secret_code = numbers
    end

    def start
      @secret_code = (1..6).to_a.shuffle.first(4).join
      @attempts = 0
    end

    def play(numbers)
      p submit(numbers)
      if submit(numbers).uniq.first == "+"
        win
      else
        lose
      end
    end

    private

    def submit(numbers)
      return "Game not started, use #start" if @secret_code.empty?
      return "Wrong number of secure digits (#{numbers.to_s.length} for 4)" if numbers.to_s.length < 4 || numbers.to_s.length > 4
      code = []
      numbers.to_s.split('').each_with_index do |num, index|
        if @secret_code.include?(num)
          @secret_code[index].include?(num) ? code << "+" : code << "-"
        else
          code << "*"
        end
      end
      code
    end

    def win
      @secret_code = ""
      puts "Bingo! You are win!"
    end

    def lose
      unless @attempts == Attempts
        @attempts += 1
      else
        @secret_code = ""
        puts "You are a loser!\nGame Over!"
      end
    end
  end
end