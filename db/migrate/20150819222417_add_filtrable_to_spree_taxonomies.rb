class AddFiltrableToSpreeTaxonomies < ActiveRecord::Migration
  def change
    add_column :spree_taxonomies, :filterable, :boolean
  end
end
