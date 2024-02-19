require 'csv'

RSpec.describe CsvController, type: :controller do
  # test the new action
  describe "GET #new" do
    it "renders the new template" do
      get :new
      expect(response).to render_template(:new)
    end
  end
  
  # test the create action
  describe "POST #create" do
    # use a let variable to define a valid CSV file
    let(:valid_file) do
      fixture_file_upload("connections.csv", "text/csv")
    end
    
    # use a let variable to define an invalid CSV file
    let(:invalid_file) do
      fixture_file_upload("invalid.csv", "text/csv")
    end
    
    context "with a valid file" do
      it "creates connections from the file" do
        expect {
        post :create, params: { file: valid_file }
        }.to change(Connection, :count).by(9)
      end
      
      it "redirects to the connections index page" do
        post :create, params: { file: valid_file }
        expect(response).to redirect_to(connections_path)
      end
    end
    
    context 'with an invalid CSV file' do
      it 'does not create any connections' do
        expect {
        post :create, params: { file: invalid_file }
        }.not_to change(Connection, :count)
      end
      
      it 'renders the new template' do
        post :create, params: { file: invalid_file }
        expect(response).to render_template(:new)
      end
      
      it 'sets a flash error message' do
        post :create, params: { file: invalid_file }
        expect(flash[:error].size).to be > 0
      end
    end
  end
end