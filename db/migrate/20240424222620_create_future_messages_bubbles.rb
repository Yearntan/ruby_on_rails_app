class CreateFutureMessagesBubbles < ActiveRecord::Migration[7.0]
  def change
    create_table :future_messages_bubbles do |t|
      t.references :future_message, null: false, foreign_key: true, type: :uuid
      t.references :bubble, null: false, foreign_key: true, type: :uuid
      t.timestamps
    end

    # Shorten the index name
    add_index :future_messages_bubbles, [:future_message_id, :bubble_id], unique: true, name: 'index_fmsg_bubbles_on_fmsg_id_and_bubble_id'
  end
end
