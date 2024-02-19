require 'csv'

RSpec.describe UploadCsvCommand do
  describe '#call' do
    let(:file) { fixture_file_upload('connections.csv', 'text/csv') }
    let(:invalid_file) { fixture_file_upload('invalid.csv', 'text/plain') }
    
    context 'with a valid file' do
      it 'returns true' do
        cmd = UploadCsvCommand.new(file: file)
        expect(cmd.call).to be_truthy
      end
      
      it 'creates connections from the file' do
        expect {
          UploadCsvCommand.new(file: file).call
        }.to change(Connection, :count).by(9)
      end
      
      it 'does not add any errors' do
        cmd = UploadCsvCommand.new(file: file)
        cmd.call
        expect(cmd.errors).to be_empty
      end
    end
    
    context 'with an invalid file' do
      it 'returns false' do
        cmd = UploadCsvCommand.new(file: invalid_file)
        expect(cmd.call.result).to be_falsy
      end
      
      it 'does not create any connections' do
        expect {
        UploadCsvCommand.new(file: invalid_file).call
        }.not_to change(Connection, :count)
      end
      
      it 'adds an error message' do
        cmd = UploadCsvCommand.new(file: invalid_file)
        cmd.call
        expect(cmd.errors[:error]).to include('Please upload a valid CSV file.')
      end
    end
  end
end