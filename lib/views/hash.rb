class Hash
  def to_database_view(depth, ranges = {}, params = {})
    obj = super
    
    obj[:basetype] = :hash

    return obj
  end
end
