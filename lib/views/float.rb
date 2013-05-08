class Float
  def to_database_view(depth, range_from = 1, range_to = 10)
    obj = super
    obj[:basetype] = :float

    return obj
  end
end

