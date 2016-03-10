require 'rails_helper'

describe OrkutClient  do

	let(:sign_in_response){
		sign_in_response = double()
		allow(sign_in_response).to receive(:body).and_return("my_token")
		sign_in_response
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
		#p "----------------"
		#p response
		#p "----------------"
		#expect(response.code).to eq 200
		#expect(response.body).to_not be_nil
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
end