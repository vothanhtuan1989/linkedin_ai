RSpec.describe OpenaiCallCommand do
  describe '#call' do
    let(:user_input) { 'Who works at Google?' }
    let(:openai_output) { 'According to your connections, John Smith and Jane Doe work at Google.' }
    let(:client) { instance_double(OpenAI::Client) }
    let(:response) { { "choices" => [{ "message" => { "content" => openai_output } }] } }

    before do
      allow(OpenAI::Client).to receive(:new).and_return(client)
      allow(client).to receive(:chat).and_return(response)
    end

    it 'creates a user message from the user input' do
      expect {
        OpenaiCallCommand.new(user_input: user_input).call
      }.to change(Message, :count).by(2)
      expect(Message.find_by(user: true).content).to eq(user_input)
      expect(Message.find_by(user: true).user).to be_truthy
    end

    it 'creates an AI message from the OpenAI output' do
      expect {
        OpenaiCallCommand.new(user_input: user_input).call
      }.to change(Message, :count).by(2)
      expect(Message.find_by(user: false).content).to eq(openai_output)
      expect(Message.find_by(user: false).user).to be_falsy
    end
  end
end