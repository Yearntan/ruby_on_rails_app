class AddActiveToAnswerAlerts < ActiveRecord::Migration[7.0]
  def change
    add_column :answer_alerts, :active, :boolean, default: true
  end
end