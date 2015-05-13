require 'spec_helper'

module Codebreaker
  describe Game do
    context "#start" do
      let(:game) { Game.new }
      before { game.start }
      subject(:secret_code) { game.instance_variable_get(:@secret_code) }

      it "saves secret code" do
        expect(secret_code).not_to be_empty
      end

      it "saves 4 numbers secret code" do
        expect(secret_code.size).to eq(4)
      end

      it "saves secret code with numbers from 1 to 6" do
        expect(secret_code).to match(/[1-6]+/)
      end
    end

    context "#submit" do
      let(:game) { Game.new }
      before { game.start }
      subject(:submit) { game.send(:submit, 1234) }

      it "without started game" do
        game.instance_variable_set(:@secret_code, '')
        expect(submit).to match(/Game not started/)
      end

      it "returns error if less than 4 numbers" do
        expect(game.send(:submit, 123)).to match(/Wrong number/)
      end

      it "returns error if greater than 4 numbers" do
        expect(game.send(:submit, 12345)).to match(/Wrong number/)
      end

      it "returns array with 4 values" do
        expect(submit).to be_a(Array)
        expect(submit.size).to eq(4)
      end
    end
  end
end
