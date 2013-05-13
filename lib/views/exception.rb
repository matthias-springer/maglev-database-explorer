class Exception
  def to_database_view(depth, ranges = {}, params = {})
    params_with_full_string = {:fullString => true}
    obj = super

    obj[:exception] = true
    obj[:inspection] = self.inspect
    obj[:basetype] = :exception
    
    if depth > 0
      obj[:gsResumable] = self.instance_variable_get("@_st_gsResumable").to_database_view(depth - 1, {}, params)
      obj[:gsStack] = self.instance_variable_get("@_st_gsStack").to_database_view(depth, {}, params_with_full_string)
      obj[:gsReason] = self.instance_variable_get("@_st_gsReason").to_database_view(depth - 1, {}, params)
      obj[:gsTrappable] = self.instance_variable_get("@_st_gsTrappable").to_database_view(depth, {}, params)
      obj[:currGsHandler] = self.instance_variable_get("@_st_currGsHandler").to_database_view(depth - 1, {}, params)
      obj[:gsDetails] = self.instance_variable_get("@_st_gsDetails").to_database_view(depth - 1, {}, params)
    end

    return obj
  end
end
