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
IncomeCollection >> incomesList [

	^ incomes
]

{ #category : #initialization }
IncomeCollection >> initialize [

	incomes := OrderedCollection new
]

{ #category : #testing }
IncomeCollection >> isEmpty [

	^ incomes isEmpty
]

{ #category : #accessing }
IncomeCollection >> valuationOn: aDate [

	^ (incomes select: [ :eachIncome | eachIncome isEffectiveOn: aDate ]) 
		  sum: [ :eachIncome | eachIncome amount ]
]
