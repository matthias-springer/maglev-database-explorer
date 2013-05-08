class Module
  def to_database_view(depth, range_from = 1, range_to = 10)
    obj = super

    if (depth > 0)
      obj[:includedModules] = []
      obj[:constants] = {}
      obj[:size] = self.constants.size
      
      self.included_modules.each do |mod|
        obj[:includedModules].push(mod.to_database_view(depth - 1))
      end

      self.constants[range_from - 1, range_to - range_from + 1].each do |const|
        begin
          obj[:constants][const] = self.const_get(const).to_database_view(depth - 1)
        rescue Exception => e
          obj[:constants][const] = {:loaded => false, :error => true}
        end
      end
    end

    obj[:basetype] = :module

    return obj
  end
end

