Class {
	#name : #IncomeCollectionTest,
	#superclass : #AbstractContainersTest,
	#instVars : [
		'incomeCollection'
	],
	#category : #'PersonalBank-Tests-Core'
}

{ #category : #initialization }
IncomeCollectionTest >> setUp [

	super setUp.
	incomeCollection := Container new
]

{ #category : #'tests - addIncome' }
IncomeCollectionTest >> testAddIncomeFloat [

	incomeCollection addIncome: 0.1 on: randomDate.
	self
		assert: (incomeCollection addIncome: 0.2 on: randomDate)
		closeTo: 0.2
		precision: epsilon.
	self
		assert: (incomeCollection valuationOn: randomDate)
		closeTo: 0.3
		precision: epsilon
]

{ #category : #'tests - addIncome' }
IncomeCollectionTest >> testAddIncomeFractionnal1 [

	"Positive"

	self
		assert: (incomeCollection addIncome: 1 / 2 on: randomDate)
		closeTo: 1 / 2
		precision: epsilon.
	self
		assert: (incomeCollection valuationOn: randomDate)
		closeTo: 1 / 2
		precision: epsilon.

	"negative"
	self
		assert: (incomeCollection addIncome: -2 / 3 on: randomDate)
		closeTo: (2 / 3) negated
		precision: epsilon.
	self
		assert: (incomeCollection valuationOn: randomDate)
		closeTo: 1 / 2 - (2 / 3)
		precision: epsilon
]

{ #category : #'tests - addIncome' }
IncomeCollectionTest >> testAddIncomeFractionnal2 [

	"0.1 binary representation is not exact"

	self
		assert: (incomeCollection addIncome: 1 / 10 on: randomDate)
		closeTo: 1 / 10
		precision: epsilon.
	self
		assert: (incomeCollection valuationOn: randomDate)
		closeTo: 1 / 10
		precision: epsilon.
	self
		assert: (incomeCollection addIncome: 2 / 10 on: randomDate)
		closeTo: 2 / 10
		precision: epsilon.
	self
		assert: (incomeCollection valuationOn: randomDate)
		closeTo: 3 / 10
		precision: epsilon
]

{ #category : #'tests - addIncome' }
IncomeCollectionTest >> testAddIncomeLargeInteger [

	incomeCollection addIncome: randomFloat on: randomDate.
	self
		assert: (incomeCollection
				 addIncome: 123456789987654321e95 on: randomDate;
				 valuationOn: randomDate)
		closeTo:
		randomFloat asMinimalDecimalFraction + 123456789987654321e95
		precision: epsilon
]

{ #category : #'tests - addIncome' }
IncomeCollectionTest >> testAddIncomeNegativeInteger [

	"Add a positive income (addIncome: returns added income)"

	self assert: (incomeCollection valuationOn: randomDate) isZero.
	self
		assert:
		(incomeCollection addIncome: randomInteger1 negated on: randomDate)
		equals: randomInteger1 negated.
	self
		assert: (incomeCollection valuationOn: randomDate)
		equals: randomInteger1 negated.
	self
		assert:
		(incomeCollection addIncome: randomInteger2 negated on: randomDate)
		equals: randomInteger2 negated.
	self
		assert: (incomeCollection valuationOn: randomDate)
		equals: randomInteger1 negated + randomInteger2 negated
]

{ #category : #'tests - addIncome' }
IncomeCollectionTest >> testAddIncomeOnDifferentDates [

	incomeCollection addIncome: randomInteger1 on: randomDate.
	incomeCollection
		addIncome: randomInteger2
		on: (randomDate addMonths: 1).
	incomeCollection
		addIncome: randomInteger3
		on: (randomDate addMonths: 2).
	self
		assert: (incomeCollection valuationOn: (randomDate addDays: -1))
		equals: 0.
	self
		assert: (incomeCollection valuationOn: randomDate)
		equals: randomInteger1.
	self
		assert:
		(incomeCollection valuationOn:
			 ((randomDate addMonths: 1) addDays: 2))
		equals: randomInteger1 + randomInteger2.
	self
		assert:
		(incomeCollection valuationOn:
			 ((randomDate addMonths: 2) addDays: 5))
		equals: randomInteger1 + randomInteger2 + randomInteger3
]

{ #category : #'tests - addIncome' }
IncomeCollectionTest >> testAddIncomePositiveInteger [

	"Add a positive income (addIncome: returns added income)"

	self assert: (incomeCollection valuationOn: randomDate) isZero.
	self
		assert: (incomeCollection addIncome: randomInteger1 on: randomDate)
		equals: randomInteger1.
	self assert: (incomeCollection valuationOn: randomDate) equals: randomInteger1.
	self
		assert: (incomeCollection addIncome: randomInteger2 on: randomDate)
		equals: randomInteger2.
	self
		assert: (incomeCollection valuationOn: randomDate)
		equals: randomInteger1 + randomInteger2
]

{ #category : #'tests - addIncome' }
IncomeCollectionTest >> testAddIncomeRandomFloat [

	incomeCollection addIncome: randomFloat on: randomDate.
	self
		assert: (incomeCollection addIncome: randomPositive on: randomDate)
		closeTo: randomPositive
		precision: epsilon.
	self
		assert: (incomeCollection valuationOn: randomDate)
		closeTo: randomFloat asMinimalDecimalFraction
			+ randomPositive asMinimalDecimalFraction
		precision: epsilon
]

{ #category : #'tests - addOutcome' }
IncomeCollectionTest >> testAddOutcomeFloat [

	incomeCollection addOutcome: 0.1 on: randomDate.
	self
		assert: (incomeCollection addOutcome: 0.2 on: randomDate)
		closeTo: 0.2
		precision: epsilon.
	self
		assert: (incomeCollection valuationOn: randomDate)
		closeTo: 0.3 negated
		precision: epsilon
]

{ #category : #'tests - addOutcome' }
IncomeCollectionTest >> testAddOutcomeFractionnal1 [

	"Positive"

	self
		assert: (incomeCollection addOutcome: 1 / 2 on: randomDate)
		closeTo: 1 / 2
		precision: epsilon.
	self
		assert: (incomeCollection valuationOn: randomDate)
		closeTo: -1 / 2
		precision: epsilon.

	"negative"
	self
		assert: (incomeCollection addOutcome: -2 / 3 on: randomDate)
		closeTo: (2 / 3) negated
		precision: epsilon.
	self
		assert: (incomeCollection valuationOn: randomDate)
		closeTo: -1 / 2 + (2 / 3)
		precision: epsilon
]

{ #category : #'tests - addOutcome' }
IncomeCollectionTest >> testAddOutcomeFractionnal2 [

	"0.1 binary representation is not exact"

	self
		assert: (incomeCollection addOutcome: 1 / 10 on: randomDate)
		closeTo: 1 / 10
		precision: epsilon.
	self
		assert: (incomeCollection valuationOn: randomDate)
		closeTo: -1 / 10
		precision: epsilon.
	self
		assert: (incomeCollection addOutcome: 2 / 10 on: randomDate)
		closeTo: 2 / 10
		precision: epsilon.
	self
		assert: (incomeCollection valuationOn: randomDate)
		closeTo: -3 / 10
		precision: epsilon
]

{ #category : #'tests - addOutcome' }
IncomeCollectionTest >> testAddOutcomeLargeInteger [

	incomeCollection addIncome: randomFloat on: randomDate.
	self
		assert: (incomeCollection
				 addOutcome: 123456789987654321e95 on: randomDate;
				 valuationOn: randomDate)
		closeTo: randomFloat - 123456789987654321e95
		precision: epsilon
]

{ #category : #'tests - addOutcome' }
IncomeCollectionTest >> testAddOutcomeNegativeInteger [

	"Add a positive income (addOutcome: returns added outcome)"

	self assert: (incomeCollection valuationOn: randomDate) isZero.
	self
		assert:
		(incomeCollection addOutcome: randomInteger1 negated on: randomDate)
		equals: randomInteger1 negated.
	self
		assert: (incomeCollection valuationOn: randomDate)
		equals: randomInteger1.
	self
		assert:
		(incomeCollection addOutcome: randomInteger2 negated on: randomDate)
		equals: randomInteger2 negated.
	self
		assert: (incomeCollection valuationOn: randomDate)
		equals: randomInteger1 + randomInteger2
]

{ #category : #'tests - addOutcome' }
IncomeCollectionTest >> testAddOutcomeOnDifferentDates [

	incomeCollection addOutcome: randomInteger1 on: randomDate.
	incomeCollection
		addOutcome: randomInteger2
		on: (randomDate addMonths: 1).
	incomeCollection
		addOutcome: randomInteger3
		on: (randomDate addMonths: 2).
	self
		assert: (incomeCollection valuationOn: (randomDate addDays: -1))
		equals: 0.
	self
		assert: (incomeCollection valuationOn: randomDate)
		equals: randomInteger1 negated.
	self
		assert:
		(incomeCollection valuationOn:
			 ((randomDate addMonths: 1) addDays: 2))
		equals: (randomInteger1 + randomInteger2) negated.
	self
		assert:
		(incomeCollection valuationOn:
			 ((randomDate addMonths: 2) addDays: 5))
		equals: (randomInteger1 + randomInteger2 + randomInteger3) negated
]

{ #category : #'tests - addOutcome' }
IncomeCollectionTest >> testAddOutcomePositiveInteger [

	"Add a positive outcome (addOutcome: returns outcome amount)"

	self assert: (incomeCollection valuationOn: randomDate) isZero.
	self
		assert: (incomeCollection addOutcome: randomInteger1 on: randomDate)
		equals: randomInteger1.
	self
		assert: (incomeCollection valuationOn: randomDate)
		equals: randomInteger1 negated.
	self
		assert: (incomeCollection addOutcome: randomInteger2 on: randomDate)
		equals: randomInteger2.
	self
		assert: (incomeCollection valuationOn: randomDate)
		equals: randomInteger1 negated + randomInteger2 negated
]

{ #category : #'tests - addOutcome' }
IncomeCollectionTest >> testAddOutcomeRandomFloat [

	incomeCollection addOutcome: randomFloat on: randomDate.
	self
		assert: (incomeCollection addOutcome: randomPositive on: randomDate)
		closeTo: randomPositive
		precision: epsilon.
	self
		assert: (incomeCollection valuationOn: randomDate)
		closeTo: (randomFloat asMinimalDecimalFraction
			 + randomPositive asMinimalDecimalFraction) negated
		precision: epsilon
]

{ #category : #test }
IncomeCollectionTest >> testIsEmpty [

	self assert: incomeCollection isEmpty.
	incomeCollection addOutcome: 0 on: randomDate.
	self deny: incomeCollection isEmpty
]
