class CsvController < ApplicationController
  def new
  end

  def create
    # get the uploaded file from the params
    file = params[:file]
    
    # check if the file is present and valid
    if file.present? && file.content_type == "text/csv"
      # create a CSV object from the file
      csv = CSV.new(file.read, headers: true)
      
      # iterate over the rows of the CSV object
      csv.each do |row|
        # create a new connection from the row values
        connection = Connection.new(
        first_name: row["First Name"],
        last_name: row["Last Name"],
        email_address: row["Email Address"],
        company: row["Company"],
        position: row["Position"],
        connected_on: row["Connected On"]
        )
        
        # save the connection or handle any errors
        unless connection.save
          flash[:error] = connection.errors.full_messages.to_sentence
          break
        end
      end
      
      # redirect to the connections index page or render the upload form again
      if flash[:error].blank?
        redirect_to connections_path
      else
        render :new
      end
    else
      # flash an error message and render the upload form again
      flash[:error] = "Please upload a valid CSV file."
      render :new
    end
  end
end
