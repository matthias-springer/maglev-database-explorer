class Module
  def to_database_view(depth, range_from = 1, range_to = 10)
    obj = super

    if (depth > 0)
      obj[:includedModules] = []
      obj[:basetype] = :module

      self.included_modules.each do |mod|
        obj[:includedModules].push(mod.to_database_view(depth - 1))
      end
    end

    return obj
  end
end

