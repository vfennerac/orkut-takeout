require 'rails_helper'

describe OrkutClient  do

	let(:sign_in_response){
		sign_in_response = double()
		allow(sign_in_response).to receive(:body).and_return("my_token")
		sign_in_response
	}

	let(:user_info_response){
	    user_info_response = double()
	    allow(user_info_response).to receive(:body).and_return("{}")
	    user_info_response
	}

	  let(:friends_response){
	    friends_response = double()
	    allow(friends_response).to receive(:body).and_return("{}")
	    friends_response
	}

	it "should sign_in to Orkut Server" do
		#setup
		orkut_client = OrkutClient.new
		expect(RestClient).to receive(:post).with(/login/, 
												hash_including(
													username: "vfenner@avenuecode.com", 
													password: "test123"
													)
												).and_return(sign_in_response)
		#exercise
		response = orkut_client.sign_in("vfenner@avenuecode.com","test123")
		#verify
		expect(Authorizable).to be_signed_in
	end

	it "should sign_out from Orkut Server" do
		#setup
		orkut_client = OrkutClient.new
		allow(RestClient).to receive(:post).and_return(sign_in_response)
		orkut_client.sign_in("my_user", "my_password")

		#exercise
		orkut_client.sign_out
		#verifty
		expect(Authorizable).to_not be_signed_in

	end

	it "should display list of user information" do
		#Setup
		orkut_client = OrkutClient.new
		#fake login data
		allow(RestClient).to receive(:post).and_return(sign_in_response)
		orkut_client.sign_in("my_user", "my_password")
		expect(RestClient::Request).to receive(:execute).with(  method: :get,
                                                                url: /users\/me/,
                                                                headers: { :Authorization => "bearer y_toke" }
                                                            ).and_return(user_info_response)
		response = orkut_client.get_current_user_info
		expect(response).to be_a(Hash)
	end

	it "should display list of Orkut friends" do
		#Setup
		orkut_client = OrkutClient.new
		#fake login data
		allow(RestClient).to receive(:post).and_return(sign_in_response)
		orkut_client.sign_in("my_user", "my_password")
		expect(RestClient::Request).to receive(:execute).with(  method: :get,
                                                                url: /friendships\/me/,
                                                                headers: { :Authorization => "bearer y_toke" }
                                                            ).and_return(friends_response)
		response = orkut_client.get_my_friends
		expect(response).to be_a(Hash)

	end

end