class CreateSmsHistories < ActiveRecord::Migration[5.0]
  def up
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto') 
    create_table :sms_records, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.string :mobile, limit: 32, null: false
      t.string :code, limit: 16
      t.datetime :expired_at, limit: 4
      t.datetime :verified_at, null: true
      t.string :channel
      t.jsonb :result

      t.timestamps null: true

      t.index [:mobile, :created_at]
    end
  end

  def down
    drop_table :sms_records
  end
end
