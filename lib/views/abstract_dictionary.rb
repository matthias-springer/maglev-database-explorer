AbstractDictionary = __resolve_smalltalk_global(:AbstractDictionary)

class AbstractDictionary
  primitive 'size', 'size'
  primitive '__each_key_and_value&', 'keysAndValuesDo:'

  def __basetype
    :dictionary
  end

  def to_database_view(depth, ranges = {}, params = {})
    obj = super

    if depth > 0
      index = 1

      obj[:elements] = {}
      obj[:elementsSize] = self.size

      range_from = ranges[:elements] ? Integer(ranges[:elements][0]) : 1
      range_to = ranges[:elements] ? Integer(ranges[:elements][1]) : 10

      if (params[:allElements])
        range_from = 1
        range_to = self.size
      end

      self.__each_key_and_value do |k, v|
        if (index >= range_from)
          if (index > range_to)
            break
          else
            obj[:elements][index] = [k.to_database_view(depth - 1, {}, params), v.to_database_view(depth - 1, {}, params)]
          end
        end

        index = index + 1
      end
    end

    return obj
  end

end

# Redefine primitives to simulate late binding
Dictionary = __resolve_smalltalk_global(:Dictionary)
class Dictionary
  primitive 'size', 'size'
  primitive '__each_key_and_value&', 'keysAndValuesDo:'
end

IdentityKeyValueDictionary = __resolve_smalltalk_global(:IdentityKeyValueDictionary)
class IdentityKeyValueDictionary
  primitive 'size', 'size'
  primitive '__each_key_and_value&', 'keysAndValuesDo:'
end

class Hash
  primitive 'size', 'size'
  primitive '__each_key_and_value&', 'keysAndValuesDo:'
end

StringKeyValueDictionary = __resolve_smalltalk_global(:StringKeyValueDictionary)
class StringKeyValueDictionary
  primitive 'size', 'size'
  primitive '__each_key_and_value&', 'keysAndValuesDo:'
end

