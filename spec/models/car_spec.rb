# == Schema Information
#
# Table name: cars
#
#  id           :integer          not null, primary key
#  make         :string           not null
#  model        :string           not null
#  year         :integer          not null
#  vin          :string           not null
#  color        :string           default("black")
#  category     :string           default("car")
#  cylinders    :integer          default(4)
#  displacement :float            default(0.0)
#  mpg          :integer          default(0)
#  hp           :integer          default(0)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe Car, type: :model do
  describe '.new' do
    it 'instantiates a Car object' do
      c = Car.new
      expect(c.is_a?(Car)).to be true
      expect(c.attributes.keys.count).to eql(13)
    end
  end

  describe '#save' do
    context 'happy path' do
      it 'saves a car' do
        c = Car.new(make: 'Ford', model: 'Fusion', year: 2015, vin: 'ABCDEFGHIJKLM0099')
        c.save
        expect(c.id).to_not be_nil
        expect(c.created_at).to_not be_nil
        expect(c.updated_at).to_not be_nil
      end
    end
    context 'invalid data' do
      it 'missing model, year - will not save' do
        c = Car.new(make: 'Ford', vin: 'abcd')
        c.save
        expect(c.id).to be_nil
        expect(c.errors[:model].first).to eql("can't be blank")
        expect(c.errors[:year].first).to eql("can't be blank")
      end
      it 'vin number is too short - will not save' do
        c = Car.new(make: 'Ford', model: 'Fusion', year: 2015, vin: 'abcd')
        c.save
        expect(c.id).to be_nil
        expect(c.errors[:vin].second).to eql("is the wrong length (should be 17 characters)")
      end
      it 'vin number has incorrect syntax' do
        c = Car.new(make: 'Ford', model: 'Fusion', year: 2015, vin: '*12345678@ABCDEFZ')
        c.save
        expect(c.id).to be_nil
        expect(c.errors[:vin].first).to eql("invalid representation")
      end
      it 'vin number already taken' do
        c = Car.new(make: 'Ford', model: 'Fusion', year: 2015, vin: 'ABCDEFGHIJKLM0012')
        c.save
        expect(c.id).to be_nil
        expect(c.errors[:vin].first).to eql("has already been taken")
      end
      it 'unique validator for make, model, year' do
        c = Car.new(make: 'Toyota', model: 'Camry', year: 2015, vin: 'ABCDEFGHIJKLM0012')
        c.save
        expect(c.id).to be_nil
        expect(c.errors[:make].first).to eql("has already been taken")
      end
      it 'is year valid' do
        c = Car.new(make: 'Toyota', model: 'Camry', year: 1100, vin: 'ABCDEFGHIJKLM0112')
        c.save
        expect(c.id).to be_nil
        expect(c.errors[:year].first).to eql("is not a valid year")
      end
      it 'is cylinders valid' do
        c = Car.new(make: 'Toyota', model: 'Camry', cylinders: 16, vin: 'ABCDEFGHIJKLM0115')
        c.save
        expect(c.id).to be_nil
        expect(c.errors[:cylinders].first).to eql("is not a valid cylinder")
      end
      it 'is cylinders valid' do
        c = Car.new(make: 'Toyota', model: 'Camry', category: 'test', vin: 'ABCDEFGHIJKLM0115')
        c.save
        expect(c.id).to be_nil
        expect(c.errors[:category].first).to eql("is not a valid category")
      end
    end
  end
end