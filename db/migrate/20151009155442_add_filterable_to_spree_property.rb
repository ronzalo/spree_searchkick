class AddFilterableToSpreeProperty < ActiveRecord::Migration
  def change
    add_column :spree_properties, :filterable, :boolean
  end
end
