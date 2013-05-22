AbstractException = __resolve_smalltalk_global(:AbstractException)

class AbstractException
  primitive '__resume', 'resume'

  def to_database_view(depth, ranges = {}, params = {})
    obj = super

    obj[:exception] = true
    obj[:inspection] = self.inspect
    obj[:basetype] = :exception
    
    # need to fetch these ivs explicitly since they're hidden by rubyPrivateSize
    obj[:gsResumable] = self.instance_variable_get("@_st_gsResumable") != false
    obj[:gsTrappable] = self.instance_variable_get("@_st_gsTrappable") != false
    obj[:gsNumber] = self.instance_variable_get("@_st_gsNumber")
    obj[:isDBEHalt] = self.class == DBEHalt

    return obj
  end
end

