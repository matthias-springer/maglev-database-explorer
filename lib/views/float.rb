class Float
  def to_database_view(depth, ranges = {})
    obj = super
    obj[:basetype] = :float

    return obj
  end
end

