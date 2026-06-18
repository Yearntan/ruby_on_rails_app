class AddIdToAnswersBubbles < ActiveRecord::Migration[7.0]
  def change
    add_column :answers_bubbles, :id, :primary_key
  end
end
