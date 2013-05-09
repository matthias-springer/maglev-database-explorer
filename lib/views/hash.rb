class Hash
  def to_database_view(depth, ranges = {})
    obj = super

    obj[:basetype] = :hash

    if (depth > 0)
      index = 1
      obj[:elements] = {}
      obj[:elementsSize] = self.size

      range_from = ranges[:elements] ? Integer(ranges[:elements][0]) : 1
      range_to = ranges[:elements] ? Integer(ranges[:elements][1]) : 10

      self.each_pair do |k, v|
        if (index >= range_from)
          if (index > range_to)
            break
          else
            obj[:elements][index] = [k.to_database_view(depth - 1), v.to_database_view(depth - 1)]
          end
        end

        index = index + 1
      end
    end

    return obj
  end
end
