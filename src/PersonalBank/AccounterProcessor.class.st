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

	^ self banks totalIncome = self budgets totalIncome
]

{ #category : #accessing }
AccounterProcessor >> bankCapitals [

	^ self banks subcontainers
		  collect: [ :each | each name -> each rounded ]
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
		  collect: [ :each | each name -> each rounded ]
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

{ #category : #utilities }
AccounterProcessor >> generateBankCapitalDiagram [

	| data pie pieLabel |
	data := self bankCapitals.
	pie := RSPie new
		       objects: data;
		       slice: #value.
	pie sliceShape
		externalRadius: 240;
		innerRadius: 170;
		segmentSpacing: 0.4.
	pie sliceColor: NSScale category20b.
	pieLabel := RSPieLabeledInteraction new.
	pieLabel labelShape fontSize: 13.
	pieLabel labelColor:  self theme textColor.
	pieLabel labelText: [ :obj | obj key ].

	pie build.
	pie canvas when: RSExtentChangedEvent do: [ pie canvas zoomToFit ].
	pie shapes
	@ (RSPopup text: [ :obj | obj key , ' - ' , obj value asString ]).
	pie shapes @ pieLabel.
	^ pie canvas
		  color:  self theme backgroundColor;
		  yourself
]

{ #category : #utilities }
AccounterProcessor >> generateBudgetCapitalDiagram [

	| sankey |
	sankey := RSSankey withAllAssociations:
		          ((budgets recursiveSubcontainersWithoutSelf reject: [ :e | 
			            e roundedTotal isZero ]) flatCollect: [ :each | 
			           each subcontainers
				           reject: [ :e | e roundedTotal isZero ]
				           thenCollect: [ :eachSub | 
				           each name -> eachSub roundedTotal -> eachSub name ] ])
		          , (budgets subcontainers collect: [ :each | 
				           'Total' -> each roundedTotal -> each name ]).
	sankey boxShape @ (RSPopup new
		 model: #yourself;
		 text: [ :box | box model , ' - ' , box value asString ];
		 yourself).
	sankey boxShape
		withBorder;
		borderColor: self theme textColor;
		width: 15.
	sankey labelShape
		color: self theme textColor;
		fontSize: 13.
	sankey boxColor: self theme darkBaseColor.
	sankey lineShape color: (self theme lightBaseColor alpha: 0.5).
	sankey
		extent: 960 @ 500;
		iterations: 32;
		nodePadding: 10.
	sankey build.
	^ sankey canvas
		  color: self theme backgroundColor;
		  yourself
]

{ #category : #utilities }
AccounterProcessor >> generateBudgetTransfersDiagram [

	"To refactor: computation should be ideally in Container i think"

	| sankey budgetsTemp |
	budgetsTemp := Container new.
	self sortedOperations
		select: [ :each | each type = BudgetTransferOperation ]
		thenDo: [ :eachOperation | 
			(budgetsTemp recursiveSubcontainerNamed: eachOperation source)
				send: eachOperation amount
				toSubcontainerNamed: eachOperation destination ].
	sankey := RSSankey withAllAssociations:
		          (budgetsTemp recursiveSubcontainersWithoutSelf 
			           flatCollect: [ :each | 
				           each subcontainers
					           reject: [ :e | e roundedTotal isZero ]
					           thenCollect: [ :eachSub | 
					           each name -> eachSub roundedTotal -> eachSub name ] ]).
	sankey boxShape @ (RSPopup new
		 model: #yourself;
		 text: [ :box | box model , ' - ' , box value asString ];
		 yourself).
	sankey boxShape
		withBorder;
		borderColor: self theme textColor;
		width: 15.
	sankey labelShape
		color: self theme textColor;
		fontSize: 13.
	sankey boxColor: self theme darkBaseColor.
	sankey lineShape color: (self theme lightBaseColor alpha: 0.5).
	sankey
		extent: 960 @ 500;
		iterations: 32;
		nodePadding: 10.
	sankey build.
	^ sankey canvas
		  color: self theme backgroundColor;
		  yourself
]

{ #category : #initialization }
AccounterProcessor >> initialize [

	banks := Container new.
	budgets := Container new
]

{ #category : #testing }
AccounterProcessor >> negativeCapitalIn: aContainer [

	^ aContainer recursiveSubcontainers anySatisfy: [ :each | 
		  each income negative ]
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
		  each subcontainers notEmpty and: [ each income isZero not ] ]
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
]

{ #category : #processing }
AccounterProcessor >> registerBudgetTransfer: anOperation [

	(budgets recursiveSubcontainerNamed: anOperation source)
		send: anOperation amount
		toSubcontainerNamed: anOperation destination
]

{ #category : #processing }
AccounterProcessor >> registerIncome: anOperation [

	(banks subcontainerNamed: anOperation bank) addIncome:
		anOperation amount.
	(budgets recursiveSubcontainerNamed: anOperation destination) 
		addIncome: anOperation amount
]

{ #category : #processing }
AccounterProcessor >> registerOutcome: anOperation [

	(banks subcontainerNamed: anOperation bank) addOutcome:
		anOperation amount.

	(budgets recursiveSubcontainerNamed: anOperation source) addOutcome:
		anOperation amount
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

{ #category : #updating }
AccounterProcessor >> update: aSymbol [

	aSymbol = #operations ifTrue: [ self processDataErrorSafely ]
]
