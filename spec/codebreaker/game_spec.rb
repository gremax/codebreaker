require 'spec_helper'

module Codebreaker
  describe Game do
    let(:game) { Game.new }

    context "#start" do
      before { game.start }
      subject(:secret_code) { game.instance_variable_get(:@secret_code) }

      it "secret code must be a String" do
        expect(secret_code).to be_a(String)
      end

      it "saves secret code" do
        expect(secret_code).not_to be_empty
      end

      it "saves 4 numbers secret code" do
        expect(secret_code.size).to eq(4)
      end

      it "saves secret code with numbers from 1 to 6" do
        expect(secret_code).to match(/[1-6]+/)
      end

      it "creates variable fot attempts count" do
        expect(game.instance_variable_get(:@attempts)).to eq(0)
      end
    end

    context "#submit" do
      before { game.start }
      subject(:submit) { game.send(:submit, "1234") }

      it "raise when game is not started" do
        game.instance_variable_set(:@secret_code, '')
        expect{submit}.to raise_error
      end

      it "returns array" do
        expect(submit).to be_a(Array)
      end

      it "returns array with 4 values" do
        expect(submit.size).to eq(4)
      end
    end

    context "validate code" do
      before { game.start }

      it "is not a String" do
        expect{game.send(:submit, 1234)}.to raise_error TypeError
      end

      it "is too short" do
        expect{game.send(:submit, "123")}.to raise_error ArgumentError
      end

      it "is too long" do
        expect{game.send(:submit, "12345")}.to raise_error ArgumentError
      end

      it "contains (1..6) digits only" do
        expect{game.send(:submit, "7890")}.to raise_error ArgumentError
      end
    end

    context "wins game" do
      subject(:play) { game.play("4321") }
      before { game.instance_variable_set(:@secret_code, "4321") }

      it "submits the right secret code" do
        expect(play).to eq("Bingo! You are win!")
      end

      it "must be stoped" do
        expect(play).to eq("Bingo! You are win!")
        expect{game.play("4321")}.to raise_error
      end
    end
  end
end
