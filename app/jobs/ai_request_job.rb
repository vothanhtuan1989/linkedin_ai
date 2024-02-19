class AiRequestJob < ApplicationJob
  queue_as :default

  def perform
    # Do something later

    connection = Faraday.new(url: 'https://api.openai.com')

    user_input = "We are actively looking for"
    user_network = Connection.all.to_json

    response = connection.post do |req|
      req.url "/v1/engines/gpt-3.5-turbo/completions"
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Bearer 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"
      req.body = {
        prompt: "#{user_input}\n\n#{user_network}\n\nAI:",
        max_tokens: 250,
        temperature: 0.5,
        n: 1
      }.to_json
    end

    debugger

    json_response = JSON.parse(response.body)
    generated_idea = json_response['choices'][0]['text']

    
  end
end
