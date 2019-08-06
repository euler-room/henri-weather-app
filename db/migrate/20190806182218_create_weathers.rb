class CreateWeathers < ActiveRecord::Migration[5.2]
  def change
    create_table :weathers do |t|
      t.string :zip
      t.string :city
      t.string :state
      t.timestamps
    end
  end
end
