Class {
	#name : #AccounterSynchronizer,
	#superclass : #Model,
	#instVars : [
		'accounter',
		'filename',
		'autosave',
		'unsavedChanges'
	],
	#category : #'PersonalBank-Core'
}

{ #category : #'file in/out' }
AccounterSynchronizer class >> accounterFromArray: anArray [

	^ Accounter onOperations: (anArray collect: [ :each | 
			   Operation new
				   type: (OperationType fromJsonId: (each at: #type));
				   date: (each at: #date);
				   source: (each at: #source);
				   amount: (each at: #amount);
				   destination: (each at: #destination);
				   bank: (each at: #bank);
				   yourself ])
]

{ #category : #'file in/out' }
AccounterSynchronizer class >> arrayFromAccounter: anAccounter [

	^ anAccounter operations
		  collect: [ :each | 
			  Dictionary new
				  at: #type put: each type jsonId;
				  at: #date put: each date;
				  at: #source put: each source;
				  at: #amount put: each amount;
				  at: #destination put: each destination;
				  at: #bank put: each bank;
				  yourself ]
		  as: Array
]

{ #category : #'instance creation' }
AccounterSynchronizer class >> onAccounter: anAccounter [

	^ self new setAccounter: anAccounter
]

{ #category : #'file in/out' }
AccounterSynchronizer class >> readFromFile: aString [

	^ aString asFileReference exists
		  ifTrue: [ self readFromStream: aString asFileReference readStream ]
		  ifFalse: [ Accounter new ]
]

{ #category : #'file in/out' }
AccounterSynchronizer class >> readFromStream: aStream [

	^ self accounterFromArray: (STON fromStream: aStream)
]

{ #category : #'file in/out' }
AccounterSynchronizer class >> write: anAccounter onFile: aString [

	| stream |
	stream := aString asFileReference writeStream.
	self write: anAccounter onStream: stream.
	stream close
]

{ #category : #'file in/out' }
AccounterSynchronizer class >> write: anAccounter onStream: aStream [

	STON put: (self arrayFromAccounter: anAccounter) onStream: aStream
]

{ #category : #accessing }
AccounterSynchronizer >> accounter [

	^ accounter
]

{ #category : #accessing }
AccounterSynchronizer >> autosave [

	^ autosave
]

{ #category : #accessing }
AccounterSynchronizer >> autosave: anObject [

	| unChanged |
	unChanged := anObject = autosave.
	autosave := anObject.
	unChanged ifFalse: [ self changed: #autosave ].
	autosave ifTrue: [ self save ].
]

{ #category : #query }
AccounterSynchronizer >> fileIsCorrectlySync [

	^ self synchronizedWithFile: self filename
]

{ #category : #accessing }
AccounterSynchronizer >> filename [

	^ filename
]

{ #category : #accessing }
AccounterSynchronizer >> filename: anObject [

	| unChanged newFilename |
	newFilename := anObject isString
		               ifFalse: [ 
			               anObject isFile
				               ifTrue: [ anObject fullName ]
				               ifFalse: [ anObject asString ] ]
		               ifTrue: [ anObject ].
	unChanged := filename = newFilename.
	filename := newFilename.
	unChanged ifFalse: [ 
		self changed: #filename.
		self update: #filename ]
]

{ #category : #initialization }
AccounterSynchronizer >> initialize [

	self setAccounter: Accounter new
]

{ #category : #actions }
AccounterSynchronizer >> loadFromFile: aString [

	self setAccounter: (self class readFromFile: aString).
	self filename: aString.
	self unsavedChanges: false
]

{ #category : #actions }
AccounterSynchronizer >> reload [

	self filename ifNotEmpty: [ self loadFromFile: self filename ]
]

{ #category : #actions }
AccounterSynchronizer >> save [

	self filename ifNotEmpty: [ self saveOnFile: self filename ]
]

{ #category : #actions }
AccounterSynchronizer >> saveOnFile: aString [

	self class write: accounter onFile: aString.
	(self synchronizedWithFile: aString) ifTrue: [ 
		self filename: aString.
		self unsavedChanges: false ]
]

{ #category : #initialization }
AccounterSynchronizer >> setAccounter: anAccounter [

	anAccounter == accounter ifTrue: [ ^ self ].
	accounter ifNotNil: [ accounter removeDependent: self ].
	accounter := anAccounter.
	accounter addDependent: self.
	self filename: ''.
	self autosave: false.
	self update: #operations.
	self changed: #accounter.
	self changed: #statistics.
]

{ #category : #query }
AccounterSynchronizer >> shouldAutoSave [

	^ self autosave and: [ 
		  self filename isNotEmpty and: [ 
			  self accounter sanityIssues not and: [ 
				  self accounter errorWhileProcessing isNil ] ] ]
]

{ #category : #query }
AccounterSynchronizer >> synchronizedWithFile: aFile [

	^ (aFile asFileReference exists and: [ aFile asFileReference isFile ])
		  ifTrue: [ 
			  (self class readFromFile: aFile asFileReference) operations
			  = self accounter operations ]
		  ifFalse: [ self accounter = Accounter new ]
]

{ #category : #accessing }
AccounterSynchronizer >> unsavedChanges [

	^ unsavedChanges
]

{ #category : #accessing }
AccounterSynchronizer >> unsavedChanges: anObject [

	| unChanged |
	unChanged := anObject = unsavedChanges.
	unsavedChanges := anObject.
	unChanged ifFalse: [ self changed: #unsavedChanges ]
]

{ #category : #updating }
AccounterSynchronizer >> update: aSymbol [

	aSymbol = #operations ifTrue: [ 
		self unsavedChanges: self fileIsCorrectlySync not ].
	aSymbol = #filename ifTrue: [ 
		self unsavedChanges: self fileIsCorrectlySync not ].
	aSymbol = #statistics ifTrue: [ 
		self shouldAutoSave ifTrue: [ self saveOnFile: self filename ].
		self changed: #statistics ]
]
