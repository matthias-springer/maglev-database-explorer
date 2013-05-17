# AbstractException may not be modified

class AbstractExceptionProxy
  def self.for(exception)
    instance = self.new
    instance.exception = exception
    instance
  end

  def exception=(val)
    @exception = val
  end

  def to_database_view(obj, depth, ranges = {}, params = {})
    obj[:exception] = true
    obj[:inspection] = @exception.inspect
    obj[:basetype] = :exception
  
    return obj
  end
end

