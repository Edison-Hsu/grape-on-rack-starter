class AddActionSmsRecord < ActiveRecord::Migration[5.0]
  def up
   add_column :sms_records, :action, :string
  end

  def down
   remove_column :sms_records, :action, :string
  end
end
