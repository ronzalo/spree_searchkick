class AddFilterableToSpreeProperty < ActiveRecord::Migration[5.0]
  def change
    add_column :spree_properties, :filterable, :boolean
  end
end
