Class {
	#name : #ContainerTest,
	#superclass : #TestCase,
	#instVars : [
		'epsilon',
		'container',
		'container1',
		'container2',
		'container3',
		'randomPositive',
		'randomNegative',
		'randomInteger1',
		'randomInteger2',
		'randomInteger3',
		'randomFloat',
		'hugeInteger'
	],
	#category : #'PersonalBank-Tests-Core'
}

{ #category : #running }
ContainerTest >> setUp [

	"Hooks that subclasses may override to define the fixture of test."

	super setUp.
	container := Container new.
	container1 := Container new.
	container2 := Container new.
	container3 := Container new.
	randomFloat := SharedRandom globalGenerator next.
	randomInteger1 := 1 + (SharedRandom globalGenerator nextInteger: 100).
	randomInteger2 := 1 + (SharedRandom globalGenerator nextInteger: 100).
	randomInteger3 := 1 + (SharedRandom globalGenerator nextInteger: 100).
	epsilon := 1.0e-50.
	randomPositive := 1 + SharedRandom globalGenerator next.
	randomNegative := (1 + SharedRandom globalGenerator next) negated.
	hugeInteger := 1e999
]

{ #category : #'tests - subcontainers' }
ContainerTest >> testAddDeepSubcontainers [

	container income: randomInteger1.
	container1 income: randomInteger2.
	container2 income: randomFloat.
	self assert: container subcontainers isEmpty.
	self assert: container1 subcontainers isEmpty.
	self assert: container totalIncome equals: randomInteger1.
	container addSubcontainer: container1.
	self assert: container subcontainers equals: { container1 }.
	self assert: container1 subcontainers isEmpty.
	self
		assert: container totalIncome
		equals: randomInteger1 + randomInteger2.
	container1 addSubcontainer: container2.
	self assert: container subcontainers equals: { container1 }.
	self assert: container1 subcontainers equals: { container2 }.
	self
		assert: container totalIncome
		closeTo:
		randomInteger1 + randomInteger2
		+ randomFloat asMinimalDecimalFraction
		precision: epsilon.
	self assert: container recursiveSubcontainers asSet equals: { 
			container.
			container1.
			container2 } asSet.
	self
		assert: container recursiveSubcontainersWithoutSelf asSet
		equals: { 
				container1.
				container2 } asSet
]

{ #category : #'tests - addIncome' }
ContainerTest >> testAddIncomeFloat [
	container income: 0.1.
	self
		assert: (container addIncome: 0.2)
		closeTo: 0.2
		precision: epsilon.
	self assert: container income closeTo: 0.3 precision: epsilon
]

{ #category : #'tests - addIncome' }
ContainerTest >> testAddIncomeFractionnal [
	"Positive"

	self
		assert: (container addIncome: 1 / 2)
		closeTo: 1 / 2
		precision: epsilon.
	self assert: container income closeTo: 1 / 2 precision: epsilon.

	"negative"
	self
		assert: (container addIncome: -2 / 3)
		closeTo: (2 / 3) negated
		precision: epsilon.
	self
		assert: container income
		closeTo: 1 / 2 - (2 / 3)
		precision: epsilon.

	"0.1 binary representation is not exact"
	container income: 0.
	self
		assert: (container addIncome: 1 / 10)
		closeTo: 1 / 10
		precision: epsilon.
	self assert: container income closeTo: 1 / 10 precision: epsilon.
	self
		assert: (container addIncome: 2 / 10)
		closeTo: 2 / 10
		precision: epsilon.
	self assert: container income closeTo: 3 / 10 precision: epsilon
]

{ #category : #'tests - addIncome' }
ContainerTest >> testAddIncomeLargeInteger [
	container income: randomFloat.
	self
		assert:
			(container
				addIncome: 123456789987654321e95;
				income)
		closeTo: randomFloat asMinimalDecimalFraction + 123456789987654321e95
		precision: epsilon
]

{ #category : #'tests - addIncome' }
ContainerTest >> testAddIncomeNegativeInteger [
	"Add a positive income (addIncome: returns added income)"

	self assert: container income isZero.
	self
		assert: (container addIncome: randomInteger1 negated)
		equals: randomInteger1 negated.
	self assert: container income equals: randomInteger1 negated.
	self
		assert: (container addIncome: randomInteger2 negated)
		equals: randomInteger2 negated.
	self
		assert: container income
		equals: randomInteger1 negated + randomInteger2 negated
]

{ #category : #'tests - addIncome' }
ContainerTest >> testAddIncomeNotNumbers [
	"Add infinity or nan"

	self assert: (container addIncome: Float infinity) equals: 0.
	self assert: container income isZero.
	self assert: (container addIncome: Float nan) equals: 0.
	self assert: container income isZero.
	self assert: (container addIncome: '12') equals: 0.
	self assert: container income isZero.
	self assert: (container addIncome: nil) equals: 0.
	self assert: container income isZero.
	self assert: (container addIncome: true) equals: 0.
	self assert: container income isZero
]

{ #category : #'tests - addIncome' }
ContainerTest >> testAddIncomePositiveInteger [
	"Add a positive income (addIncome: returns added income)"

	self assert: container income isZero.
	self
		assert: (container addIncome: randomInteger1)
		equals: randomInteger1.
	self assert: container income equals: randomInteger1.
	self
		assert: (container addIncome: randomInteger2)
		equals: randomInteger2.
	self assert: container income equals: randomInteger1 + randomInteger2
]

{ #category : #'tests - addIncome' }
ContainerTest >> testAddIncomeRandomFloat [
	container income: randomFloat.
	self
		assert: (container addIncome: randomPositive)
		closeTo: randomPositive
		precision: epsilon.
	self
		assert: container income
		closeTo:
			randomFloat asMinimalDecimalFraction
				+ randomPositive asMinimalDecimalFraction
		precision: epsilon
]

{ #category : #'tests - addOutcome' }
ContainerTest >> testAddOutcomeFractionnal [
	"Positive"

	self
		assert: (container addOutcome: 1 / 2)
		closeTo: 1 / 2
		precision: epsilon.
	self assert: container income closeTo: -1 / 2 precision: epsilon.

	"negative"
	self
		assert: (container addOutcome: -2 / 3)
		closeTo: (2 / 3) negated
		precision: epsilon.
	self
		assert: container income
		closeTo: -1 / 2 + (2 / 3)
		precision: epsilon.

	"0.1 binary representation is not exact"
	container income: 0.
	self
		assert: (container addOutcome: 1 / 10)
		closeTo: 1 / 10
		precision: epsilon.
	self assert: container income closeTo: -1 / 10 precision: epsilon.
	self
		assert: (container addOutcome: 2 / 10)
		closeTo: 2 / 10
		precision: epsilon.
	self assert: container income closeTo: -3 / 10 precision: epsilon
]

{ #category : #'tests - addOutcome' }
ContainerTest >> testAddOutcomeLargeInteger [
	container income: randomFloat.
	self
		assert:
			(container
				addOutcome: 123456789987654321e95;
				income)
		closeTo: randomFloat - 123456789987654321e95
		precision: epsilon
]

{ #category : #'tests - addOutcome' }
ContainerTest >> testAddOutcomeNegativeInteger [
	"Add a positive income (addOutcome: returns added outcome)"

	self assert: container income isZero.
	self
		assert: (container addOutcome: randomInteger1 negated)
		equals: randomInteger1 negated.
	self assert: container income equals: randomInteger1.
	self
		assert: (container addOutcome: randomInteger2 negated)
		equals: randomInteger2 negated.
	self assert: container income equals: randomInteger1 + randomInteger2
]

{ #category : #'tests - addOutcome' }
ContainerTest >> testAddOutcomePositiveInteger [
	"Add a positive outcome (addOutcome: returns outcome amount)"

	self assert: container income isZero.
	self
		assert: (container addOutcome: randomInteger1)
		equals: randomInteger1.
	self assert: container income equals: randomInteger1 negated.
	self
		assert: (container addOutcome: randomInteger2)
		equals: randomInteger2.
	self
		assert: container income
		equals: randomInteger1 negated + randomInteger2 negated
]

{ #category : #'tests - addOutcome' }
ContainerTest >> testAddOutomeFloat [
	container outcome: 0.1.
	self
		assert: (container addOutcome: 0.2)
		closeTo: 0.2
		precision: epsilon.
	self assert: container income closeTo: 0.3 negated precision: epsilon.
	self
		assert:
			(container
				addOutcome: 153.18615;
				income)
		closeTo: -3 / 10 - (15318615 / 100000)
		precision: epsilon.
	self
		assert:
			(container
				addOutcome: 51.77202372819618;
				income)
		closeTo:
			-3 / 10 - (15318615 / 100000)
				- 51.77202372819618 asMinimalDecimalFraction
		precision: epsilon.
	self
		assert:
			(container
				addOutcome: randomFloat;
				income)
		closeTo:
			-3 / 10 - (15318615 / 100000)
				- 51.77202372819618 asMinimalDecimalFraction
				- randomFloat asMinimalDecimalFraction
		precision: epsilon
]

{ #category : #'tests - addOutcome' }
ContainerTest >> testAddOutomeNotNumbers [
	"Add infinity or nan"

	self assert: (container addOutcome: Float infinity) equals: 0.
	self assert: container income isZero.
	self assert: (container addOutcome: Float nan) equals: 0.
	self assert: container income isZero.
	self assert: (container addOutcome: '12') equals: 0.
	self assert: container income isZero.
	self assert: (container addOutcome: nil) equals: 0.
	self assert: container income isZero.
	self assert: (container addOutcome: true) equals: 0.
	self assert: container income isZero
]

{ #category : #'tests - subcontainers' }
ContainerTest >> testAddSubcontainer [
	self assert: container subcontainers isEmpty.
	self assert: container1 subcontainers isEmpty.
	self
		assert: (container addSubcontainer: container1)
		identicalTo: container1.
	self assert: container subcontainers equals: {container1}.
	self assert: container1 subcontainers isEmpty.
	self
		assert: (container addSubcontainer: container1)
		identicalTo: container1.
	self assert: container subcontainers equals: {container1}.
	self assert: container1 subcontainers isEmpty.
	self
		assert: (container removeSubcontainer: container1)
		identicalTo: container1.
	self assert: container subcontainers isEmpty.
	self assert: container1 subcontainers isEmpty.
	self assert: (container removeSubcontainer: container1) equals: nil.
	self assert: container addSubcontainer class equals: Container.
	self assert: container subcontainers size equals: 1.
	container addSubcontainer.
	self assert: container subcontainers size equals: 2
]

{ #category : #'tests - subcontainers' }
ContainerTest >> testAddSubcontainerNamed [

	self assert: container subcontainers isEmpty.
	self assert: container1 subcontainers isEmpty.
	self
		assert: (container addSubcontainerNamed: 'Anything')
		equals: (Container named: 'Anything').
	self assert: container subcontainers size equals: 1
]

{ #category : #tests }
ContainerTest >> testCanStore [
	self assert: (Container canStore: 0) equals: true.
	self assert: (Container canStore: randomInteger1) equals: true.
	self
		assert: (Container canStore: randomInteger2 negated)
		equals: true.
	self assert: (Container canStore: randomFloat) equals: true.
	self assert: (Container canStore: 348 / 46) equals: true.
	self assert: (Container canStore: 10e999) equals: true.
	self assert: (Container canStore: '12') equals: false.
	self assert: (Container canStore: nil) equals: false.
	self assert: (Container canStore: Float infinity) equals: false.
	self assert: (Container canStore: Float nan) equals: false.
	self assert: (Container canStore: true) equals: false
]

{ #category : #'tests - income' }
ContainerTest >> testDefaultIncomeValueIsZero [
	self assert: container income isZero
]

{ #category : #'tests - outcome' }
ContainerTest >> testDefaultOutcomeValueIsZero [
	self assert: container outcome isZero
]

{ #category : #'tests - subcontainers' }
ContainerTest >> testEmptySubcontainers [

	| subContainer2 |
	container addSubcontainer: container1.
	container addSubcontainer: container2.
	container addSubcontainer.
	subContainer2 := container2 addSubcontainer.
	self assert: container2 hasEmptySubcontainers.
	subContainer2 income: randomInteger1.
	container1 addSubcontainer.
	self assert: container hasEmptySubcontainers.
	container2 income: randomInteger1.
	self deny: container2 hasEmptySubcontainers.
	subContainer2 income: 0.
	self assert: container hasEmptySubcontainers.
	self assert: container1 hasEmptySubcontainers.
	self assert: container2 hasEmptySubcontainers.
	self deny: subContainer2 hasEmptySubcontainers
]

{ #category : #tests }
ContainerTest >> testEqualsSign [

	container income: randomInteger1.
	container1 income: randomInteger1.
	self assert: container equals: container1.
	self assert: container hash equals: container1 hash.
	container income: randomInteger1.
	container1 income: randomInteger1 + randomFloat.
	self deny: container equals: container1
]

{ #category : #tests }
ContainerTest >> testExactValueFor [
	self
		assert: (Container exactValueFor: randomInteger1)
		equals: randomInteger1.
	self
		assert: (Container exactValueFor: randomFloat)
		equals: randomFloat asMinimalDecimalFraction.
	self
		assert: (Container exactValueFor: Float infinity)
		equals: Float infinity
]

{ #category : #'tests - totalCapital' }
ContainerTest >> testFloatTotalCapital [
	"Float capital"

	container income: 0.1.
	self assert: container income closeTo: 1 / 10 precision: epsilon.
	container addIncome: 0.2.
	self assert: container income closeTo: 3 / 10 precision: epsilon.
	container income: randomFloat.
	self assert: container income closeTo: randomFloat precision: epsilon
]

{ #category : #'tests - totalCapital' }
ContainerTest >> testFractionnalTotalCapital [
	"Fractional capital"

	container income: -12.
	container addIncome: 1 / 2.
	self
		assert: container income
		closeTo: -12 + (1 / 2)
		precision: epsilon
]

{ #category : #'tests - income' }
ContainerTest >> testIncomeFloat [
	"Float capital"

	container income: 0.1.
	self assert: container income closeTo: 1 / 10 precision: epsilon
]

{ #category : #'tests - income' }
ContainerTest >> testIncomeFractionnal [
	"Fractional capital"

	container income: 1 / 2.
	self assert: container income closeTo: 1 / 2 precision: epsilon.
	container income: 2 / 3.
	self assert: container income closeTo: 2 / 3 precision: epsilon
]

{ #category : #'tests - subcontainers' }
ContainerTest >> testIncomeIsSumOfSubcontainersIncomes [
	container income: randomInteger1.
	container1 income: randomInteger2.
	self assert: container totalIncome equals: randomInteger1.
	self assert: container1 totalIncome equals: randomInteger2.
	container addSubcontainer: container1.
	self assert: container totalIncome equals: randomInteger1 + randomInteger2.
	self assert: container1 totalIncome equals: randomInteger2.
	container removeSubcontainer: container1.
	self assert: container totalIncome equals: randomInteger1.
	self assert: container1 totalIncome equals: randomInteger2
]

{ #category : #'tests - income' }
ContainerTest >> testIncomeLargeInteger [
	self
		assert: (container income: 123456789987654321e95)
		closeTo: 123456789987654321e95
		precision: epsilon.
	self
		assert: container income
		closeTo: 123456789987654321e95
		precision: epsilon
]

{ #category : #'tests - income' }
ContainerTest >> testIncomeNotNumbers [
	self assert: (container income: Float infinity) equals: 0.
	self assert: container income isZero.
	self assert: (container income: Float nan) equals: 0.
	self assert: container income isZero.
	self assert: (container income: '12') equals: 0.
	self assert: container income isZero.
	self assert: (container income: nil) equals: 0.
	self assert: container income isZero.
	self assert: (container income: true) equals: 0.
	self assert: container income isZero
]

{ #category : #'tests - income' }
ContainerTest >> testIncomeReturnsNewTotalCapital [
	"float"

	self
		assert: (container income: randomFloat)
		closeTo: randomFloat
		precision: epsilon.

	"positive integer"
	self
		assert: (container income: randomInteger1)
		equals: randomInteger1.

	"negative integer"
	self
		assert: (container income: randomInteger2 negated)
		equals: randomInteger2 negated
]

{ #category : #'tests - subcontainers' }
ContainerTest >> testIncomeWithSubcontainers [
	container income: randomInteger1.
	container1 income: randomInteger2.
	container2 income: randomFloat.
	container3 income: randomInteger3.
	container addSubcontainer: container2.
	container addSubcontainer: container1.
	container2 addSubcontainer: container3.
	container1 addSubcontainer: container3.
	self
		assert: container totalIncome
		closeTo:
			randomInteger1 + randomInteger2 + randomInteger3
				+ randomFloat asMinimalDecimalFraction
]

{ #category : #'tests - subcontainers' }
ContainerTest >> testIncomeWithoutSubcontainers [
	container income: randomInteger1.
	container1 income: randomInteger2.
	self assert: container income equals: randomInteger1.
	self assert: container1 income equals: randomInteger2.
	container addSubcontainer: container1.
	self assert: container income equals: randomInteger1.
	self assert: container1 income equals: randomInteger2.
	container removeSubcontainer: container1.
	self assert: container income equals: randomInteger1.
	self assert: container1 income equals: randomInteger2
]

{ #category : #'tests - totalCapital' }
ContainerTest >> testIntegerTotalCapital [
	container income: randomInteger1.
	self assert: container income equals: randomInteger1.
	container income: randomInteger2 negated.
	self assert: container income equals: randomInteger2 negated
]

{ #category : #tests }
ContainerTest >> testName [
	container name: 'test'.
	self assert: container name equals: 'test'.
	self assert: container printString equals: 'test (0)'.
	container name: Color yellow.
	self assert: container name equals: Color yellow
]

{ #category : #'tests - outcome' }
ContainerTest >> testOutcomeEqualsTotalCapitalNegated [
	"float"

	container outcome: randomFloat.
	self
		assert: container outcome
		closeTo: randomFloat
		precision: epsilon.
	self assert: container outcome equals: container income negated.

	"positive integer"
	container outcome: randomInteger1.
	self assert: container outcome equals: randomInteger1.
	self assert: container outcome equals: container income negated.

	"negative integer"
	container outcome: randomInteger2 negated.
	self assert: container outcome equals: randomInteger2 negated.
	self assert: container outcome equals: container income negated
]

{ #category : #'tests - outcome' }
ContainerTest >> testOutcomeFloat [
	"Float capital"

	container outcome: 0.1.
	self assert: container outcome closeTo: 1 / 10 precision: epsilon
]

{ #category : #'tests - outcome' }
ContainerTest >> testOutcomeFractionnal [
	"Fractional capital"

	container outcome: 1 / 2.
	self assert: container outcome closeTo: 1 / 2 precision: epsilon.
	container outcome: 2 / 3.
	self assert: container outcome closeTo: 2 / 3 precision: epsilon
]

{ #category : #'tests - outcome' }
ContainerTest >> testOutcomeLargeInteger [
	self
		assert: (container outcome: 123456789987654321e95)
		closeTo: 123456789987654321e95
		precision: epsilon.
	self
		assert: container outcome
		closeTo: 123456789987654321e95
		precision: epsilon
]

{ #category : #'tests - outcome' }
ContainerTest >> testOutcomeNotNumbers [
	self assert: (container outcome: Float infinity) equals: 0.
	self assert: container outcome isZero.
	self assert: (container outcome: Float nan) equals: 0.
	self assert: container outcome isZero.
	self assert: (container outcome: '12') equals: 0.
	self assert: container outcome isZero.
	self assert: (container outcome: nil) equals: 0.
	self assert: container outcome isZero.
	self assert: (container outcome: true) equals: 0.
	self assert: container outcome isZero
]

{ #category : #'tests - outcome' }
ContainerTest >> testOutcomeReturnsNewTotalCapitalNegated [
	"Total capital is negated outcome"

	"float"

	self
		assert: (container outcome: randomFloat)
		closeTo: randomFloat
		precision: epsilon.
	self
		assert: container income
		closeTo: randomFloat negated
		precision: epsilon.

	"positive integer"
	self
		assert: (container outcome: randomInteger1)
		equals: randomInteger1.
	self assert: container income equals: randomInteger1 negated.

	"negative integer"
	self
		assert: (container outcome: randomInteger2 negated)
		equals: randomInteger2 negated.
	self assert: container income equals: randomInteger2
]

{ #category : #tests }
ContainerTest >> testPrintString [

	| main sub1 sub2 sub3 |
	container income: 284.
	self assert: container printString equals: 'a Container (284)'.
	container income: 284.324971.
	self assert: container printString equals: 'a Container (284.32)'.
	main := Container named: 'main'.
	sub1 := main addSubcontainer
		        name: 'sub1';
		        yourself.
	sub1 income: 12.
	sub1 addSubcontainer
		name: 'sub1 sub1';
		income: 129.129.
	sub1 addSubcontainer name: 'sub1 sub2'.
	sub2 := main addSubcontainer
		        name: 'sub2';
		        yourself.
	sub2 addSubcontainer
		name: 'sub2 sub1';
		income: -1.
	sub3 := main addSubcontainer
		        name: 'sub3';
		        yourself.
	sub2 addSubcontainer name: 'sub2 sub2'.
	sub3 addSubcontainer income: 134.
	self assert: main printString equals: 'main (0, 274.13 in total)
	sub1 (12, 141.13 in total)
		sub1 sub1 (129.13)
		sub1 sub2 (0)
	sub3 (0, 134 in total)
		a Container (134)
	sub2 (0, -1 in total)
		sub2 sub2 (0)
		sub2 sub1 (-1)'
]

{ #category : #'tests - subcontainers' }
ContainerTest >> testRecursiveSubcontainerNamed [

	self assert: container subcontainers isEmpty.
	self
		assert: (container recursiveSubcontainerNamed: 'Another one')
		equals: (Container named: 'Another one').
	self assert: container subcontainers size equals: 1.
	self
		assert: (container recursiveSubcontainerNamed: 'Another one')
		equals: (Container named: 'Another one').
	self assert: container subcontainers size equals: 1.
	self
		assert: (container addSubcontainerNamed: 'Another one')
		equals: (Container named: 'Another one').
	self assert: container subcontainers size equals: 2.
	self
		assert: (container addSubcontainerNamed: 'Another one')
		equals: (Container named: 'Another one').
	self assert: container subcontainers size equals: 3.
	self
		should: [ container recursiveSubcontainerNamed: 'Another one' ]
		raise: Error
		whoseDescriptionIncludes: 'Ambiguous'
		description: 'Several containers with the same name'.
	self assert: container subcontainers size equals: 3.
	self
		assert: (container recursiveSubcontainerNamed: 'Yet another one')
		equals: (Container named: 'Yet another one').
	self assert: container subcontainers size equals: 4
]

{ #category : #'tests - subcontainers' }
ContainerTest >> testRemoveEmptySubcontainers [
	| subContainer2 |
	container addSubcontainer: container1.
	container addSubcontainer: container2.
	container addSubcontainer.
	subContainer2 := container2 addSubcontainer.
	subContainer2 income: randomInteger1.
	container1 addSubcontainer.
	container removeEmptySubcontainers.
	self assert: container subcontainers equals: {container2}.
	self assert: container1 subcontainers isEmpty.
	self assert: subContainer2 subcontainers isEmpty.
	self assert: container2 subcontainers equals: {subContainer2}
]

{ #category : #tests }
ContainerTest >> testReset [
	self assert: container reset income equals: 0.
	self assert: container reset equals: container.
	container
		addIncome: 5;
		reset.
	self assert: container income equals: 0
]

{ #category : #'tests - moving' }
ContainerTest >> testSendTo [
	container income: randomInteger1.
	self
		assert: (Container move: randomInteger2 from: container to: container1)
		equals: randomInteger2.
	self assert: container income equals: randomInteger1 - randomInteger2.
	self assert: container1 income equals: randomInteger2
]

{ #category : #'tests - moving' }
ContainerTest >> testSendToSelf [
	container income: randomInteger1.
	self assert: container income equals: randomInteger1.
	self
		assert: (Container move: randomInteger2 from: container to: container)
		equals: randomInteger2.
	self assert: container income equals: randomInteger1.
]

{ #category : #'tests - moving' }
ContainerTest >> testSendToSubcontainer [

	container income: randomInteger1.
	container addSubcontainer: (container1
			 name: 'existing container';
			 yourself).
	self
		assert: (container
				 send: randomInteger2
				 toSubcontainerNamed: 'existing container')
		equals: randomInteger2.
	self assert: container income equals: randomInteger1 - randomInteger2.
	self assert: container1 income equals: randomInteger2.
	self
		assert:
		(container send: randomInteger2 toSubcontainerNamed: 'new container')
		equals: randomInteger2.
	self
		assert: container income
		equals: randomInteger1 - randomInteger2 - randomInteger2.
	self assert: container1 income equals: randomInteger2.
	self
		assert: (container subcontainerNamed: 'new container') income
		equals: randomInteger2.
	container addSubcontainerNamed: 'existing container'.
	self
		should: [ 
			container
				send: randomInteger2
				toSubcontainerNamed: 'existing container' ]
		raise: Error
		whoseDescriptionIncludes: 'Ambiguous'
		description: '2 containers with the same name'
]

{ #category : #'tests - subcontainers' }
ContainerTest >> testShouldNotRemoveSubcontainersIfAnyIncomeIsNotZero [

	container addSubcontainer: container1.
	container1 addSubcontainer: container2.
	container1 income: randomInteger1.
	container2 income: randomInteger1 negated.
	container removeEmptySubcontainers.
	self assert: container subcontainers equals: { container1 }.
	self assert: container1 subcontainers equals: { container2 }
]

{ #category : #'tests - subcontainers' }
ContainerTest >> testSubcontainerNamed [

	self assert: container subcontainers isEmpty.
	self
		assert: (container subcontainerNamed: 'Another one')
		equals: (Container named: 'Another one').
	self assert: container subcontainers size equals: 1.
	self
		assert: (container subcontainerNamed: 'Another one')
		equals: (Container named: 'Another one').
	self assert: container subcontainers size equals: 1.
	self
		assert: (container addSubcontainerNamed: 'Another one')
		equals: (Container named: 'Another one').
	self assert: container subcontainers size equals: 2.
	self
		assert: (container addSubcontainerNamed: 'Another one')
		equals: (Container named: 'Another one').
	self assert: container subcontainers size equals: 3.
	self
		should: [ container subcontainerNamed: 'Another one' ]
		raise: Error
		whoseDescriptionIncludes: 'Ambiguous'
		description: 'Several containers with the same name'.
	self assert: container subcontainers size equals: 3.
	self
		assert: (container subcontainerNamed: 'Yet another one')
		equals: (Container named: 'Yet another one').
	self assert: container subcontainers size equals: 4
]

{ #category : #'tests - subcontainers' }
ContainerTest >> testSubcontainersTree [

	container
		addSubcontainer: container1;
		addSubcontainer: container2.
	container2 addSubcontainer: container3.
	self assert: container subcontainersTree equals: container -> (Set
			 with: container1 -> Set new
			 with: container2 -> (Set with: container3 -> Set new))
]
