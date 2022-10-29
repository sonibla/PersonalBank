Class {
	#name : #AccounterTest,
	#superclass : #AbstractAccountingTest,
	#category : #'PersonalBank-Tests-Core'
}

{ #category : #tests }
AccounterTest >> testAddOperation [

	| newOperation |
	newOperation := IncomeOperation
		                on: (Date newDay: 03 month: 01 year: 2000)
		                change: 'Source2' -> 13 -> 'Destination2'
		                bank: 'Bank2'.

	self
		assert: self dummyAccounter operations asArray
		equals: self dummyOperations.

	self dummyAccounter addOperation:
		self dummyAccounter operations anyOne.
	self
		assert: self dummyAccounter operations asArray
		equals: self dummyOperations.

	self dummyAccounter addOperation: newOperation.
	self
		assert: self dummyAccounter operations asArray
		equals: (self dummyOperations copyWith: newOperation).

	self dummyAccounter addOperation: newOperation.
	self
		assert: self dummyAccounter operations asArray
		equals: (self dummyOperations copyWith: newOperation).

	self dummyAccounter addOperation: newOperation copy.
	self
		assert: self dummyAccounter operations asArray
		equals:
		((self dummyOperations copyWith: newOperation) copyWith:
			 newOperation)
]

{ #category : #tests }
AccounterTest >> testAddOperations [

	| newOperations |
	newOperations := { 
		                 (IncomeOperation
			                  on: (Date newDay: 03 month: 01 year: 2000)
			                  change: 'Source2' -> 13 -> 'Destination2'
			                  bank: 'Bank2').
		                 (IncomeOperation
			                  on: (Date newDay: 03 month: 01 year: 2000)
			                  change: 'Source2' -> 13 -> 'Destination2'
			                  bank: 'Bank3').
		                 (IncomeOperation
			                  on: (Date newDay: 03 month: 01 year: 2000)
			                  change: 'Source2' -> 13 -> 'Destination2'
			                  bank: 'Bank4') }.

	self
		assert: self dummyAccounter operations asArray
		equals: self dummyOperations.

	self dummyAccounter addOperations: newOperations.
	self
		assert: self dummyAccounter operations asArray
		equals: self dummyOperations copy , newOperations
]

{ #category : #tests }
AccounterTest >> testEquals [

	self
		assert: self dummyAccounter
		equals: (Accounter onOperations: self dummyOperations).
	self
		assert: self dummyAccounter hash
		equals: (Accounter onOperations: self dummyOperations) hash.

	self deny: self dummyAccounter equals: (Accounter onOperations:
			 (self dummyOperations copyWith: (self dummyIncomeOf: 2)))
]

{ #category : #tests }
AccounterTest >> testIncludesOperation [

	self deny:
		(self dummyAccounter includesOperation: (self dummyIncomeOf: 2)).

	self dummyAccounter operations
		collect: [ :each | each copy ]
		thenDo: [ :each | 
		self deny: (self dummyAccounter includesOperation: each) ].

	self dummyAccounter operations do: [ :each | 
		self assert: (self dummyAccounter includesOperation: each) ]
]

{ #category : #tests }
AccounterTest >> testPullDownOperationsSeveral [

	| original |
	original := self dummyAccounter operations copy.
	self dummyAccounter pullDownOperations:
		(self dummyAccounter operations copyFrom: 4 to: 7).
	self
		assert: self dummyAccounter operations
		equals: (original first: 3) , { (original at: 8) }
			, (original copyFrom: 4 to: 7) , (original last: 2)
]

{ #category : #tests }
AccounterTest >> testPullDownOperationsSingleOne [

	| original |
	original := self dummyAccounter operations copy.
	self dummyAccounter pullDownOperations:
		{ (self dummyAccounter operations at: 4) }.
	self
		assert: self dummyAccounter operations
		equals: (original swap: 4 with: 5)
]

{ #category : #tests }
AccounterTest >> testPullDownOperationsUnchanged [

	| original |
	original := self dummyAccounter operations copy.
	self dummyAccounter operations copy do: [ :each | 
		self dummyAccounter pullDownOperations: { each copy }.
		self assert: self dummyAccounter operations equals: original ].

	self dummyAccounter pullDownOperations:
		{ self dummyAccounter operations last }.
	self assert: self dummyAccounter operations equals: original
]

{ #category : #tests }
AccounterTest >> testPushUpOperationsSeveral [

	| original |
	original := self dummyAccounter operations copy.
	self dummyAccounter pushUpOperations:
		(self dummyAccounter operations copyFrom: 4 to: 7).
	self
		assert: self dummyAccounter operations
		equals: (original first: 2) , (original copyFrom: 4 to: 7)
			, { (original at: 3) } , (original last: 3)
]

{ #category : #tests }
AccounterTest >> testPushUpOperationsSingleOne [

	| original |
	original := self dummyAccounter operations copy.
	self dummyAccounter pushUpOperations:
		{ (self dummyAccounter operations at: 4) }.
	self
		assert: self dummyAccounter operations
		equals: (original swap: 4 with: 3)
]

{ #category : #tests }
AccounterTest >> testPushUpOperationsUnchanged [

	| original |
	original := self dummyAccounter operations copy.
	self dummyAccounter operations copy do: [ :each | 
		self dummyAccounter pushUpOperations: { each copy }.
		self assert: self dummyAccounter operations equals: original ].

	self dummyAccounter pushUpOperations:
		{ self dummyAccounter operations first }.
	self assert: self dummyAccounter operations equals: original
]

{ #category : #tests }
AccounterTest >> testRemoveOperations [

	self
		assert: self dummyAccounter operations asArray
		equals: self dummyOperations.

	self dummyAccounter removeOperations: self dummyOperations.
	self
		assert: self dummyAccounter operations asArray
		equals: self dummyOperations.

	self dummyAccounter removeOperations:
		(self dummyAccounter operations collect: [ :each | each copy ]).
	self
		assert: self dummyAccounter operations asArray
		equals: self dummyOperations.

	self dummyAccounter removeOperations:
		{ (self dummyAccounter operations at: 4) }.
	self
		assert: self dummyAccounter operations asArray
		equals: (self dummyOperations copyWithoutIndex: 4).

	self dummyAccounter removeOperations: self dummyAccounter operations.
	self assert: self dummyAccounter operations isEmpty
]
