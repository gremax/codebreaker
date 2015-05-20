require 'spec_helper'

module Codebreaker
  describe Game do
    let(:game) { Game.new }

    it { is_expected.to respond_to(:start) }
    it { is_expected.to respond_to(:play) }
    it { is_expected.to respond_to(:hint) }

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
        expect(secret_code).to have_exactly(4).items
      end

      it "saves secret code with numbers from 1 to 6" do
        expect(secret_code).to match(/[1-6]+/)
      end

      it "creates variable fot attempts count" do
        expect(game.instance_variable_get(:@attempts)).not_to be_zero
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
        expect(submit).to have_exactly(4).items
      end
    end

    context "validate code" do
      before { game.start }

      it "contains digits only" do
        expect{game.send(:submit, "abcd")}.to raise_error ArgumentError
      end

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
      before { game.instance_variable_set(:@secret_code, "4321") }
      subject(:play) { game.play("4321") }

      it "submits the right secret code" do
        expect(play).to eq("Bingo! You are win!")
      end

      it "must be stoped" do
        play
        expect{game.play("4321")}.to raise_error
      end
    end

    context "loses game" do
      before { game.start }
      subject(:play) { game.play("1234") }

      it "attempts count changes by -1" do
        expect{play}.to change{game.instance_variable_get(:@attempts)}.by(-1)
      end

      it "returns a message" do
        4.times { game.play("1234") }
        expect(play).to eq("You are a loser!\nGame Over!")
      end
    end

    context "#hint" do
      before { game.start; game.play("5231") }
      it "variable should be true" do
        expect(game.instance_variable_get(:@hint)).to eq(true)
      end

      it "should return one digit of secret code" do
        expect(game.hint).to be_a(String)
      end

      it "should returns exactly hidden digit" do
        game.instance_variable_set(:@secret_code, "1234")
        game.play("5231")
        expect(game.hint).to eq("1")
      end

      it "should be false after use" do
        game.hint
        expect(game.instance_variable_get(:@hint)).to eq(false)
      end

      it "should returns a message after use" do
        game.hint
        expect(game.hint).to match(/already been used/)
      end
    end
  end
end
