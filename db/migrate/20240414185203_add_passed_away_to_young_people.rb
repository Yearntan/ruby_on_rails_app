class AddPassedAwayToYoungPeople < ActiveRecord::Migration[7.0]
  def change
    add_column :young_people, :passed_away, :boolean, default: false
  end
end
