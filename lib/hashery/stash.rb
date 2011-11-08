require 'hashery/keyhash'

Stash = KeyHash

class Hash
  # Convert Hash to Stash.
  def to_stash
    Stash[self]
  end
end
