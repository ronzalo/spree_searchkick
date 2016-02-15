require 'spec_helper'

RSpec.describe Spree::Property, type: :model do
  describe '#filter_name' do
    let(:property) { create(:property, name: 'awesome_property') }

    it 'respond with property name downcased' do
      expect(property.filter_name).to eq('awesome_property')
    end
  end
end
