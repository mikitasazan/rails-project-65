class CreateBulletins < ActiveRecord::Migration[8.1]
  def change
    create_table :bulletins do |t|
      t.string :title
      t.text :description
      t.string :state, default: "draft", null: false

      t.references :category, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
