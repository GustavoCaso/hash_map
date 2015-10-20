require 'spec_helper'
require 'pry'
module HashMap
  describe Base do
    let(:original) do
      {
        name: 'Artur',
        first_surname: 'hello',
        second_surname: 'world',
        address: {
          postal_code: 12345,
          country: {
            name: 'Spain',
            language: 'ES'
          }
        },
        email: 'asdf@sdfs.com',
        phone: nil
      }
    end
    class ProfileMapper < HashMap::Base
      property :first_name, from: :name
      property(:last_name) { |input| "#{input[:first_surname]} #{input[:second_surname]}" }
      property :language, from: [:address, :country, :language], transform: proc {|context, value| value.downcase }

      from_children :address do
        property :code, from: :postal_code
        from_children :country do
          property :country_name
        end
      end

      to_children :email do
        property :address, from: :email
        property :type, default: :work
      end

      property :telephone, from: :phone
    end

    subject { ProfileMapper.new(original) }

    it { expect(subject[:first_name]).to eq original[:name] }
    it { expect(subject[:language]).to eq original[:address][:country][:language] }
    it { expect(subject[:last_name]).to eq  "#{original[:first_surname]} #{original[:second_surname]}"}
    it { expect(subject[:email][:address]).to eq  original[:email]}
    it { expect(subject[:email][:type]).to eq :work }

  end
end
