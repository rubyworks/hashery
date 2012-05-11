require 'lemon'
require 'ae'

require 'hashery/open_hash'

testcase OpenHash do

  class_method :new do
    test do
      o = OpenHash.new(:a=>1, :b=>2)
      o.a.assert == 1
      o.b.assert == 2
    end
    test do
      o = OpenHash.new(:a=>1, :b=>2)
      o.a.assert == 1
      o.b.assert == 2
    end
  end

end

