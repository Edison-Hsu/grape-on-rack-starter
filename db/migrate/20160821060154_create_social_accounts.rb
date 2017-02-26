class CreateSocialAccounts < ActiveRecord::Migration[5.0]
  def up
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto') 
    create_table :social_accounts, id: :uuid, default: 'gen_random_uuid()'do |t|
      t.uuid :user_id
      t.string :identifier, null: false
      t.string :type, limit: 128, null: false
      t.jsonb :raw

      t.datetime :deleted_at, null: true
      t.timestamps null: true

      t.index [:deleted_at, :type, :identifier], unique: true
    end
  end

  def down
    drop_table :social_accounts
  end
end
