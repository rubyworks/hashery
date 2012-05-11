require 'hashery/crud_hash'
require 'hashery/open'

module Hashery

  # OpenHash is a Hash, but is also fully open.
  #
  class OpenHash < CRUDHash
    include Open
  end

end
