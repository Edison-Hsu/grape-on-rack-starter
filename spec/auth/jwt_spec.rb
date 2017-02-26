require 'spec_helper'

describe Auth::JwtHelpers do
  include Auth::JwtHelpers

  describe ".decode_payload" do
    let(:secret) { 'secret' }
    let(:payload) { {'email' => 'test@example.com'} }
    let(:jwt_token) { 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InRlc3RAZXhhbXBsZS5jb20ifQ.3QJBsXLwBNSyLWLDA5nugTzc83x9Ac9zsxKkghKJ__E' }

    before do
      @old_secret = ENV['JWT_SECRET']
      ENV['JWT_SECRET'] = secret
    end

    after { ENV['JWT_SECRET'] = @old_secret}

    context "when given a valid token" do
      it "returns the payload" do
        expect(decode_payload(jwt_token)).to eq payload
      end
    end

    context "when given a token payload that has been tampered with" do
      it "raises an error" do
        tampered_payload = payload.clone
        tampered_payload['token'] = 'tokens wrong bro'
        tampered_token = JWT.encode(tampered_payload, 'key is wrong')
        expect{decode_payload(tampered_token)}.to raise_error(JWT::VerificationError) 
      end
    end

    context "when given a valid token, that has expired" do
      it "raises an error" do
        payload['exp'] = Time.now.to_i() - 400
        expired_token = JWT.encode(payload, secret)
        expect{ decode_payload(expired_token) }.to raise_error(JWT::ExpiredSignature)
      end
    end

    context "when given an empty string" do
      it "raises an error" do
        expect{decode_payload('')}.to raise_error(JWT::DecodeError)
      end
    end

    context "when given an invalid string" do
      it "raises an error" do
        expect{decode_payload('lalalalaal')}.to raise_error(JWT::DecodeError)
      end
    end
  end
end
