class Symbol
  def to_database_view(depth, ranges = {}, params = {})
    obj = super
    obj[:basetype] = :symbol

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
end

