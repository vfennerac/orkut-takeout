require 'rails_helper'

describe Authorizable do 

	let(:global_token){"/This token can be shared between tests/"}

	it "should store the authentication token prepended by bearer" do
		#setup
		passed_token = "/this is my token/"
		expected_token = "this is my token"
		#exercise
		Authorizable.set_token passed_token
		#verify
		expect(Authorizable.get_token).to eq "bearer " + expected_token
		#teardown
	end
	
	it "should sign in when I have a token stored" do
		my_token = "banana"
		Authorizable.set_token my_token
		expect(Authorizable).to be_signed_in
	end

	it "should sign out when I don't have a token stored" do
		#setup
		Authorizable.set_token global_token
		#exercise
		Authorizable.clear_token
		expect(Authorizable).to_not be_signed_in
		expect(Authorizable.get_token).to be_nil
	end
end