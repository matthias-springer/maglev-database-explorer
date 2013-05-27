class Array
  def __basetype
    :array
  end

  def to_database_view(depth, ranges = {}, params = {})
    obj = super

    if depth > 0
      obj[:elements] = {}
      obj[:elementsSize] = self.size

      range_from = ranges[:elements] ? Integer(ranges[:elements][0]) : 1
      range_to = ranges[:elements] ? Integer(ranges[:elements][1]) : 10

      if (params[:allElements])
        range_from = 1
        range_to = self.size
      end
      
      ((range_from - 1)..[range_to - 1, self.size - 1].min).each do |index|
        obj[:elements][index + 1] = self[index].to_database_view(depth - 1, {}, params)
      end
    end

    return obj
  end
end
