class OpenaiRequestCommand
  prepend SimpleCommand

  def initialize(user_input:)
    @user_input = user_input
  end

  def call
    return false unless validate_user_input
    create_message(content: user_input, user: true)
    create_message(content: openai_output, user: false)
  end

  private

  attr_reader :user_input

  def validate_user_input
    unless user_input.present?
      errors.add(:error, "User input can not be blank!")
      false
    else
      true
    end
  end

  def client
    OpenAI::Client.new(access_token: ENV["OPENAI_ACCESS_TOKEN"])
  end

  def user_network
    @user_network ||= Connection.all.to_json
  end

  def openai_response
    response = client.chat(
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

    return response
  rescue OpenAI::Error => e
    Rails.logger.error("OpenAI API request failed: #{e.message}")
    errors.add(:error, e.message)
    return nil
  rescue JSON::ParserError => e
    Rails.logger.error("OpenAI API response was not a valid JSON: #{e.message}")
    errors.add(:error, e.message)
    return nil
  rescue StandardError => e
    Rails.logger.error("OpenAI API request encountered an unknown error: #{e.message}")
    errors.add(:error, e.message)
    return nil
  end

  def openai_output
    return "" unless openai_response.present?
    openai_response.dig("choices", 0, "message", "content")
  end

  def create_message(content:, user:)
    message = Message.new(content:, user:)

    unless message.save
      errors.add(:error, message.errors.full_messages.to_sentence)
    end
  end
end