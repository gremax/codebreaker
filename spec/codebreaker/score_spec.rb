require 'spec_helper'

module Codebreaker
  describe Score do
    subject(:user) { described_class.new("Bender Bending Rodríguez", 4, Time.now, Time.now + 120) }
    let(:scores) { described_class.load('scores_test.db') }
    after(:all) do
      File.delete('scores_test.db') if File.exists?('scores_test.db')
    end

    it { is_expected.to respond_to(:username) }
    it { is_expected.to respond_to(:attempts) }
    it { is_expected.to respond_to(:start_at) }
    it { is_expected.to respond_to(:finish_at) }

    it "has a username" do
      expect(user.username).to eq("Bender Bending Rodríguez")
    end

    it "has an attempts counter" do
      expect(user.attempts).to eq(4)
    end

    context ".save" do
      before { described_class.save(user, 'scores_test.db') }
      let(:scores) { described_class.load('scores_test.db') }

      it "user scores to a file" do
        expect(File).to exist('scores_test.db')
      end

      it "new user score to an exist file" do
        expect(scores.count).to eq(2)
      end
    end

    context ".load" do
      it "username from a file" do
        expect(scores.first.username).to eq("Bender Bending Rodríguez")
      end

      it "attempts from a file" do
        expect(scores.first.attempts).to eq(4)
      end

      it "file not found" do
        expect{described_class.load('bender.db')}.to raise_error
      end
    end
  end
end