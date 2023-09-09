Class {
	#name : #IncomeCollection,
	#superclass : #MoneyStorage,
	#instVars : [
		'incomes'
	],
	#category : #'PersonalBank-Core'
}

{ #category : #adding }
IncomeCollection >> addIncome: aNumber on: aDate [

	^ (self incomeClass canUseAsAmount: aNumber)
		  ifTrue: [ self basicAddIncome: aNumber on: aDate ]
		  ifFalse: [ 0 ]
]

{ #category : #adding }
IncomeCollection >> addOutcome: aNumber on: aDate [

	^ (self incomeClass canUseAsAmount: aNumber)
		  ifTrue: [ (self addIncome: aNumber negated on: aDate) negated ]
		  ifFalse: [ 0 ]
]

{ #category : #accessing }
IncomeCollection >> allIncomes [

	^ incomes
]

{ #category : #adding }
IncomeCollection >> basicAddIncome: aNumber on: aDate [

	| newIncome |
	newIncome := self incomeClass of: aNumber on: aDate.
	incomes add: newIncome.
	^ newIncome amount
]

{ #category : #accessing }
IncomeCollection >> incomeClass [

	^ Income
]

{ #category : #accessing }
IncomeCollection >> incomesEffectiveOn: aDate [

	^ Array new: incomes size streamContents: [ :stream | 
		  | index |
		  index := 1.
		  [ 
		  index <= incomes size and: [ 
			  (incomes at: index) isEffectiveOn: aDate ] ] whileTrue: [ 
			  stream nextPut: (incomes at: index).
			  index := index + 1 ] ]
]

{ #category : #accessing }
IncomeCollection >> incomesList [

	^ incomes
]

{ #category : #initialization }
IncomeCollection >> initialize [

	incomes := SortedCollection sortBlock: [ :a :b | 
		           a date = b date
			           ifTrue: [ a amount < b amount ]
			           ifFalse: [ a date < b date ] ]
]

{ #category : #testing }
IncomeCollection >> isEmpty [

	^ incomes isEmpty
]

{ #category : #accessing }
IncomeCollection >> totalValuation [

	^ self allIncomes sum: [ :eachIncome | eachIncome amount ]
]

{ #category : #accessing }
IncomeCollection >> valuationOn: aDate [

	^ (self incomesEffectiveOn: aDate) sum: [ :eachIncome | 
		  eachIncome amount ]
]
