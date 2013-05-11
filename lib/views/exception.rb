class Exception
  def to_database_view(depth, ranges = {}, params = {})
    obj = super

    obj[:exception] = true
    obj[:inspection] = self.inspect
    
    return obj
  end
end
