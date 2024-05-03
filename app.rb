require "sinatra"
require "sinatra/reloader"
require "http"
require "json"

# define a route
get("/") do

  # build the API url, including the API key in the query string
  api_url = "https://api.exchangerate.host/list?access_key=#{ENV["EXCHANGE_RATE_KEY"]}"

# use HTTP.get to retrieve the API information
raw_data = HTTP.get(api_url)

# convert the raw request to a string
raw_data_string = raw_data.to_s

# convert the string to JSON
parsed_data = JSON.parse(raw_data_string)


# get the symbols from the JSON
@symbols = parsed_data["currencies"]

# render a view template where I show the symbols
erb(:homepage)
end



get("/:from_currency") do
  @original_currency = params.fetch("from_currency")

  api_url = "https://api.exchangerate.host/list?access_key=#{ENV["EXCHANGE_RATE_KEY"]}"
  
  # Some more code to parse the URL and render a view template.
  # (HINT: this code is identical to the first route, you just
  # render a different view template at the end.)
  raw_data = HTTP.get(api_url)
  raw_data_string = raw_data.to_s
  parsed_data = JSON.parse(raw_data_string)
  @symbols = parsed_data["currencies"]

  erb(:from_currency)

end

get("/:from_currency/:to_currency") do
  @original_currency = params.fetch("from_currency")
  @destination_currency = params.fetch("to_currency")

  api_url = "https://api.exchangerate.host/convert?access_key=#{ENV.fetch("EXCHANGE_RATE_KEY")}&from=#{@original_currency}&to=#{@destination_currency}&amount=1"
  
  # Some more code to parse the URL and render a view template.
  raw_data = HTTP.get(api_url)
  raw_data_string = raw_data.to_s
  parsed_data = JSON.parse(raw_data_string)
  @result = parsed_data["result"]

  erb(:to_currency)
end
