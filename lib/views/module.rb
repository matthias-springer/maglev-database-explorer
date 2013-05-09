class Module
  def to_database_view(depth, ranges = {})
    obj = super
    
    obj[:basetype] = :module

    if (depth > 0)
      obj[:includedModules] = {}
      obj[:includedModulesSize] = self.included_modules.size

      range_from = ranges[:includedModules] ? Integer(ranges[:includedModules][0]) : 1
      range_to = ranges[:includedModules] ? Integer(ranges[:includedModules][1]) : 10

      ((range_from - 1)..[range_to - 1, self.included_modules.size - 1].min).each do |index|
        obj[:includedModules][index + 1] = self.included_modules[index].to_database_view(depth - 1)
      end

      obj[:constants] = {}
      obj[:constantsSize] = self.constants.size

      range_from = ranges[:constants] ? Integer(ranges[:constants][0]) : 1
      range_to = ranges[:constants] ? Integer(ranges[:constants][1]) : 10

     ((range_from - 1)..[range_to - 1, self.constants.size - 1].min).each do |index|
        begin
          obj[:constants][index + 1] = [self.constants[index].to_database_view(depth - 1), self.const_get(self.constants[index]).to_database_view(depth - 1)]
#        rescue Exception => e
#          obj[:constants][index + 1] = {:loaded => false, :error => true, :basetype => :object}
        end
      end 
    end

    return obj
  end
end

