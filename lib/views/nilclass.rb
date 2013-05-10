class NilClass
  def to_database_view(depth, ranges = {}, params = {})
    obj = super
    obj[:basetype] = :nilclass

    return obj
  end
end

