require 'rails_helper'

describe OrkutClient  do

	let(:sign_in_response){
		sign_in_response = double()
		allow(sign_in_response).to receive(:body).and_return("my_token")
		sign_in_response
	}

	  let(:friends_response){
	    friends_response = double()
	    allow(friends_response).to receive(:body).and_return("{}")
	    friends_response
	}


	it "should sign_in to Orkut Server" do
		p "sign in test"
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
		#p "----------------"

		p response
		#p "----------------"
		#expect(response.code).to eq 200
		#expect(response.body).to_not be_nil
	end

	it "should sign_out from Orkut Server" do
		p "sign out test"
		#setup
		orkut_client = OrkutClient.new
		allow(RestClient).to receive(:post).and_return(sign_in_response)
		orkut_client.sign_in("my_user", "my_password")

		#exercise
		orkut_client.sign_out
		#verifty
		expect(Authorizable).to_not be_signed_in

	end

	it "should display list of Orkut friends" do
		p "get friends test"
		#Setup
		orkut_client = OrkutClient.new
		#fake login data
		allow(RestClient).to receive(:post).and_return(sign_in_response)
		orkut_client.sign_in("my_user", "my_password")

		#allow(Authorizable).to receive(:signed_in?).and_return(true)
		#allow(Authorizable).to receive(:get_token).and_return("my token")
				
			expect(RestClient::Request).to receive(:execute).with(  method: :get,
	                                                                url: /friendships\/me/,
	                                                                headers: { :Authorization => "bearer y_toke" }
	                                                            ).and_return(friends_response)
	
				      
				
			response = orkut_client.get_my_friends
			expect(response).to be_a(Hash)

	end

end