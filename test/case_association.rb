require 'hashery/association'

Case Association do

  Unit :new do
    Association.new(:A, :B)
  end

  Unit :to_ary do
    k,v = [],[]
    ohash = [ 'A' >> '3', 'B' >> '2', 'C' >> '1' ]
    ohash.each { |e1,e2| k << e1 ; v << e2 }
    k.assert == ['A','B','C']
    v.assert == ['3','2','1']
  end

  Unit :index do
    complex = [ 'Drop Menu' >> [ 'Button 1', 'Button 2', 'Button 3' ], 'Help' ]
    complex[0].index.assert == 'Drop Menu'
  end

  Unit :associations do
    complex = [ :a >> :b, :a >> :c ]
    :a.associations.assert == [ :b, :c ]
  end

end

