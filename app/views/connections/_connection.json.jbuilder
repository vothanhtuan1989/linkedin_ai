json.extract! connection, :id, :first_name, :last_name, :email_address, :company, :position, :connected_on, :created_at, :updated_at
json.url connection_url(connection, format: :json)
