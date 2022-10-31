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
