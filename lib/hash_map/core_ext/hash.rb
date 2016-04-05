class Hash
  # Return the hash with the structure from the Mapper
  #
  # hash = { user: { name: 'John', surname: 'Doe' } }
  # hash.hash_map_with(UserMapper)
  def hash_map_with(mapper)
    HashMap::Mapper.new(self, mapper.new).output
  end
end
