class AddFiltrableToSpreeTaxonomies < ActiveRecord::Migration[5.0]
  def change
    add_column :spree_taxonomies, :filterable, :boolean
  end
end
