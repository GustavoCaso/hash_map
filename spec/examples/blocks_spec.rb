require 'spec_helper'
require 'pry'
describe 'Blocks' do
  describe 'inside from_child' do
    class Blocks < HashMap::Base

      from_child :address do
        property :street do |address|
          address[:street].upcase
        end
        property :owner do |address, original|
          original[:name]
        end
        from_child :country do
          property :country do |country|
            country[:code].upcase
          end
        end
      end
      property :name do |original|
        original[:name]
      end
      property :class_name do
        self.class.name
      end
    end

    let(:original) do
      {
        name: 'name',
        address:{
          street: 'street',
          country:{
            code: 'es'
          }
        }
      }
    end
    subject { Blocks.map(original) }
    it { expect(subject[:name]).to eq 'name' }
    it { expect(subject[:owner]).to eq 'name' }
    it { expect(subject[:street]).to eq 'STREET' }
    it { expect(subject[:country]).to eq 'ES' }
    it { expect(subject[:class_name]).to eq 'Blocks' }
  end
end
