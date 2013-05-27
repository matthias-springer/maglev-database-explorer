class String
  def __basetype
    :string
  end

  def to_database_view(depth, ranges = {}, params = {})
    obj = super

    obj[:string] = self[0, 200]
    if (obj[:string].size < self.size)
      obj[:string] += "..."
      obj[:stringComplete] = false
    else
      obj[:stringComplete] = true
    end

    if (params[:fullString])
      obj[:string] = self
      obj[:stringComplete] = true
    end

    return obj
  end

  primitive '__evaluate_smalltalk_in_context', 'evaluateInContext:'
end

