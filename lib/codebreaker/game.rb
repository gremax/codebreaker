module Codebreaker
  class Game
    def start
      @secret_code = (1..6).to_a.sample(4).join
      @attempts = 5
      @hint = true
    end

    def play(code)
      p submit(code)
      if submit(code).uniq.size == 1 && submit(code).uniq.first == "+"
        win
      else
        lose
      end
    end

    def hint
      if @hint
        @hint = false
        @secret_code[@array.index("*")] 
      else
        "Hint has already been used."
      end
    end

    private

    def validate(code)
      if !code.is_a?(String)
        raise TypeError, "Secure code must be a String"
      elsif code.to_i == 0
        raise ArgumentError, "Secure code should consist of numbers only."
      elsif /[0789]+/.match(code)
        raise ArgumentError, "Secure code should consist of numbers from 1 to 6."
      elsif code.length < 4
        raise ArgumentError, "Secure code is too short (#{code.length} for 4)."
      elsif code.length > 4
        raise ArgumentError, "Secure code is too long (#{code.length} for 4)."
      end
    end

    def submit(code)
      raise "Game is not started yet, use #start" if @secret_code.empty?
      validate(code)
      @array = []
      code.split('').each_with_index do |num, index|
        if @secret_code.include?(num)
          @secret_code[index].include?(num) ? @array << "+" : @array << "-"
        else
          @array << "*"
        end
      end
      @array
    end

    def win
      @secret_code = ""
      "Bingo! You are win!"
    end

    def lose
      if @attempts == 1
        @secret_code = ""      
        return "You are a loser!\nGame Over!"
      else
        @attempts -= 1
      end
    end
  end
end