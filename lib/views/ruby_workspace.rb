class RubyWorkspace
  def to_database_view(depth, ranges = {}, params = {})
    obj = super
    obj[:basetype] = :rubyWorkspace

    return obj
  end
end

