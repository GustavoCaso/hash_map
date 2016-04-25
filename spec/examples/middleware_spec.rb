require 'spec_helper'

describe 'Middleware' do
  class RemoveNilValuesMiddleware
    attr_accessor :hash
    def initialize(hash)
      @hash = hash
    end

    def call
      hash.reject! do |k,v|
        v == nil
      end
    end
  end

  HashMap.configure do |config|
    config.middlewares[:after_map] = RemoveNilValuesMiddleware
  end

  class BlocksTwo < HashMap::Base

    from_child :address do
      property :street do |address|
        address[:street].upcase
      end
      property :owner do |address, original|
        original[:name]
      end
      from_child :country do
        property :country
      end
    end
    property :name do |original|
      original[:name]
    end
  end

  let(:original) do
    {
      name: 'name',
      address: {
        street: 'street',
        country: nil
      }
    }
  end
  subject { BlocksTwo.map(original) }
  it { expect(subject[:name]).to eq 'name' }
  it { expect(subject[:owner]).to eq 'name' }
  it { expect(subject[:street]).to eq 'STREET' }
  it { expect(subject.keys).to eq ["street", "owner", "name"] }
end
