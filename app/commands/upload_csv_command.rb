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
    csv = CSV.new(file.read, headers: true)

    Connection.transaction do
      csv.each do |row|
        connection = Connection.create(
          first_name: row["First Name"],
          last_name: row["Last Name"],
          url: row["URL"],
          email_address: row["Email Address"],
          company: row["Company"],
          position: row["Position"],
          connected_on: row["Connected On"]
        )

        unless connection.valid?
          errors.add(:error, "Please upload a valid CSV file.")
          raise ActiveRecord::Rollback
        end
      end
    end
  end
end