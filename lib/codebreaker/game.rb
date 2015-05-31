module Codebreaker
  class Game
    def initialize(attempts = 10)
      @attempts = attempts
    end

    def start
      @secret_code = (0..3).map{rand(1..6)}.join
      @attempts_remain = @attempts
      @hint = true
      @start_at = Time.now
    end

    def submit(code)
      raise "Game is not started yet, use #start." if @secret_code.empty?
      validate(code)
      guess = ""
      secret_new = @secret_code.chars.zip(code.chars).delete_if {|v1,v2| guess << "+" if v1 == v2}
      secret_new.transpose.first.each {|value| guess << "-" if secret_new.transpose.last.include?(value)} unless secret_new.empty?

      if guess.eql?("++++") || @attempts_remain < 1
        @secret_code = ""
        @finish_at = Time.now
        return "Game over" if @attempts_remain < 1
      else
        @attempts_remain -= 1
      end

      guess
    end

    def hint
      return "Hint has already been used." unless @hint
      @hint = false
      @secret_code.chars.sample
    end

    def cheat
      @secret_code
    end

    def save(username)
      Score.save(Score.new(username, @attempts_remain, @start_at, @finish_at))
      puts "/ #{username} / Attempts: #{@attempts_remain} / Time: #{(@finish_at - @start_at).to_i}s."
    end

    def scores(file='scores.db')
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
