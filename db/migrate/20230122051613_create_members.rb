class CreateMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :members do |t|
      t.string :email
      t.datetime :deactivated_at

      t.timestamps
    end
  end
end
