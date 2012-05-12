require 'helper'

testcase OpenHash do

  class_method :[] do
    test do
      o = OpenHash[:a=>1, :b=>2]
      o.a.assert == 1
      o.b.assert == 2
    end
    test do
      o = OpenHash[:a=>1, :b=>2]
      o.a.assert == 1
      o.b.assert == 2
    end
  end

end

