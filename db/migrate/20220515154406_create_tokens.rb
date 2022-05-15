class CreateTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :tokens do |t|
      t.string :value
      t.datetime :expires_at
      t.references :user

      t.timestamps
    end
  end
end
