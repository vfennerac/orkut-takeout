require 'rails_helper'

describe JSONExporter do
	#local setup
	let(:exporter) {JSONExporter.new}

	let(:current_user_hash){
		{
			"_id" => "56df40fa93a9a845256d306f",
			"provider" => "local",
			"name" => "Victor Fenner",
			"email" => "vfenner@avenuecode.com",
			"password" => "test123",
			"__v" => 0,
			"role" => "user"
		}
	}

	let(:one_friends_hash){
		
		JSON.parse(%Q([{
				"_id": "56ab7fc22e481306042c151d",
				"user": {
					"_id": "56ab7ee72e481306042c1518",
					"name": "QA Couse User 1",
					"email": "qacourseuser1@avenuecode.com"
				}
			}]))
	}

	let(:ten_friends_hash){
		
		friends_array = []
		
		10.times do
			friends_array << %Q({
				"_id": "56ab7fc22e481306042c151d",
				"user": {
					"_id": "56ab7ee72e481306042c1518",
					"name": "QA Couse User 1",
					"email": "qacourseuser1@avenuecode.com"
				}
			})
		end
		
		friends_string = friends_array.join(",")
		
		JSON.parse("[#{friends_string}]")
	}

	let(:twenty_friends_hash){
		
		friends_array = []
		
		20.times do
			friends_array << %Q({
				"_id": "56ab7fc22e481306042c151d",
				"user": {
					"_id": "56ab7ee72e481306042c1518",
					"name": "QA Couse User 1",
					"email": "qacourseuser1@avenuecode.com"
				}
			})
		end
		
		friends_string = friends_array.join(",")
		
		JSON.parse("[#{friends_string}]")
	}
	#Using 1 friend list for content validation
	context "should display the following content" do
		it "should contain total of friends" do
			#exercise
	 		json_response = exporter.export_friends(one_friends_hash, current_user_hash)
	        #verify
			expect(json_response).to include "count", "1"
       end
    	it "should contain user details - name - email - socialPercentage - socialType" do
       		#exercise
	 		json_response = exporter.export_friends(one_friends_hash, current_user_hash)
	        #verify
			expect(json_response).to include "Victor Fenner", "vfenner@avenuecode.com", "6%", "Not So Friendly"
		end
		it "should contain friend details - name - email" do
			#exercise
	 		json_response = exporter.export_friends(one_friends_hash, current_user_hash)
	        #verify
	        #p "-- json"
	        #p json_response
	        #p "--"
			expect(json_response).to include "QA Couse User 1", "qacourseuser1@avenuecode.com"
		end
	end
	#since type and percentage are tied together is it ok to execute both at once?
	context "should display correct socialPercentage and socialType" do
		
		it "should show user's socialType as Not So Friendly for a socialPercentage less than 30%" do
			#exercise
			json_response = exporter.export_friends(one_friends_hash, current_user_hash)
			json_hash = JSON.parse(json_response)
			#verify
			expect(json_hash["user"]["socialPercentage"]).to include "6%"
			expect(json_hash["user"]["socialType"]).to include "Not So Friendly"
		end
			it "should show user's socialType as Friendly for a socialPercentage more than 30% and less than 80%" do
			#exercise
			json_response = exporter.export_friends(ten_friends_hash, current_user_hash)
			json_hash = JSON.parse(json_response)
			#verify
			expect(json_hash["user"]["socialPercentage"]).to include "66%"
			expect(json_hash["user"]["socialType"]).to include "Friendly"
		end
=begin
	Given I have an account on Orkut
	And I have more than 15 friends on it
	When I export my friends list to Social Network 3
	Then the social percentage attribute should show "100%" (pecentage included)

	-- So bug found, JSON retunrs 133% for 20 friends! it should cap at 100%
=end
		it "should show user's socialType as Super Friendly for a socialPercentage more than 80%" do
			#exercise
			json_response = exporter.export_friends(twenty_friends_hash, current_user_hash)
			json_hash = JSON.parse(json_response)
			#p "TOO MANY Ps"
			#p json_hash
			#verify
			expect(json_hash["user"]["socialPercentage"]).to include "100%"
			expect(json_hash["user"]["socialType"]).to include "Super Friendly"
		end

		it "should round down socialPercentage value" do
			#exercise
			json_response = exporter.export_friends(one_friends_hash, current_user_hash)
			json_hash = JSON.parse(json_response)
			#verify
			expect(json_hash["user"]["socialPercentage"]).to include "6%"
		end
		
	#eocontext
	end
#eodescribe
end