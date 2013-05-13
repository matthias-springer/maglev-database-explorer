# GsNMethod may not be modified

class Object
  private

  def __gsnmethod_to_database_view(obj, depth, ranges = {}, params = {})
    obj[:basetype] = :gsnmethod
    obj[:selectorString] = self.__evaluate_smalltalk("self selector").to_database_view(depth - 1, {}, params)

    return obj
  end
end

