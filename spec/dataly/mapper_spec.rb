require 'spec_helper'

class Sample
end

class FieldMapper < Dataly::Mapper
  USERS = {'beaker@example.com' => 1}

  rename :user, to: :user_id

  field :user_id, value: :find_user_id
  field :age, value: Proc.new { |value| value.to_i }
  field :status, value: :update_status
  field :properties, value: :other

  def update_status(value, csv_values)
    value.downcase
  end

  def find_user_id(value, csv_values)
    USERS[value]
  end

  def other(value, values)
    "#{value} - #{values[:other_value]}"
  end
end

class SecondFieldMapper < Dataly::Mapper
  rename :user_2, to: :user_id
end

describe Dataly::Mapper do
  let(:valid_attributes) { %i(name status address properties user_id age) }
  let(:mapper) { FieldMapper.new(Sample) }

  let(:row) do
    {
      name: 'beaker',
      status: 'Active',
      age: '21',
      pets: 'false',
      address: '',
      user: 'beaker@example.com',
      other_value: 'Some other Value',
      properties: 'XXX'
    }
  end

  before do
    allow(Sample).to receive(:attribute_names).and_return(valid_attributes)
  end

  specify { expect(mapper.process(row)).to eq({ name: 'beaker', address: nil, status: 'active', user_id: 1, age: 21, properties: 'XXX - Some other Value' }) }
  specify { expect(mapper.fields.keys).to eq([:user_id, :age, :status, :properties]) }
  specify { expect(mapper.renames.keys).to eq([:user]) }
end
