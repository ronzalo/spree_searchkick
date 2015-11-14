require 'spec_helper'

RSpec.describe Spree::Taxonomy, type: :model do
  describe '#filter_name' do
    let(:taxonomy) { create(:taxonomy, name: 'awesome_category') }

    it 'respond with taxonomy name downcased' do
      taxonomy.filter_name.should eq 'awesome_category_ids'
    end
  end
end
