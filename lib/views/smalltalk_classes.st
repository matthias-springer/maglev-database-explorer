"This script prepares Smalltalk classes and adds additional methods.
Use object.rb for classes that may not be changed due to object
security policy."

|methods clsDbeHalt|

methods := Dictionary new.

clsDbeHalt := AbstractException subclass: 'DBEHalt'
  instVarNames: #(wrappedException)
  classVars: #()
  classInstVars: #()
  poolDictionaries: #()
  inDictionary: 'Globals'
  category: 'User Classes'
  options: #().

clsDbeHalt compile: 'wrappedException: anException
  wrappedException := anException.'.

clsDbeHalt compile: 'wrappedException
  ^ wrappedException'.

clsDbeHalt compile: 'initialize
  gsResumable := true.'.

clsDbeHalt class compile: 'signalFor: anException
  ^ self new
    wrappedException: anException;
    signal.'.

AbstractException compile: 'signalNotTrappable
  "Signal trappable exception for database explorer."
  gsTrappable := false.
  DBEHalt signalFor: self.'.

RubyProc compile: 'callAndRescue: rescueBlock
  "Evaluate block for database explorer. Catches all kinds
  of exceptions."
  ^ [rescueBlock value: {false. block value}]
    on: AbstractException
    do: [:exc | |cc|
      rescueBlock value: {true. exc}].'.

"This won't work for meta classes but it allows us to define
the primitive on Class (Ruby)."
Metaclass3 compile: 'subclasses
  ^ ClassOrganizer cachedOrganizer subclassesOf: self'.

"Dictionary (different from RubyHash)"
"methods at: Dictionary put: 'asDatabaseView: depth ranges: ranges params: params
  |view|
  view := super @ruby1:to_database_view: depth _: ranges _: params
  view at: #basetype put: #dictionary.'.

methods keysAndValuesDo: [:behavior :method |
  behavior compileMethod: method category: '*maglev-database-explorer' environmentId: 0.
  behavior @ruby1:primitive: 'to_database_view' _: 'asDatabaseView:ranges:params:']."


