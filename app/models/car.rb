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

class Car < ApplicationRecord
    before_validation :upper_vin, :check_vin
    validates :make, :model, :year, :vin, presence: true
    validates :vin, length: {is: 17}
    validates :vin, uniqueness: true
    validates :make, uniqueness: {scope: [:model, :year]}
    validates :year, numericality: { only_integer: true, greater_than_or_equal_to: 1900, less_than_or_equal_to: 2020 , message: "is not a valid year" }
    validates :cylinders, numericality: { only_integer: true, even: true, greater_than_or_equal_to: 4, less_than_or_equal_to: 12 ,  message: "is not a valid cylinder" }
    validates :category, inclusion: { in: %w(car sport suv truck), message: "is not a valid category" }
    
    private
    
    def upper_vin
        self.vin = vin.upcase if self.vin
    end
    def check_vin
        self.errors.add(:vin, 'invalid representation') if self.vin && self.vin !~ /[0-9A-Z]{17}$/
    end
    def check_year
         self.errors.add(:year, 'invalid year') if self.year===(1900..2020)
    end
  
end
