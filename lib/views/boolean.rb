class Boolean
  def __basetype
    :boolean
  end

  def to_database_view(depth, ranges = {}, params = {})
    obj = super
    obj[:value] = self

    return obj
  end
end
