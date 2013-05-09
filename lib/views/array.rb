class Array
  def to_database_view(depth, ranges = {})
    obj = super

    if (depth > 0)
      obj[:elements] = {}
      obj[:elementsSize] = self.size

      range_from = ranges[:elements] ? Integer(ranges[:elements][0]) : 1
      range_to = ranges[:elements] ? Integer(ranges[:elements][1]) : 10

      ((range_from - 1)..[range_to - 1, self.size - 1].min).each do |index|
        obj[:elements][index + 1] = self[index].to_database_view(depth - 1)
      end
    end

    obj[:basetype] = :array

    return obj
  end
end
