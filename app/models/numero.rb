class Numero < ActiveRecord::Base
  # attr_accessible :title, :body

  def self.is_numeric?(num)
    true if Float(num) rescue false
  end
end
