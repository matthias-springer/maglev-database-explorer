class String
  def to_database_view(depth, range_from = 1, range_to = 10)
    obj = super

    if (depth > 0)
      obj[:basetype] = :string
    end

    return obj
  end
end

