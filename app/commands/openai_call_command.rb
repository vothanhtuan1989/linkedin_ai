class OpenaiCallCommand
  prepend SimpleCommand

  def initialize(user_input:)
    @user_input = user_input
  end

  def call
    Message.create!(content: user_input, user: true)
    Message.create!(content: openai_output, user: false)
  end

  private

  attr_reader :user_input

  def client
    OpenAI::Client.new(access_token: ENV["OPENAI_ACCESS_TOKEN"])
  end

  def user_network
    Connection.all.to_json
  end

  def openai_response
    client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [
          {"role": "system", "content": "You are a helpful assistant that can answer questions about your LinkedIn connections."},
          {"role": "system", "content": user_network},
          {"role": "user", "content": user_input}
        ],
        max_tokens: 500,
        temperature: 0.9,
        stop: "\n"
      }
    )
  end

  def openai_output
    openai_response.dig("choices", 0, "message", "content")
  end

  def create_message(content:, user:)
    Message.create(content:, user:)
  end
end