require 'http'
require 'json'
require 'dotenv'

Dotenv.load('.env')

def api_id(id)
  api_key = ENV["OPENAI_API_KEY"]
  url = "https://api.openai.com/v1/engines/text-davinci-003/completions"
  headers = {
    "Content-Type" => "application/json",
    "Authorization" => "Bearer #{api_key}"
  }
  if id == "headers"
    return headers
  elsif id == "url"
    return url
  end
end

def perform
  input = ""
  history = ""

  loop do
    print "Moi : "
    input = gets.chomp
    break if input == "stop"
    history += input

    data = {
      "prompt" => history,
      "max_tokens" => 150,
      "n" => 1,
      "temperature" => 0
    }
    url = api_id("url")
    response = HTTP.post(url, headers: api_id("headers"), body: data.to_json)
    response_body = JSON.parse(response.body.to_s)
    response_string = response_body['choices'][0]['text'].strip
    history += response_string

    puts "Bot : #{response_string}"
  end
end

perform