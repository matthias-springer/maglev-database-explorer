class Module
  def __basetype
    :module
  end

  def to_database_view(depth, ranges = {}, params = {})
    obj = super
    
    if depth > 0 and not params[:noBehavior]
      obj[:smalltalkFullName] = __fullName.to_database_view(depth - 1, {}, params)
      obj[:rubyFullName] = __rubyFullName.to_database_view(depth - 1, {}, params)

      obj[:includedModules] = {}
      obj[:includedModulesSize] = self.included_modules.size

      range_from = ranges[:includedModules] ? Integer(ranges[:includedModules][0]) : 1
      range_to = ranges[:includedModules] ? Integer(ranges[:includedModules][1]) : 0

      ((range_from - 1)..[range_to - 1, self.included_modules.size - 1].min).each do |index|
        obj[:includedModules][index + 1] = self.included_modules[index].to_database_view(depth - 1, {}, params)
      end

      obj[:constants] = {}
      obj[:constantsSize] = self.constants.size

      range_from = ranges[:constants] ? Integer(ranges[:constants][0]) : 1
      range_to = ranges[:constants] ? Integer(ranges[:constants][1]) : 0

     ((range_from - 1)..[range_to - 1, self.constants.size - 1].min).each do |index|
        begin
          obj[:constants][index + 1] = [self.constants[index].to_database_view(depth - 1, {}, params), self.const_get(self.constants[index]).to_database_view(depth - 1, {}, params)]
        rescue Exception => e
          obj[:constants][index + 1] = {:loaded => false, :error => true, :basetype => :string, :inspection => "(error)", :oop => -1}
        end
      end

      if params[:superList]
        obj[:superList] = __super_list.to_database_view(2, {}, {:allElements => true, :noBehavior => true})
      end
    end

    return obj
  end

  primitive '__compile_smalltalk_method', 'compileMethod:category:'
  primitive '__fullName', 'fullName'
  primitive '__rubyFullName', 'rubyFullName'

  primitive '__category_names', 'categoryNames'
  primitive '__smalltalk_selectors_in', 'selectorsIn:'
  primitive '__ruby_nonbridge_selectors', 'nonBridgeRubySelectorsInto:hiddenInto:protection:env:'
  
  primitive '__lookup_smalltalk_selector', 'lookupSelector:'
  primitive '__lookup_ruby_selector', 'rubyMethodFor:instanceMethod:'
 
  primitive '__compile', 'compile:'
  
  primitive '__all_super_list', '_allSuperList:env:'
   
  def __ruby_selectors
    ruby_selectors = IdentitySet.new
    hidden_set = IdentitySet.new

    __ruby_nonbridge_selectors(ruby_selectors, hidden_set, -1, 1)
    ruby_selectors.to_a
  end

  def __source_for_selector(selector, language)
    method = nil

    if language == :smalltalk
      method = __lookup_smalltalk_selector(selector)
    else
      method = __lookup_ruby_selector(selector, true)
    end
    
    GsNMethodProxy.for(method).__for_database_explorer
  end

  def __selectors_by_category
    categories = {}
    all_smalltalk = []

    __category_names.each do |cat|
      st_selectors = __smalltalk_selectors_in(cat).sort
      categories[cat] = st_selectors
      all_smalltalk += st_selectors
    end

    categories["(all Smalltalk)"] = all_smalltalk.sort
    categories["(all Ruby)"] = __ruby_selectors.sort
    
    categories
  end

  private

  def __super_list
    arr = __all_super_list(false, 1)
    arr.push(self)
    arr
  end
end

