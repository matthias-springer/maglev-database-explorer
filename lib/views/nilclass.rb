class NilClass
  def to_database_view(depth, ranges = {})
    obj = super
    obj[:basetype] = :nilclass

    return obj
  end
end

