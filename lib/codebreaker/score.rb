module Codebreaker
  class Score
    attr_reader :username, :attempts, :start_at, :finish_at

    def initialize(username, attempts, start_at, finish_at)
      @username = username
      @attempts = attempts
      @start_at = start_at
      @finish_at = finish_at
    end

    def self.save(score, file='scores.db')
      all_scores = if File.exists?(file)
         Marshal.load(File.open(file))
      else
        []
      end
      File.write(file, Marshal.dump(all_scores << score))
    end

    def self.load(file='scores.db')
      if File.exists?(file)
        all_scores = Marshal.load(File.open(file))
      else
        raise ArgumentError, "File '#{file}' not found."
      end
    end

  end
end