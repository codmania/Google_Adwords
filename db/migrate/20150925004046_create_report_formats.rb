class CreateReportFormats < ActiveRecord::Migration
  def change
    create_table :report_formats do |t|

      t.timestamps null: false
    end
  end
end
