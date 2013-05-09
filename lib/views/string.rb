class String
  def to_database_view(depth, ranges = {})
    obj = super
    obj[:basetype] = :string

    return obj
  end
end

