class CreateChatroomsMembers < ActiveRecord::Migration[5.0]
  def up
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto') 
    create_table :chatroom_members, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.uuid :user_id
      t.uuid :room_id
      t.string :role, limit: 32

      t.timestamps null: true
    end
  end

  def down
    drop_table :chatroom_members
  end
end
