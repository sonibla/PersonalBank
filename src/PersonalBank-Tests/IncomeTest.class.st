Class {
	#name : #IncomeTest,
	#superclass : #AbstractContainersTest,
	#category : #'PersonalBank-Tests-Core'
}

{ #category : #tests }
IncomeTest >> testCanUseAsAmount [

	self assert: (Income canUseAsAmount: 0) equals: true.
	self assert: (Income canUseAsAmount: randomInteger1) equals: true.
	self
		assert: (Income canUseAsAmount: randomInteger2 negated)
		equals: true.
	self assert: (Income canUseAsAmount: randomFloat) equals: true.
	self assert: (Income canUseAsAmount: 348 / 46) equals: true.
	self assert: (Income canUseAsAmount: 10e999) equals: true.
	self assert: (Income canUseAsAmount: '12') equals: false.
	self assert: (Income canUseAsAmount: nil) equals: false.
	self assert: (Income canUseAsAmount: Float infinity) equals: false.
	self assert: (Income canUseAsAmount: Float nan) equals: false.
	self assert: (Income canUseAsAmount: true) equals: false
]

{ #category : #test }
IncomeTest >> testEqualsSign [

	self
		assert: (Income of: randomInteger1 on: randomDate)
		equals: (Income of: randomInteger1 on: randomDate).
	self
		deny: (Income of: randomInteger1 on: randomDate)
		equals:
		(Income of: randomInteger1 on: (randomDate addDays: randomInteger2)).
	self
		deny: (Income of: randomInteger1 on: randomDate)
		equals: (Income of: randomInteger1 + randomInteger2 on: randomDate)
]

{ #category : #tests }
IncomeTest >> testExactValueFor [
	self
		assert: (Income exactValueFor: randomInteger1)
		equals: randomInteger1.
	self
		assert: (Income exactValueFor: randomFloat)
		equals: randomFloat asMinimalDecimalFraction.
	self
		assert: (Income exactValueFor: Float infinity)
		equals: Float infinity
]

{ #category : #test }
IncomeTest >> testIsEffectiveOn [

	self deny:
		((Income of: randomInteger1 on: randomDate) isEffectiveOn:
			 (randomDate addDays: -1)).

	self assert:
		((Income of: randomInteger1 on: randomDate) isEffectiveOn:
			 randomDate).

	self assert:
		((Income of: randomInteger1 on: randomDate) isEffectiveOn:
			 (randomDate addDays: 1))
]
