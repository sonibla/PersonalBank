Class {
	#name : #AccounterProcessor,
	#superclass : #Model,
	#instVars : [
		'banks',
		'budgets',
		'accounter',
		'errorWhileProcessing'
	],
	#category : #'PersonalBank-Core'
}

{ #category : #'instance creation' }
AccounterProcessor class >> onAccounter: anAccounter [

	^ self new setAccounter: anAccounter
]

{ #category : #utilities }
AccounterProcessor class >> operationsSafelySorted: aCollection [

	| incomes outcomes bankTransfers budgetTransfers |
	incomes := aCollection select: [ :each | each type mayIncreaseTotalCapital ].
	outcomes := aCollection select: [ :each | each type mayDecreaseTotalCapital ].
	bankTransfers := aCollection select: [ :each | each type isTransferBetweenBanks ].
	budgetTransfers := aCollection select: [ :each | each type isTransferBetweenBudgets ].
	^ incomes , (self
		   sortedOperations: bankTransfers
		   withInitialSources: (incomes collect: [ :each | each bank ])) , (self
		   sortedOperations: budgetTransfers
		   withInitialSources: (incomes collect: [ :each | each destination ]))
	  , outcomes
]

{ #category : #utilities }
AccounterProcessor class >> sortedOperations: operationsToSort withInitialSources: prioritySources [

	| safe unsafe |
	safe := operationsToSort select: [ :each | 
		        prioritySources includes: each source ].
	unsafe := operationsToSort reject: [ :each | 
		          prioritySources includes: each source ].
	^ safe ifEmpty: [ operationsToSort ] ifNotEmpty: [ 
		  safe , (self
			   sortedOperations: unsafe
			   withInitialSources: (safe collect: [ :each | each destination ])) ]
]

{ #category : #utilities }
AccounterProcessor class >> sortedOperationsFromAccounter: anAccounter [

	| groupedByDate |
	groupedByDate := anAccounter operationsGroupedByDate.
	^ groupedByDate keys sorted flatCollect: [ :eachDate | 
		  self operationsSafelySorted:
			  (anAccounter operationsDated: eachDate) ]
]

{ #category : #testing }
AccounterProcessor >> bankAndBudgetsEqualCapitals [

	^ (self banks valuationWithSubcontainersOn: Date today)
	  = (self budgets valuationWithSubcontainersOn: Date today)
]

{ #category : #accessing }
AccounterProcessor >> bankCapitals [

	^ self banks subcontainers
		  collect: [ :each | 
		  each name -> (each roundedValuationOn: Date today) ]
		  as: Set
]

{ #category : #accessing }
AccounterProcessor >> banks [

	^ banks
]

{ #category : #accessing }
AccounterProcessor >> budgets [

	^ budgets
]

{ #category : #accessing }
AccounterProcessor >> budgetsCapitals [

	^ self budgets recursiveSubcontainersWithoutSelf
		  collect: [ :each | 
		  each name -> (each roundedValuationOn: Date today) ]
		  as: Set
]

{ #category : #testing }
AccounterProcessor >> duplicatedNames [

	^ (self duplicatedNamesIn: self banks) or: [ 
		  self duplicatedNamesIn: self budgets ]
]

{ #category : #testing }
AccounterProcessor >> duplicatedNamesIn: aContainer [

	^ (aContainer recursiveSubcontainersWithoutSelf asOrderedCollection
		   collect: [ :each | each name ]
		   as: Bag) asDictionary values anySatisfy: [ :any | any > 1 ]
]

{ #category : #accessing }
AccounterProcessor >> errorWhileProcessing [

	^ errorWhileProcessing
]

{ #category : #initialization }
AccounterProcessor >> initialize [

	banks := Container new.
	budgets := Container new
]

{ #category : #testing }
AccounterProcessor >> negativeCapitalIn: aContainer [

	^ aContainer recursiveSubcontainers anySatisfy: [ :each | 
		  (each valuationOn: Date today) negative ]
]

{ #category : #testing }
AccounterProcessor >> negativeCapitals [

	^ (self negativeCapitalIn: self banks) or: [ 
		  self negativeCapitalIn: self budgets ]
]

{ #category : #accessing }
AccounterProcessor >> operations [

	^ accounter ifNil: [ #(  ) ] ifNotNil: [ accounter operations ]
]

{ #category : #testing }
AccounterProcessor >> partialSplitIn: aContainer [

	^ aContainer recursiveSubcontainers anySatisfy: [ :each | 
		  each subcontainers notEmpty and: [ 
			  (each valuationOn: Date today) isZero not ] ]
]

{ #category : #testing }
AccounterProcessor >> partialSplits [

	^ (self partialSplitIn: self banks) or: [ 
		  self partialSplitIn: self budgets ]
]

{ #category : #processing }
AccounterProcessor >> processData [

	banks := Container new.
	budgets := Container new.

	self sortedOperations do: [ :eachOperation | 
		eachOperation type = BankTransferOperation ifTrue: [ 
			self registerBankTransfer: eachOperation ].
		eachOperation type = IncomeOperation ifTrue: [ 
			self registerIncome: eachOperation ].
		eachOperation type = OutcomeOperation ifTrue: [ 
			self registerOutcome: eachOperation ].
		eachOperation type = BudgetTransferOperation ifTrue: [ 
			self registerBudgetTransfer: eachOperation ] ]
]

{ #category : #processing }
AccounterProcessor >> processDataErrorSafely [

	errorWhileProcessing := nil.
	[ self processData ]
		on: Error
		do: [ :exception | errorWhileProcessing := exception ].
	self changed: #processingFinished
]

{ #category : #processing }
AccounterProcessor >> registerBankTransfer: anOperation [

	(banks subcontainerNamed: anOperation source)
		send: anOperation amount
		to: (banks subcontainerNamed: anOperation destination)
		on: anOperation date
]

{ #category : #processing }
AccounterProcessor >> registerBudgetTransfer: anOperation [

	| destinationCandidates sourceBudget destionationBudget |
	sourceBudget := budgets recursiveSubcontainerNamed:
		                anOperation source.
	destinationCandidates := budgets recursiveSubcontainersNamed:
		                         anOperation destination.
	destionationBudget := destinationCandidates size = 1
		                      ifTrue: [ destinationCandidates anyOne ]
		                      ifFalse: [ 
		                      sourceBudget subcontainerNamed:
			                      anOperation destination ].
	sourceBudget
		send: anOperation amount
		to: destionationBudget
		on: anOperation date
]

{ #category : #processing }
AccounterProcessor >> registerIncome: anOperation [

	(banks subcontainerNamed: anOperation bank)
		addIncome: anOperation amount
		on: anOperation date.
	(budgets recursiveSubcontainerNamed: anOperation destination)
		addIncome: anOperation amount
		on: anOperation date
]

{ #category : #processing }
AccounterProcessor >> registerOutcome: anOperation [

	| candidates selectedCandidate |
	(banks subcontainerNamed: anOperation bank)
		addOutcome: anOperation amount
		on: anOperation date.
	candidates := budgets recursiveSubcontainersNamed: anOperation source.
	selectedCandidate := candidates size = 1
		                     ifTrue: [ candidates anyOne ]
		                     ifFalse: [ 
			                     self uniqueElementOf:
				                     (candidates reject: [ :each | 
					                      (each valuationOn: anOperation date) isZero ]) ].
	selectedCandidate addOutcome: anOperation amount on: anOperation date
]

{ #category : #initialization }
AccounterProcessor >> setAccounter: anAccounter [

	anAccounter == accounter ifTrue: [ ^ self ].
	accounter ifNotNil: [ accounter removeDependent: self ].
	accounter := anAccounter.
	accounter addDependent: self.
	self update: #operations
]

{ #category : #accessing }
AccounterProcessor >> sortedOperations [

	^ self class sortedOperationsFromAccounter: accounter
]

{ #category : #processing }
AccounterProcessor >> uniqueElementOf: aCollection [

	aCollection size > 1 ifTrue: [ self error: 'Ambiguous' ].
	aCollection isEmpty ifTrue: [ self error: 'Empty' ].
	^ aCollection anyOne
]

{ #category : #updating }
AccounterProcessor >> update: aSymbol [

	aSymbol = #operations ifTrue: [ self processDataErrorSafely ]
]
