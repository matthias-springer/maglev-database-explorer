class Hash
  def to_database_view(depth, range_from = 1, range_to = 10)
    obj = super

    if (depth > 0)
      index = 1
      obj[:elements] = {}
      obj[:size] = self.size
      obj[:basetype] = :hash

      self.each_pair do |k, v|
        if (index >= range_from)
          if (index > range_to)
            return obj
          else
            obj[:elements][k.to_database_view(depth - 1)] = v.to_database_view(depth - 1)
          end
        end
      end
    end

    return obj
  end
end
