class Hash
  def to_database_view(depth, range_from = 1, range_to = 10)
    obj = super

    if (depth > 0)
      index = 1
      obj[:elements] = {}
      obj[:size] = self.size

      self.each_pair do |k, v|
        if (index >= range_from)
          if (index > range_to)
            return obj
          else
            obj[:elements][2 * index] = k.to_database_view(depth - 1)
            obj[:elements][2 * index + 1] = v.to_database_view(depth - 1)
          end
        end

        index = index + 1
      end
    end

    obj[:basetype] = :hash

    return obj
  end
end
