module Codebreaker
  class Game
    def start
      @secret_code = (1..6).to_a.sample(4).join
      @attempts = 10
      @hint = true
      @start_at = Time.now
    end

    def submit(code)
      raise "Game is not started yet, use #start." if @secret_code.empty?
      validate(code)
      exact_count = 0
      match_count = 0
      @secret_code.chars.each_with_index do |num, index|
        if num == code[index]
          exact_count += 1
        elsif @secret_code.include?(code[index]) && num != code[index]
          match_count += 1
        end
      end
      guess = "+" * exact_count + "-" * match_count

      if guess.eql?("++++") || @attempts < 1
        @secret_code = ""
        @finish_at = Time.now
        return "Game over" if @attempts < 1
      else
        @attempts -= 1
      end

      guess
    end

    def hint
      return "Hint has already been used." unless @hint
      @hint = false
      @secret_code[rand(0..3)]
    end

    def cheat
      @secret_code
    end

    def save(username)
      Score.save(Score.new(username, @attempts, @start_at, @finish_at))
      puts "#{username} / Attempts: #{5 - @attempts} / Time: #{(@finish_at - @start_at).to_i}s."
    end

    def scores
      Score.load
    end

    private

    def validate(code)
      if !code.is_a?(String)
        raise TypeError, "Secure code must be a String."
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
  end
end