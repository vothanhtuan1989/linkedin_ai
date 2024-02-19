class MessagesController < ApplicationController
  def create
    user_input = params[:message][:content]
    
    cmd = OpenaiRequestCommand.call(user_input:)

    if cmd.success?
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace(
              'messages',
              partial: 'chats/messages',
              locals: { messages: Message.all }
            ),
            turbo_stream.replace(
              'form_message',
              partial: 'chats/form',
              locals: { message: Message.new }
            )
          ]
        end
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace(
              'flash',
              html: cmd.errors[:error][0]
            )
          ]
        end
      end
    end
  end
end