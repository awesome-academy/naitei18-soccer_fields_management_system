require "rails_helper"

RSpec.describe User, type: :model do
  describe ".digest" do
    context "min cost" do
      it "return a hashed string with min cost" do
        random_string = Faker::Lorem.sentence(word_count: 10)
        digest = User.digest(random_string)
        expect(BCrypt::Password.new(digest).is_password? random_string).to be_truthy
      end
    end

    context "not min cost" do
      before do
        allow(ActiveModel::SecurePassword).to receive(:min_cost).and_return(nil)
      end
      it "return a hashed string without min cost" do
        random_string = Faker::Lorem.sentence(word_count: 10)
        digest = User.digest(random_string)
        expect(BCrypt::Password.new(digest).is_password? random_string).to be_truthy
      end
    end
  end

  describe ".new_token" do
    it "return a secure token" do
      random_token = User.new_token
      expect(random_token).to match(/\A[A-Za-z0-9\-_]+\z/)
    end
  end

  describe "#remember" do
    let(:user) {create(:user)}
    it "update remember digest to remember token" do
      user.remember
      remember_token = user.remember_digest
      expect(user.remember_digest).to eq(remember_token)
    end
  end

  describe "#forget" do
    let(:user) {create(:user)}
    it "update remember digest to nil" do
      user.forget
      expect(user.remember_digest).to be_nil
    end
  end

  describe "#activate" do
    let(:user) {create(:user)}
    before do
      user.activate
    end
    it "activated_at should not nil" do
      expect(user.activated_at).not_to be_nil
    end

    it "activated should true" do
      expect(user.activated).to be_truthy
    end
  end

  describe "#create_reset_digest" do
    let (:user) {create(:user)}
    before do
      user.create_reset_digest
    end

    it "check if it really change the reset digest" do
      expect(user.reset_digest).not_to be_nil
    end

    it "check if reset_send_at change" do
      expect(user.reset_sent_at).not_to be_nil
    end

    it "#authenticated?" do
      expect(user.authenticated?("reset", user.reset_token)).to be_truthy
    end

    describe "#send_password_reset_email" do
      it "send an email to reset password" do
        message = user.send_password_reset_email
        expect(message).to be_a Mail::Message
      end
    end

    describe "#password_reset_expired?" do
      it "returns true when reset_send_at is more than 2 hours ago" do
        reset_sent_at = 3.hours.after

        Timecop.freeze(reset_sent_at) do
          expect(user.password_reset_expired?).to eq(true)
        end
      end
    end
  end

  describe "#follow" do
    let(:user) {create(:user)}
    let(:football_pitch) {create(:football_pitch)}
    before do
      user.follow football_pitch
    end
    it "user shold follow football pitch" do
      expect(user.football_pitches).to include(football_pitch)
    end
  end

  describe "#unfollow" do
    let(:user) {create(:user)}
    let(:football_pitch) {create(:football_pitch)}
    before do
      user.follow football_pitch
      user.unfollow football_pitch
    end
    it "user shold unfollow football pitch" do
      expect(user.football_pitches).not_to include(football_pitch)
    end
  end

  describe "#send_activation_email" do
    let(:user) {create(:user)}
    it "user should sends an a activation email" do
      expect { user.send_activation_email }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end
