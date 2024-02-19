class MessagesController < ApplicationController
  def index
    # get all the messages ordered by created_at
    @messages = Message.order(:created_at)
  end
  
  def create
    # get the user input from the params
    user_input = params[:message][:content]
    
    # create a new message from the user input
    user_message = Message.create(content: user_input, user: true)
    
    # get the user's network data from the Connection model
    user_network = Connection.all
    
    # query the OpenAI API with the user input and the user's network data
    client = OpenAI::Client.new(access_token: ENV["OPENAI_ACCESS_TOKEN"])

    openai_response = client.chat(
      parameters: {
        model: "gpt-3.5-turbo", # Required.
        # prompt: user_input,
        messages: [{ role: "user", content: user_input}], # Required.
        temperature: 0.7,
    })
    
    # get the AI output from the response
    ai_output = openai_response.dig("choices", 0, "message", "content")
    
    # create a new message from the AI output
    ai_message = Message.create(content: ai_output, user: false)
    
    # # broadcast the AI message to the chat
    # turbo_stream.append :messages, partial: "messages/message", locals: { message: ai_message }

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace(
            'messages',
            partial: 'chat/messages',
            locals: { messages: Message.all }
          ),
          turbo_stream.replace(
            'form_message',
            partial: 'chat/form',
            locals: { message: Message.new }
          )
        ]
      end
    end
  end
end