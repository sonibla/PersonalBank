Class {
	#name : #OperationEditorPresenterTest,
	#superclass : #AbstractAccountingTest,
	#instVars : [
		'operationList',
		'presenter',
		'window'
	],
	#category : #'PersonalBank-Tests-GUI'
}

{ #category : #utilities }
OperationEditorPresenterTest >> assertOperationEditorHasValuesOf: anOperation [

	self assert: presenter type selectedItem equals: anOperation type.
	self assert: presenter date text equals: anOperation date ddmmyyyy.
	self assert: presenter source text equals: anOperation source.
	self assert: presenter amount number equals: anOperation amount.
	self
		assert: presenter destination text
		equals: anOperation destination
]

{ #category : #utilities }
OperationEditorPresenterTest >> fillAccounterWithOperations [

	self accounter setOperations: self dummyOperations
]

{ #category : #running }
OperationEditorPresenterTest >> setUp [

	super setUp.
	presenter := OperationEditorPresenter new setAccounter:
		             self accounter.
	window := presenter open
]

{ #category : #running }
OperationEditorPresenterTest >> tearDown [

	window close.
	super tearDown
]

{ #category : #tests }
OperationEditorPresenterTest >> testAddOperations [

	self assert: presenter operationList isEmpty.
	presenter type selectItem: IncomeOperation.
	presenter date text: '02/08/2001'.
	presenter source text: 'SOURCE'.
	presenter amount number: 42.
	presenter destination text: 'DESTINATION'.
	presenter type selectItem: OutcomeOperation.
	self assert: presenter operationList isEmpty.
	presenter bank text: 'BANK'.
	presenter type selectItem: IncomeOperation.
	self assert: presenter operationList size equals: 1.
	self assert: presenter operationsTable items size equals: 1.
	self assert: presenter operationList first equals: (IncomeOperation
			 on: (Date newDay: 2 month: 8 year: 2001)
			 from: 'SOURCE'
			 to: 'DESTINATION'
			 of: 42
			 bank: 'BANK').
	presenter unselectAll.
	presenter date text: '02/08/2001'.
	presenter source text: 'SOURCE'.
	presenter amount number: 42.
	presenter destination text: 'DESTINATION'.
	presenter type selectItem: BudgetTransferOperation.
	self assert: presenter operationList size equals: 2.
	self assert: presenter operationsTable items size equals: 2.
	self
		assert: presenter operationsTable items
		equals: presenter operationList.
	self assert: presenter operationList first equals: (IncomeOperation
			 on: (Date newDay: 2 month: 8 year: 2001)
			 from: 'SOURCE'
			 to: 'DESTINATION'
			 of: 42
			 bank: 'BANK')
]

{ #category : #tests }
OperationEditorPresenterTest >> testEditOperationAfterAccounterReset [

	self fillAccounterWithOperations.
	presenter setAccounter: Accounter new.
	self assertOperationEditorHasValuesOf: Operation dummy
]

{ #category : #tests }
OperationEditorPresenterTest >> testEditOperations [

	self fillAccounterWithOperations.

	self dummyOperations do: [ :each | 
		presenter unselectAll.
		presenter operationsTable selectItem: each.
		self assertOperationEditorHasValuesOf: each ].

	self
		assert: self accounter operations asArray
		equals: self dummyOperations.
	presenter unselectAll.
	presenter operationsTable selectItem: self dummyOperations last.
	presenter amount number: 52.
	presenter type selectItem: IncomeOperation.
	self assertOperationEditorHasValuesOf: (self dummyOperations last
			 amount: 52;
			 type: IncomeOperation).

	self
		assert: self accounter operations asArray
		equals:
			(self dummyOperations allButLast copyWith:
				 (self dummyOperations last
					  amount: 52;
					  type: IncomeOperation)).

	self dummyOperations allButLast do: [ :each | 
		presenter unselectAll.
		presenter operationsTable selectItem: each.
		self assertOperationEditorHasValuesOf: each ]
]

{ #category : #tests }
OperationEditorPresenterTest >> testOperationsEditorOnMultipleSelection [

	self fillAccounterWithOperations.

	presenter unselectAll.
	presenter operationsTable selectItem: (self dummyOperations at: 2).
	presenter operationsTable selectItem: (self dummyOperations at: 4).
	presenter operationsTable selectItem: self dummyOperations anyOne.
	self assertOperationEditorHasValuesOf: Operation dummy
]

{ #category : #tests }
OperationEditorPresenterTest >> testOperationsEditorOnNoSelection [

	self fillAccounterWithOperations.

	presenter unselectAll.
	self assertOperationEditorHasValuesOf: Operation dummy.
	presenter operationsTable selectItem: self dummyOperations anyOne.
	presenter unselectAll.
	self assertOperationEditorHasValuesOf: Operation dummy
]

{ #category : #tests }
OperationEditorPresenterTest >> testOperationsEditorOnSingleSelection [

	self fillAccounterWithOperations.


	self dummyOperations do: [ :each | 
		presenter unselectAll.
		presenter operationsTable selectItem: each.
		self assertOperationEditorHasValuesOf: each ]
]

{ #category : #tests }
OperationEditorPresenterTest >> testSorting [

	self fillAccounterWithOperations.

	presenter unselectAll.
	presenter operationsTable selectIndex: 1.
	self
		assert: presenter operationsTable selectedItem
		equals: (self dummyOperations at: 1).

	presenter unselectAll.
	presenter operationsTable selectIndex: 2.
	self
		assert: presenter operationsTable selectedItem
		equals: (self dummyOperations at: 2).

	presenter unselectAll.
	presenter operationsTable selectIndex: 3.
	self
		assert: presenter operationsTable selectedItem
		equals: (self dummyOperations at: 3).

	presenter unselectAll.
	presenter operationsTable selectIndex: 4.
	self
		assert: presenter operationsTable selectedItem
		equals: (self dummyOperations at: 4).

	presenter unselectAll.
	presenter operationsTable selectIndex: 5.
	self
		assert: presenter operationsTable selectedItem
		equals: (self dummyOperations at: 6).

	presenter unselectAll.
	presenter operationsTable selectIndex: 6.
	self
		assert: presenter operationsTable selectedItem
		equals: (self dummyOperations at: 5).

	presenter unselectAll.
	presenter operationsTable selectIndex: 7.
	self
		assert: presenter operationsTable selectedItem
		equals: (self dummyOperations at: 7).

	presenter unselectAll.
	presenter operationsTable selectIndex: 8.
	self
		assert: presenter operationsTable selectedItem
		equals: (self dummyOperations at: 8).

	presenter unselectAll.
	presenter operationsTable selectIndex: 9.
	self
		assert: presenter operationsTable selectedItem
		equals: (self dummyOperations at: 9)
]

{ #category : #tests }
OperationEditorPresenterTest >> testStaysSortedAfterEdit [

	self fillAccounterWithOperations.

	presenter unselectAll.
	presenter operationsTable selectIndex: 3.
	self
		assert: presenter operationsTable selectedItem
		equals: (self dummyOperations at: 3).
	presenter date text: '19/01/2021'.
	presenter type selectItem: OutcomeOperation.

	presenter unselectAll.
	presenter operationsTable selectIndex: 3.
	self
		deny: presenter operationsTable selectedItem
		equals: ((self dummyOperations at: 3) date:
				 (Date newDay: 19 month: 1 year: 2021)).

	presenter unselectAll.
	presenter operationsTable selectIndex: 9.
	self
		assert: presenter operationsTable selectedItem
		equals: ((self dummyOperations at: 3) date:
				 (Date newDay: 19 month: 1 year: 2021))
]
