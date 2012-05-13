require 'helper'

test_case LRUHash do

  class_method :new do
    h = LRUHash.new(10)
    LRUHash.assert === h
  end

end
