require 'spec_helper'

module Codebreaker
  describe Game do
    let(:game) { Game.new }
    before { game.start }

    it { is_expected.to respond_to(:start) }
    it { is_expected.to respond_to(:submit) }
    it { is_expected.to respond_to(:hint) }
    it { is_expected.to respond_to(:save) }
    it { is_expected.to respond_to(:scores) }

    context "#start" do
      subject(:secret_code) { game.instance_variable_get(:@secret_code) }

      it { is_expected.to be_a(String) }
      it { is_expected.not_to be_empty }
      it { is_expected.to have_exactly(4).items }
      it { is_expected.to match(/^[1-6]{4}$/) }
      it { expect(game.instance_variable_get(:@attempts_remain)).not_to be_zero }
    end

    context "#submit" do
      subject(:submit) { game.submit("1234") }

      before do
        allow(game).to receive(:validate)
        game.instance_variable_set(:@secret_code, "1234")
      end

      it { is_expected.to be_a(String) }
      it { is_expected.to have_exactly(4).items }

      it "raises when game is not started" do
        game.instance_variable_set(:@secret_code, '')
        expect{submit}.to raise_error
      end

      hash = {
        first: { "1234": "++++", "4321": "----", "1546": "+-", "1564": "++", "5234": "+++" },
        second: { "1226": "++-", "4221": "+---", "3232": "--", "2323": "+-", "1111": "++--" }
      }

      hash[:first].each do |h|
        it "returns #{h[1]} when #{h[0]}" do
          game.instance_variable_set(:@secret_code, "1234")
          expect(game.submit(h[0].to_s)).to eq(h[1])
        end
      end

      hash[:second].each do |h|
        it "returns #{h[1]} when #{h[0]}" do
          game.instance_variable_set(:@secret_code, "1124")
          expect(game.submit(h[0].to_s)).to eq(h[1])
        end
      end
    end

    context "validate code" do
      it "is empty string" do
        expect{game.submit("")}.to raise_error ArgumentError
      end

      it "contains digits only" do
        expect{game.submit("abcd")}.to raise_error ArgumentError
      end

      it "is not a String" do
        expect{game.submit(1234)}.to raise_error TypeError
      end

      it "is too short" do
        expect{game.submit("123")}.to raise_error ArgumentError
      end

      it "is too long" do
        expect{game.submit("12345")}.to raise_error ArgumentError
      end

      it "contains (1..6) digits only" do
        expect{game.submit("7890")}.to raise_error ArgumentError
      end
    end

    context "wins game" do
      before { game.instance_variable_set(:@secret_code, "4321") }

      it "submits the right secret code" do
        game.instance_variable_set(:@secret_code, "4321")
        expect(game.submit("4321")).to eq("++++")
      end

      it "secret code should be empty" do
        game.submit("4321")
        expect(game.instance_variable_get(:@secret_code)).to eq("")
      end
    end

    context "loses game" do
      before { game.instance_variable_set(:@secret_code, "4321") }

      it "attempts count changes by -1" do
        expect{game.submit("1234")}.to change{game.instance_variable_get(:@attempts_remain)}.by(-1)
      end

      it "attempts count should be zero" do
        game.instance_variable_get(:@attempts_remain).times { game.submit("1234") }
        expect(game.instance_variable_get(:@attempts_remain)).to be_zero
      end
    end

    context "#hint" do
      it "variable should be true" do
        expect(game.instance_variable_get(:@hint)).to eq(true)
      end

      it "should returns a digit" do
        game.instance_variable_set(:@secret_code, "1234")
        expect(game.instance_variable_set(:@secret_code, "1234").chars).to include(game.hint)
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
