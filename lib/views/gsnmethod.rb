# GsNMethod may not be modified

class Object
  private

  def __gsnmethod_to_database_view(obj, depth, ranges = {}, params = {})
    obj[:basetype] = :gsnmethod
    obj[:selectorString] = self.__evaluate_smalltalk("self selector").to_database_view(depth - 1, {}, params)

    if depth > 0
      obj[:argsAndTemps] = self.__evaluate_smalltalk("self argsAndTemps").to_database_view(depth, {}, params)
    end

    return obj
  end
end

