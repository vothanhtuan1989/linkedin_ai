class UploadCsvCommand
  prepend SimpleCommand

  def initialize(file:)
    @file = file
  end

  def call
    return false unless file_valid?

    create_connection
  end

  private

  attr_reader :file

  def file_valid?
    if file.present? && file.content_type == "text/csv"
      true
    else
      errors.add(:error, "Please upload a valid CSV file.")
      false
    end
  end

  def create_connection
    # create a CSV object from the file
    csv = CSV.new(file.read, headers: true)
    
    # iterate over the rows of the CSV object
    csv.each do |row|
      # create a new connection from the row values
      connection = Connection.new(
        first_name: row["First Name"],
        last_name: row["Last Name"],
        url: row["URL"],
        email_address: row["Email Address"],
        company: row["Company"],
        position: row["Position"],
        connected_on: row["Connected On"]
      )
      
      # save the connection or handle any errors
      unless connection.save
        errors.add(:error, "Please upload a valid CSV file.")
        break
      end
    end
  end
end