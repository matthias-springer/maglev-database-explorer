class Symbol
  def __basetype
    :symbol
  end

  def to_database_view(depth, ranges = {}, params = {})
    obj = super

    obj[:string] = self.to_s[0, 200]
    if (obj[:string].size < self.to_s.size)
      obj[:string] += "..."
      obj[:stringComplete] = false
    else
      obj[:stringComplete] = true
    end

    if (params[:fullString])
      obj[:string] = self.to_s
      obj[:stringComplete] = true
    end

    return obj
  end

  def <=>(obj)
    self.to_s <=> obj.to_s
  end

  def render_inst_vars
    false
  end
end

