class Fixnum
  def to_database_view(depth, ranges = {}, params = {})
    obj = super
    obj[:basetype] = :fixnum

    return obj
  end
end
