class UpdateNotes < ActiveRecord::Migration
  def change
    change_table :notes do |t|
      t.column :notable_id, :integer
      t.column :notable_type, :string
    end

  end
end
