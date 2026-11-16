require 'helper'

test_case IniHash do

  class_method :new do
    test do
      h = IniHash.new('foo.ini', false)
    end

    test "from a hash" do
      h = IniHash.new('a' => '1')
      h['a'].assert == '1'
    end
  end

  class_method :text do
    test do
      IniHash.text('a' => '1', 'b' => {'c' => '3'}).assert == "a=1\n[b]\nc=3\n"
    end
  end

  class_method :write_to_file do
    test "with a comment" do
      require 'tmpdir'
      Dir.mktmpdir do |dir|
        path = File.join(dir, 'out.ini')
        IniHash.write_to_file(path, {'a' => '1'}, "one\ntwo\n")
        File.read(path).assert == "# one\n# two\na=1\n"
        IniHash.read_comment_from_file(path).assert == "one\ntwo\n"
        IniHash.read_from_file(path).assert == {'a' => '1'}
      end
    end
  end

  method :[]= do
    test do
      h = IniHash.new('foo.ini', false)
      h['a'] = '1'
      h['a'].assert = '1'
    end
  end

  method :[] do
    test do
      h = IniHash.new('foo.ini', false)
      h['a'] = '1'
      h['a'].assert = '1'
    end
  end

  method :to_h do
    test do
      h = IniHash.new('foo.ini', false)
      h['a'] = '1'
      h.to_h.assert = {'a'=>'1'}
    end
  end

  method :to_s do
    test do
      h = IniHash.new('foo.ini', false)
      h['a'] = '1'
      h.to_s.assert == "a=1\n"
    end

    test do
      h = IniHash.new('foo.ini', false)
      h['a'] = '1'
      h['b'] = {'c'=>3}
      h.to_s.assert == "a=1\n[b]\nc=3\n"
    end
  end

  class_method :load do
    h = IniHash.load('test/fixture/example.ini')
    h['a'].assert == '1'
  end

end

