class NilClass
  def to_database_view(depth, range_from = 1, range_to = 10)
    obj = super

    if (depth > 0)
      obj[:basetype] = :nilclass
    end

    return obj
  end
end

