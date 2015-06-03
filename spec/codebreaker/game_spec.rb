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

      array = [
        ["1234", "5656", ""    ],
        ["1234", "1234", "++++"],
        ["1234", "1243", "++--"],
        ["1234", "1324", "++--"],
        ["1234", "1342", "+---"],
        ["1234", "1423", "+---"],
        ["1234", "1432", "++--"],
        ["1234", "2134", "++--"],
        ["1234", "2143", "----"],
        ["1234", "2314", "+---"],
        ["1234", "2341", "----"],
        ["1234", "2413", "----"],
        ["1234", "2431", "+---"],
        ["1234", "3124", "+---"],
        ["1234", "3142", "----"],
        ["1234", "3214", "++--"],
        ["1234", "3241", "+---"],
        ["1234", "3412", "----"],
        ["1234", "3421", "----"],
        ["1234", "4123", "----"],
        ["1234", "4132", "+---"],
        ["1234", "4213", "+---"],
        ["1234", "4231", "++--"],
        ["1234", "4312", "----"],
        ["1234", "4321", "----"],
        ["1234", "5111", "-"   ],
        ["1234", "1546", "+-"  ],
        ["1234", "1564", "++"  ],
        ["1234", "5234", "+++" ],
        ["1124", "1226", "++"  ],
        ["1335", "3346", "+-"  ],
        ["1244", "4421", "----"]
      ]

      descr = %Q(returns [%s] when submits %s with the secret code %s)

      array.each do |a|
        it descr % [a[2].ljust(4), a[1], a[0]] do
          game.instance_variable_set(:@secret_code, a[0])
          expect(game.submit(a[1])).to eq(a[2])
        end
      end

      it "attempts count should be zero when lose" do
        game.instance_variable_get(:@attempts_remain).times { game.submit("4321") }
        expect(game.instance_variable_get(:@attempts_remain)).to be_zero
      end

      it "attempts count changes by -1" do
        expect{game.submit("4321")}.to change{game.instance_variable_get(:@attempts_remain)}.by(-1)
      end

      it "secret code should be empty after win" do
        game.submit("1234")
        expect(game.instance_variable_get(:@secret_code)).to eq("")
      end
    end

    context "validate code" do
      it "is empty string" do
        expect{game.submit("")}.to raise_error ArgumentError
      end

      it "contains spaces" do
        expect{game.submit("1 23")}.to raise_error ArgumentError
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

    context "#hint" do
      it "should have a nil variable" do
        expect(game.instance_variable_get(:@hint)).to be_nil
      end

      it "should return a digit" do
        game.instance_variable_set(:@secret_code, "1234")
        expect(game.hint).to match(/^\*{0,3}[1-6]\*{0,3}$/)
      end

      it "should return the same hint after reuse" do
        expect(game.hint).to eq(game.hint)
      end
    end
  end
end
