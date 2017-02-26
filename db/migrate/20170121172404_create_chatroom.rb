class CreateChatroom < ActiveRecord::Migration[5.0]
  def up
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto') 
    create_table :chatrooms, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.uuid :user_id
      t.string :title, limit: 32
      t.string :leancloud_chatroom_id

      t.timestamps null: true
    end
  end

  def down
    drop_table :chatrooms
  end
end
