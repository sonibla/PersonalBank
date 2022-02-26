Class {
	#name : #Accounter,
	#superclass : #Model,
	#instVars : [
		'operations',
		'bankCapitalDiagram',
		'budgetCapitalDiagram',
		'processor'
	],
	#category : #'PersonalBank-Core'
}

{ #category : #'instance creation' }
Accounter class >> onOperations: aCollection [

	^ self new setOperations: aCollection
]

{ #category : #comparing }
Accounter >> = anAccounter [

	^ anAccounter class = self class and: [ 
		  anAccounter operations = self operations ]
]

{ #category : #actions }
Accounter >> addOperation: anOperation [

	(self includesOperation: anOperation) ifFalse: [ 
		anOperation addDependent: self.
		operations add: anOperation ].
	self changed: #operations
]

{ #category : #testing }
Accounter >> bankAndBudgetsEqualCapitals [

	^ self processor bankAndBudgetsEqualCapitals
]

{ #category : #accessing }
Accounter >> bankCapitalDiagram [

	^ bankCapitalDiagram ifNil: [ self defaultCanvasForError: false ]
]

{ #category : #accessing }
Accounter >> bankCapitalDiagram: anObject [

	bankCapitalDiagram := anObject.
	self changed: #bankCapitalDiagram
]

{ #category : #accessing }
Accounter >> budgetCapitalDiagram [

	^ budgetCapitalDiagram ifNil: [ self defaultCanvasForError: false ]
]

{ #category : #accessing }
Accounter >> budgetCapitalDiagram: anObject [

	budgetCapitalDiagram := anObject.
	self changed: #budgetCapitalDiagram
]

{ #category : #accessing }
Accounter >> defaultCanvasForError: error [

	| canvas |
	canvas := RSCanvas new
		          color: self theme backgroundColor;
		          yourself.
	error ifTrue: [ 
		canvas add: ((RSLabel text: 'Error while generating diagram')
				 color: self theme dangerTextColor;
				 yourself) ].
	^ canvas
]

{ #category : #testing }
Accounter >> duplicatedNames [

	^ self processor duplicatedNames
]

{ #category : #accessing }
Accounter >> errorWhileProcessing [

	^ self processor errorWhileProcessing
]

{ #category : #utilities }
Accounter >> generateBankCapitalDiagram [

	^ [ self processor generateBankCapitalDiagram ]
		  on: Error
		  do: [ self defaultCanvasForError: true ]
]

{ #category : #utilities }
Accounter >> generateBudgetCapitalDiagram [

	^ [ self processor generateBudgetCapitalDiagram ]
		  on: Error
		  do: [ self defaultCanvasForError: true ]
]

{ #category : #comparing }
Accounter >> hash [

	^ self operations hash
]

{ #category : #testing }
Accounter >> includesOperation: anOperation [

	^ operations identityIncludes: anOperation
]

{ #category : #initialization }
Accounter >> initialize [

	self setOperations: OrderedCollection new.
	self setProcessor: (AccounterProcessor onAccounter: self)
]

{ #category : #testing }
Accounter >> negativeCapitals [

	^ self processor negativeCapitals
]

{ #category : #accessing }
Accounter >> operations [

	^ operations copy
]

{ #category : #accessing }
Accounter >> operationsDated: aDate [

	^ self operationsGroupedByDate at: aDate ifAbsent: [ #(  ) ]
]

{ #category : #accessing }
Accounter >> operationsGroupedByDate [

	^ self operations groupedBy: [ :each | each date ]
]

{ #category : #testing }
Accounter >> partialSplits [

	^ self processor partialSplits
]

{ #category : #accessing }
Accounter >> processor [

	^ processor
]

{ #category : #actions }
Accounter >> pullDownOperation: anOperation notifying: shouldNotify [

	| index |
	index := operations identityIndexOf: anOperation.
	(index < 1 or: [ index >= operations size ]) ifTrue: [ ^ self ].
	operations swap: index with: index + 1.
	shouldNotify ifTrue: [ self changed: #operations ]
]

{ #category : #actions }
Accounter >> pullDownOperations: aCollection [

	(aCollection sorted: [ :a :b | 
		 (operations identityIndexOf: a) >= (operations identityIndexOf: b) ]) 
		do: [ :each | self pullDownOperation: each notifying: false ].
	self changed: #operations
]

{ #category : #actions }
Accounter >> pushUpOperation: anOperation notifying: shouldNotify [

	| index |
	index := operations identityIndexOf: anOperation.
	index <= 1 ifTrue: [ ^ self ].
	operations swap: index with: index - 1.
	shouldNotify ifTrue: [ self changed: #operations ]
]

{ #category : #actions }
Accounter >> pushUpOperations: aCollection [

	(aCollection sorted: [ :a :b | 
		 (operations identityIndexOf: a) <= (operations identityIndexOf: b) ]) 
		do: [ :each | self pushUpOperation: each notifying: false ].
	self changed: #operations
]

{ #category : #actions }
Accounter >> removeOperations: aCollection [

	operations removeAllSuchThat: [ :each | 
		(aCollection identityIncludes: each)
			ifTrue: [ 
				each removeDependent: self.
				true ]
			ifFalse: [ false ] ].
	self changed: #operations
]

{ #category : #testing }
Accounter >> sanityIssues [

	^ self bankAndBudgetsEqualCapitals not or: [ 
		  self negativeCapitals or: [ 
			  self partialSplits or: [ self duplicatedNames ] ] ]
]

{ #category : #initialization }
Accounter >> setOperations: aCollection [

	operations isEmptyOrNil ifFalse: [ 
		operations do: [ :each | each removeDependent: self ] ].
	operations := aCollection asOrderedCollection.
	operations do: [ :each | each addDependent: self ].
	self changed: #operations
]

{ #category : #initialization }
Accounter >> setProcessor: anAccounterProcessor [

	anAccounterProcessor == processor ifTrue: [ ^ self ].
	processor ifNotNil: [ processor removeDependent: self ].
	processor := anAccounterProcessor.
	processor addDependent: self.
	processor setAccounter: self.
]

{ #category : #updating }
Accounter >> update: aSymbol [

	aSymbol = #processingFinished ifTrue: [ 
		self bankCapitalDiagram: self generateBankCapitalDiagram.
		self budgetCapitalDiagram: self generateBudgetCapitalDiagram.
		self changed: #statistics ].

	(#( #type #source #destination #date #bank #amount ) includes:
		 aSymbol) ifTrue: [ self changed: #operations ]
]
