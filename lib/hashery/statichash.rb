# = statichash
#
# == Copyright (c) 2005 Thomas Sawyer, Gavin Kistner
#
#   Ruby License
#
#   This module is free software. You may use, modify, and/or redistribute this
#   software under the same terms as Ruby.
#
#   This program is distributed in the hope that it will be useful, but WITHOUT
#   ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
#   FOR A PARTICULAR PURPOSE.
#
# == SPECIAL THANKS
#
# Special thanks go to Gavin Kistner.
#
# StaticHash is based on WriteOnceHash in basiclibrary.rb,
# Copyright (c) 2004 by Gavin Kistner.
#
# It is covered under the license viewable at
#
#   http://phrogz.net/JS/_ReuseLicense.txt
#
# Reuse or modification is free provided you abide by the terms of that
# license. (Including the first two lines above in your source code
# usually satisfies the conditions.)
#
# == Author(s)
#
# * Thomas Sawyer
# * Gavin Kistner

# Author::    Thomas Sawyer, Gavin Kistner
# Copyright:: Copyright (c) 2005 Thomas Sawyer, Gavin Kistner
# License::   Ruby License

# = StaticHash
#
# A Hash object which raises an error if any
# previously-defined key attempts to be set again.
#
# == Synopsis
#
#   foo = Hash::Static.new
#   foo['name'] = 'Tom'    #=> 'Tom'
#   foo['age']  = 30       #=> 30
#   foo['name'] = 'Bob'
#
# _produces_
#
#   Error: StaticHash has value for key 'name' in object:
#       {"name"=>"Tom", "age"=>30} (RuntimeError)  
#

class StaticHash < Hash

  # Set a value for a key;
  # raises an error if that key already exists with a different value.
  def []=(key,val)
    if self.has_key?(key) && self[key]!=val
      raise ArgumentError, "StaticHash already has value for key '#{key.to_s}'"
    end
    super
  end

end



#  _____         _
# |_   _|__  ___| |_
#   | |/ _ \/ __| __|
#   | |  __/\__ \ |_
#   |_|\___||___/\__|
#

=begin testing

  require 'test/unit'

  class TC_StaticHash < Test::Unit::TestCase 

    def setup
      @sh1 = StaticHash.new
    end

    def test_assign
      @sh1["x"] = 1
      assert_raises( ArgumentError ){  @sh1["x"] = 2 }
    end

  end

=end
