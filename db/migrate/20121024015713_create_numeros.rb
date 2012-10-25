class CreateNumeros < ActiveRecord::Migration
  def change
    create_table :numeros do |t|

      t.timestamps
    end
  end
end
