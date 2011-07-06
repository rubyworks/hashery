require 'hashery/openhash'

TestCase OpenHash do

  Meta :new do
    o = OpenHash.new(:a=>1, :b=>2)
    o.a.assert == 1
    o.b.assert == 2
  end

  Meta :new do
    o = OpenHash.new(:a=>1, :b=>2)
    o.a.assert == 1
    o.b.assert == 2
  end

end

