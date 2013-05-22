class Boolean
  def to_database_view(depth, ranges = {}, params = {})
    obj = super
    obj[:basetype] = :boolean
    obj[:value] = self

    return obj
  end
end
