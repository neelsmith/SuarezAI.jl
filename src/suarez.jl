

"""Submit a query to suarez and get the reply body as a Dict parsed from JSON.
"""
function  suarezreply(s, bearerkey; model  = "chatgpt-4o-latest")
	chatcompleteurl = HTTP.URI("https://suarezai.holycross.edu/openai/chat/completions"; query = "bypass_filter=false")

	hdrs = ["accept" => "application/json",
    "Authorization" =>  "Bearer $(bearerkey)"
    ]
	json_data = Dict(
	    "model" => model,
	    "messages" => [
	        Dict(
	            "role" => "user",
	            "content" => "$(s)"
	        )
	    ]
	)
	json_payload = JSON.json(json_data)
	try
		chatresponds = HTTP.post(chatcompleteurl, hdrs, json_payload)
		chatreplystring = chatresponds.body |> String
		chatreplystring |> JSON.parse
	catch e
		msg = """Query to suarez failed.

		Error was $(e)
		"""

	end
end


"""Extract message content from ChatGPT reply."""
function asksuarez(s, k)	

    chatjson = suarezreply(s, k)
	chatjson["choices"][1]["message"]["content"] 
end