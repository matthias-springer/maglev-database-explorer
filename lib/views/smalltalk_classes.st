"This script prepares Smalltalk classes and adds additional methods.
Use object.rb for classes that may not be changed due to object
security policy."

|methods|

methods := Dictionary new.

"Dictionary (different from RubyHash)"
"methods at: Dictionary put: 'asDatabaseView: depth ranges: ranges params: params
  |view|
  view := super @ruby1:to_database_view: depth _: ranges _: params
  view at: #basetype put: #dictionary.'.

methods keysAndValuesDo: [:behavior :method |
  behavior compileMethod: method category: '*maglev-database-explorer' environmentId: 0.
  behavior @ruby1:primitive: 'to_database_view' _: 'asDatabaseView:ranges:params:']."


