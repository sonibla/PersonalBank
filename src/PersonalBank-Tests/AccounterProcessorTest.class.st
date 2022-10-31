Class {
	#name : #AccounterProcessorTest,
	#superclass : #AbstractAccountingTest,
	#category : #'PersonalBank-Tests-Core'
}

{ #category : #'tests - processing' }
AccounterProcessorTest >> testBankCapitals [

	self assert: self dummyAccounter processor bankCapitals equals: { 
			('Bank1' -> 1238).
			('Bank2' -> 1620).
			('Bank3' -> 90) } asSet
]

{ #category : #'tests - sanity checks' }
AccounterProcessorTest >> testBudgetTransferOutsideOfSourceSubcontainer [

	self dummyAccounter addOperation: (BudgetTransferOperation
			 on: (Date newDay: 9 month: 1 year: 2000)
			 change: 'Budget1-SubA' -> 13 -> 'Budget1-SubC').

	self
		assert: self dummyAccounter processor budgetsCapitals
		equals: { 
				('Budget1-SubB' -> 548).
				('Budget1-SubC' -> 913).
				('Budget1' -> 0).
				('Budget2' -> 1000).
				('Budget1-SubA' -> 487) } asSet
]

{ #category : #'tests - processing' }
AccounterProcessorTest >> testBudgetsCapitals [

	self
		assert: self dummyAccounter processor budgetsCapitals
		equals: { 
				('Budget1-SubB' -> 548).
				('Budget1-SubC' -> 900).
				('Budget1' -> 0).
				('Budget2' -> 1000).
				('Budget1-SubA' -> 500) } asSet
]

{ #category : #'tests - sanity checks' }
AccounterProcessorTest >> testDuplicatedNamesOkIfBankEqualsBudget [

	self deny: self dummyAccounter processor duplicatedNames.
	self dummyAccounter addOperation: (BankTransferOperation
			 on: (Date newDay: 3 month: 1 year: 2000)
			 change: 'Bank1' -> 420 -> 'Budget1').
	self deny: self dummyAccounter processor duplicatedNames
]

{ #category : #'tests - sanity checks' }
AccounterProcessorTest >> testNoErrorWhileProcessing [

	self assert: self dummyAccounter processor errorWhileProcessing isNil
]

{ #category : #'tests - sanity checks' }
AccounterProcessorTest >> testNoIssueEvenIfWrongOrder [

	self deny: self dummyAccounter processor negativeCapitals.
	self dummyAccounter addOperation: (BankTransferOperation
			 on: (Date newDay: 6 month: 1 year: 2000)
			 change: 'Bank1' -> 10000 -> 'Bank2').
	self assert: self dummyAccounter processor negativeCapitals.
	self dummyAccounter addOperation: (IncomeOperation
			 on: (Date newDay: 6 month: 1 year: 2000)
			 change: 'Lottery' -> 10000 -> 'Income'
			 bank: 'Bank1').
	self deny: self dummyAccounter processor negativeCapitals
]

{ #category : #'tests - sanity checks' }
AccounterProcessorTest >> testSanityIssueDuplicatedNames [

	self deny: self dummyAccounter processor duplicatedNames.
	self dummyAccounter
		addOperation: (BudgetTransferOperation
				 on: (Date newDay: 9 month: 1 year: 2000)
				 change: 'Budget1-SubA' -> 500 -> 'Budget2bis');
		addOperation: (BudgetTransferOperation
				 on: (Date newDay: 9 month: 1 year: 2000)
				 change: 'Budget1' -> 500 -> 'Budget2bis').
	self deny: self dummyAccounter processor duplicatedNames
]

{ #category : #'tests - sanity checks' }
AccounterProcessorTest >> testSanityIssueNegativeCapitalAfterBudgetTransfer [

	| operationToEdit |
	self deny: self dummyAccounter processor negativeCapitals.
	operationToEdit := self dummyAccounter operations detect: [ :each | 
		                   each = (BudgetTransferOperation
			                    on:
			                    (Date newDay: 4 month: 1 year: 2000)
				                    translateToUTC
			                    change: 'Budget1' -> 500 -> 'Budget1-SubA') ].
	operationToEdit amount: 600.
	self assert: self dummyAccounter processor negativeCapitals
]

{ #category : #'tests - sanity checks' }
AccounterProcessorTest >> testSanityIssueNegativeCapitalAfterOutcome [

	| operationToEdit |
	self deny: self dummyAccounter processor negativeCapitals.
	operationToEdit := self dummyAccounter operations detect: [ :each | 
		                   each = (OutcomeOperation
			                    on:
			                    (Date newDay: 2 month: 1 year: 2000)
				                    translateToUTC
			                    change: 'Budget1' -> 200 -> 'Destination1'
			                    bank: 'Bank1') ].
	operationToEdit amount: 300.
	self assert: self dummyAccounter processor negativeCapitals
]

{ #category : #'tests - sanity checks' }
AccounterProcessorTest >> testSanityIssueNegativeCapitalInBank [

	| operationToEdit |
	self deny: self dummyAccounter processor negativeCapitals.
	operationToEdit := self dummyAccounter operations detect: [ :each | 
		                   each = (BankTransferOperation
			                    on:
			                    (Date newDay: 3 month: 1 year: 2000)
				                    translateToUTC
			                    change: 'Bank1' -> 420 -> 'Bank2') ].
	operationToEdit amount: 3000.
	self assert: self dummyAccounter processor negativeCapitals
]

{ #category : #'tests - sanity checks' }
AccounterProcessorTest >> testSanityIssuePartialSplit [

	| operationToEdit |
	self deny: self dummyAccounter processor partialSplits.
	operationToEdit := self dummyAccounter operations detect: [ :each | 
		                   each = (BudgetTransferOperation
			                    on:
			                    (Date newDay: 4 month: 1 year: 2000)
				                    translateToUTC
			                    change: 'Budget1' -> 500 -> 'Budget1-SubA') ].
	operationToEdit amount: 400.
	self assert: self dummyAccounter processor partialSplits
]
