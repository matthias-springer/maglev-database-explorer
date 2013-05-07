class Array
  def to_database_view(depth, range_from = 1, range_to = 10)
    obj = super

    if (depth > 0)
      obj[:elements] = []
      obj[:size] = self.size
      obj[:basetype] = :array

      ((range_from - 1)..[range_to - 1, self.size - 1].min).each do |index|
        obj[:elements].push(self[index].to_database_view(depth - 1))
      end
    end

    return obj
  end
end
