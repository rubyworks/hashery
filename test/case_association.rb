require 'helper'

# must be required independently
require 'hashery/association'

testcase Association do

  class_method :new do
    test do
      Association.new(:A, :B)
    end
  end

  method :to_ary do
    test do
      k,v = [],[]
      ohash = [ 'A' >> '3', 'B' >> '2', 'C' >> '1' ]
      ohash.each { |e1,e2| k << e1 ; v << e2 }
      k.assert == ['A','B','C']
      v.assert == ['3','2','1']
    end
  end

  method :index do
    test do
      complex = [ 'Drop Menu' >> [ 'Button 1', 'Button 2', 'Button 3' ], 'Help' ]
      complex[0].index.assert == 'Drop Menu'
    end
  end

end

testcase Object do
  method :associations do
    test do
      complex = [ :a >> :b, :a >> :c ]
      :a.associations.assert == [ :b, :c ]
    end
  end

end

