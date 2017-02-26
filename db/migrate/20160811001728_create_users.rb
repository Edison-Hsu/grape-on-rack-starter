class CreateUsers < ActiveRecord::Migration[5.0]
  def up
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
    create_table :users, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.string :username, limit: 255
      t.string :password_hash, limit: 255
      t.string :email, limit: 255
      t.string :phone, limit: 64
      t.jsonb :profile

      t.timestamps null: true

      t.index :phone, unique: true
      t.index :email, unique: true
      t.index :username, unique: true
    end
  end

  def down
    drop_table :users
  end
end
