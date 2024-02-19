require 'csv'

class CsvController < ApplicationController
  def new
  end

  def create
    cmd = UploadCsvCommand.call(file: params[:file])

    if cmd.success?
      redirect_to connections_path
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
