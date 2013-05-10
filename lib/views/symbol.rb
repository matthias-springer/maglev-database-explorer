class Symbol
  def to_database_view(depth, ranges = {}, params = {})
    obj = super
    obj[:basetype] = :symbol

    return obj
  end
end

