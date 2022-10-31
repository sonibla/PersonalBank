Class {
	#name : #ContainerTest,
	#superclass : #AbstractContainersTest,
	#instVars : [
		'container',
		'container1',
		'container2',
		'container3'
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
	container3 := Container new
]

{ #category : #'tests - subcontainers' }
ContainerTest >> testAddDeepSubcontainers [

	container addIncome: randomInteger1 on: randomDate.
	container1 addIncome: randomInteger2 on: randomDate.
	container2 addIncome: randomFloat on: randomDate.
	self assert: container subcontainers isEmpty.
	self assert: container1 subcontainers isEmpty.
	self assert: (container valuationWithSubcontainersOn: randomDate) equals: randomInteger1.
	container addSubcontainer: container1.
	self assert: container subcontainers equals: { container1 }.
	self assert: container1 subcontainers isEmpty.
	self
		assert: (container valuationWithSubcontainersOn: randomDate)
		equals: randomInteger1 + randomInteger2.
	container1 addSubcontainer: container2.
	self assert: container subcontainers equals: { container1 }.
	self assert: container1 subcontainers equals: { container2 }.
	self
		assert: (container valuationWithSubcontainersOn: randomDate)
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

	container addIncome: 0.1 on: randomDate.
	self
		assert: (container addIncome: 0.2 on: randomDate)
		closeTo: 0.2
		precision: epsilon.
	self
		assert: (container valuationOn: randomDate)
		closeTo: 0.3
		precision: epsilon
]

{ #category : #'tests - addIncome' }
ContainerTest >> testAddIncomeFractionnal1 [

	"Positive"

	self
		assert: (container addIncome: 1 / 2 on: randomDate)
		closeTo: 1 / 2
		precision: epsilon.
	self
		assert: (container valuationOn: randomDate)
		closeTo: 1 / 2
		precision: epsilon.

	"negative"
	self
		assert: (container addIncome: -2 / 3 on: randomDate)
		closeTo: (2 / 3) negated
		precision: epsilon.
	self
		assert: (container valuationOn: randomDate)
		closeTo: 1 / 2 - (2 / 3)
		precision: epsilon
]

{ #category : #'tests - addIncome' }
ContainerTest >> testAddIncomeFractionnal2 [

	"0.1 binary representation is not exact"

	self
		assert: (container addIncome: 1 / 10 on: randomDate)
		closeTo: 1 / 10
		precision: epsilon.
	self
		assert: (container valuationOn: randomDate)
		closeTo: 1 / 10
		precision: epsilon.
	self
		assert: (container addIncome: 2 / 10 on: randomDate)
		closeTo: 2 / 10
		precision: epsilon.
	self
		assert: (container valuationOn: randomDate)
		closeTo: 3 / 10
		precision: epsilon
]

{ #category : #'tests - addIncome' }
ContainerTest >> testAddIncomeLargeInteger [

	container addIncome: randomFloat on: randomDate.
	self
		assert: (container
				 addIncome: 123456789987654321e95 on: randomDate;
				 valuationOn: randomDate)
		closeTo:
		randomFloat asMinimalDecimalFraction + 123456789987654321e95
		precision: epsilon
]

{ #category : #'tests - addIncome' }
ContainerTest >> testAddIncomeNegativeInteger [

	"Add a positive income (addIncome: returns added income)"

	self assert: (container valuationOn: randomDate) isZero.
	self
		assert: (container addIncome: randomInteger1 negated on: randomDate)
		equals: randomInteger1 negated.
	self
		assert: (container valuationOn: randomDate)
		equals: randomInteger1 negated.
	self
		assert: (container addIncome: randomInteger2 negated on: randomDate)
		equals: randomInteger2 negated.
	self
		assert: (container valuationOn: randomDate)
		equals: randomInteger1 negated + randomInteger2 negated
]

{ #category : #'tests - addIncome' }
ContainerTest >> testAddIncomeOnDifferentDates [

	container addIncome: randomInteger1 on: randomDate.
	container addIncome: randomInteger2 on: (randomDate addMonths: 1).
	container addIncome: randomInteger3 on: (randomDate addMonths: 2).
	self
		assert: (container valuationOn: (randomDate addDays: -1))
		equals: 0.
	self
		assert: (container valuationOn: randomDate)
		equals: randomInteger1.
	self
		assert:
		(container valuationOn: ((randomDate addMonths: 1) addDays: 2))
		equals: randomInteger1 + randomInteger2.
	self
		assert:
		(container valuationOn: ((randomDate addMonths: 2) addDays: 5))
		equals: randomInteger1 + randomInteger2 + randomInteger3
]

{ #category : #'tests - addIncome' }
ContainerTest >> testAddIncomePositiveInteger [

	"Add a positive income (addIncome: returns added income)"

	self assert: (container valuationOn: randomDate) isZero.
	self
		assert: (container addIncome: randomInteger1 on: randomDate)
		equals: randomInteger1.
	self assert: (container valuationOn: randomDate) equals: randomInteger1.
	self
		assert: (container addIncome: randomInteger2 on: randomDate)
		equals: randomInteger2.
	self
		assert: (container valuationOn: randomDate)
		equals: randomInteger1 + randomInteger2
]

{ #category : #'tests - addIncome' }
ContainerTest >> testAddIncomeRandomFloat [

	container addIncome: randomFloat on: randomDate.
	self
		assert: (container addIncome: randomPositive on: randomDate)
		closeTo: randomPositive
		precision: epsilon.
	self
		assert: (container valuationOn: randomDate)
		closeTo: randomFloat asMinimalDecimalFraction
			+ randomPositive asMinimalDecimalFraction
		precision: epsilon
]

{ #category : #'tests - addOutcome' }
ContainerTest >> testAddOutcomeFractionnal1 [

	"Positive"

	self
		assert: (container addOutcome: 1 / 2 on: randomDate)
		closeTo: 1 / 2
		precision: epsilon.
	self
		assert: (container valuationOn: randomDate)
		closeTo: -1 / 2
		precision: epsilon.

	"negative"
	self
		assert: (container addOutcome: -2 / 3 on: randomDate)
		closeTo: (2 / 3) negated
		precision: epsilon.
	self
		assert: (container valuationOn: randomDate)
		closeTo: -1 / 2 + (2 / 3)
		precision: epsilon
]

{ #category : #'tests - addOutcome' }
ContainerTest >> testAddOutcomeFractionnal2 [

	"0.1 binary representation is not exact"

	self
		assert: (container addOutcome: 1 / 10 on: randomDate)
		closeTo: 1 / 10
		precision: epsilon.
	self
		assert: (container valuationOn: randomDate)
		closeTo: -1 / 10
		precision: epsilon.
	self
		assert: (container addOutcome: 2 / 10 on: randomDate)
		closeTo: 2 / 10
		precision: epsilon.
	self
		assert: (container valuationOn: randomDate)
		closeTo: -3 / 10
		precision: epsilon
]

{ #category : #'tests - addOutcome' }
ContainerTest >> testAddOutcomeLargeInteger [

	container addIncome: randomFloat on: randomDate.
	self
		assert: (container
				 addOutcome: 123456789987654321e95 on: randomDate;
				 valuationOn: randomDate)
		closeTo: randomFloat - 123456789987654321e95
		precision: epsilon
]

{ #category : #'tests - addOutcome' }
ContainerTest >> testAddOutcomeNegativeInteger [

	"Add a positive income (addOutcome: returns added outcome)"

	self assert: (container valuationOn: randomDate) isZero.
	self
		assert:
		(container addOutcome: randomInteger1 negated on: randomDate)
		equals: randomInteger1 negated.
	self assert: (container valuationOn: randomDate) equals: randomInteger1.
	self
		assert:
		(container addOutcome: randomInteger2 negated on: randomDate)
		equals: randomInteger2 negated.
	self
		assert: (container valuationOn: randomDate)
		equals: randomInteger1 + randomInteger2
]

{ #category : #'tests - addOutcome' }
ContainerTest >> testAddOutcomePositiveInteger [

	"Add a positive outcome (addOutcome: returns outcome amount)"

	self assert: (container valuationOn: randomDate) isZero.
	self
		assert: (container addOutcome: randomInteger1 on: randomDate)
		equals: randomInteger1.
	self
		assert: (container valuationOn: randomDate)
		equals: randomInteger1 negated.
	self
		assert: (container addOutcome: randomInteger2 on: randomDate)
		equals: randomInteger2.
	self
		assert: (container valuationOn: randomDate)
		equals: randomInteger1 negated + randomInteger2 negated
]

{ #category : #'tests - addOutcome' }
ContainerTest >> testAddOutomeFloat [

	container addOutcome: 0.1 on: randomDate.
	self
		assert: (container addOutcome: 0.2 on: randomDate)
		closeTo: 0.2
		precision: epsilon.
	self
		assert: (container valuationOn: randomDate)
		closeTo: 0.3 negated
		precision: epsilon.
	self
		assert: (container
				 addOutcome: 153.18615 on: randomDate;
				 valuationOn: randomDate)
		closeTo: -3 / 10 - (15318615 / 100000)
		precision: epsilon.
	self
		assert: (container
				 addOutcome: 51.77202372819618 on: randomDate;
				 valuationOn: randomDate)
		closeTo: -3 / 10 - (15318615 / 100000)
			- 51.77202372819618 asMinimalDecimalFraction
		precision: epsilon.
	self
		assert: (container
				 addOutcome: randomFloat on: randomDate;
				 valuationOn: randomDate)
		closeTo: -3 / 10 - (15318615 / 100000)
			- 51.77202372819618 asMinimalDecimalFraction
			- randomFloat asMinimalDecimalFraction
		precision: epsilon
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

{ #category : #'tests - income' }
ContainerTest >> testDefaultIncomeValueIsZero [

	self assert: (container valuationOn: randomDate) isZero
]

{ #category : #'tests - subcontainers' }
ContainerTest >> testEmptySubcontainers [

	| subContainer2 |
	container addSubcontainer: container1.
	container addSubcontainer: container2.
	container addSubcontainer.
	subContainer2 := container2 addSubcontainer.
	self assert: container2 hasEmptySubcontainers.
	subContainer2 addIncome: randomInteger1 on: randomDate.
	container1 addSubcontainer.
	self assert: container hasEmptySubcontainers.
	container2 addIncome: randomInteger1 on: randomDate.
	self deny: container2 hasEmptySubcontainers.
	subContainer2 addOutcome: randomInteger1 on: randomDate.
	self assert: container hasEmptySubcontainers.
	self assert: container1 hasEmptySubcontainers.
	self deny: container2 hasEmptySubcontainers.
	self deny: subContainer2 hasEmptySubcontainers
]

{ #category : #tests }
ContainerTest >> testEqualsSign1 [

	container addIncome: randomInteger1 on: randomDate.
	container1 addIncome: randomInteger1 on: randomDate.
	self assert: container equals: container1.
	self assert: container hash equals: container1 hash
]

{ #category : #tests }
ContainerTest >> testEqualsSign2 [

	container addIncome: randomInteger1 on: randomDate.
	container1 addIncome: randomInteger1 + randomFloat on: randomDate.
	self deny: container equals: container1.
	self deny: container hash equals: container1 hash
]

{ #category : #tests }
ContainerTest >> testEqualsSign3 [

	container addIncome: randomInteger1 on: randomDate.
	container1 addIncome: randomInteger1 on: randomDate2.
	self deny: container equals: container1.
	self deny: container hash equals: container1 hash
]

{ #category : #'tests - totalCapital' }
ContainerTest >> testFloatTotalCapital [

	"Float capital"

	container addIncome: 0.1 on: randomDate.
	self
		assert: (container valuationOn: randomDate)
		closeTo: 1 / 10
		precision: epsilon.
	container addIncome: 0.2 on: randomDate.
	self
		assert: (container valuationOn: randomDate)
		closeTo: 3 / 10
		precision: epsilon.
	container addOutcome: 3 / 10 on: randomDate.
	container addIncome: randomFloat on: randomDate.
	self
		assert: (container valuationOn: randomDate)
		closeTo: randomFloat
		precision: epsilon
]

{ #category : #'tests - totalCapital' }
ContainerTest >> testFractionnalTotalCapital [

	"Fractional capital"

	container addIncome: -12 on: randomDate.
	container addIncome: 1 / 2 on: randomDate.
	self
		assert: (container valuationOn: randomDate)
		closeTo: -12 + (1 / 2)
		precision: epsilon
]

{ #category : #'tests - income' }
ContainerTest >> testIncomeFloat [

	"Float capital"

	container addIncome: 0.1 on: randomDate.
	self
		assert: (container valuationOn: randomDate)
		closeTo: 1 / 10
		precision: epsilon
]

{ #category : #'tests - subcontainers' }
ContainerTest >> testIncomeIsSumOfSubcontainersIncomes [

	container addIncome: randomInteger1 on: randomDate.
	container1 addIncome: randomInteger2 on: randomDate.
	self
		assert: (container valuationWithSubcontainersOn: randomDate)
		equals: randomInteger1.
	self
		assert: (container1 valuationWithSubcontainersOn: randomDate)
		equals: randomInteger2.
	container addSubcontainer: container1.
	self
		assert: (container valuationWithSubcontainersOn: randomDate)
		equals: randomInteger1 + randomInteger2.
	self
		assert: (container1 valuationWithSubcontainersOn: randomDate)
		equals: randomInteger2.
	container removeSubcontainer: container1.
	self
		assert: (container valuationWithSubcontainersOn: randomDate)
		equals: randomInteger1.
	self
		assert: (container1 valuationWithSubcontainersOn: randomDate)
		equals: randomInteger2
]

{ #category : #'tests - income' }
ContainerTest >> testIncomeLargeInteger [

	self
		assert: (container addIncome: 123456789987654321e95 on: randomDate)
		closeTo: 123456789987654321e95
		precision: epsilon.
	self
		assert: (container valuationOn: randomDate)
		closeTo: 123456789987654321e95
		precision: epsilon
]

{ #category : #'tests - income' }
ContainerTest >> testIncomeNotNumbersBoolean [

	self assert: (container addIncome: true on: randomDate) equals: 0.
	self assert: (container valuationOn: randomDate) isZero
]

{ #category : #'tests - income' }
ContainerTest >> testIncomeNotNumbersInfinity [

	self
		assert: (container addIncome: Float infinity on: randomDate)
		equals: 0.
	self assert: (container valuationOn: randomDate) isZero
]

{ #category : #'tests - income' }
ContainerTest >> testIncomeNotNumbersNan [

	self
		assert: (container addIncome: Float nan on: randomDate)
		equals: 0.
	self assert: (container valuationOn: randomDate) isZero
]

{ #category : #'tests - income' }
ContainerTest >> testIncomeNotNumbersNil [

	self assert: (container addIncome: nil on: randomDate) equals: 0.
	self assert: (container valuationOn: randomDate) isZero
]

{ #category : #'tests - income' }
ContainerTest >> testIncomeNotNumbersString [

	self assert: (container addIncome: '12' on: randomDate) equals: 0.
	self assert: (container valuationOn: randomDate) isZero
]

{ #category : #'tests - subcontainers' }
ContainerTest >> testIncomeWithSubcontainers [

	container addIncome: randomInteger1 on: randomDate.
	container1 addIncome: randomInteger2 on: randomDate.
	container2 addIncome: randomFloat on: randomDate.
	container3 addIncome: randomInteger3 on: randomDate.
	container addSubcontainer: container2.
	container addSubcontainer: container1.
	container2 addSubcontainer: container3.
	container1 addSubcontainer: container3.
	self
		assert: (container valuationWithSubcontainersOn: randomDate)
		closeTo: randomInteger1 + randomInteger2 + randomInteger3
			+ randomFloat asMinimalDecimalFraction
]

{ #category : #'tests - subcontainers' }
ContainerTest >> testIncomeWithoutSubcontainers [

	container addIncome: randomInteger1 on: randomDate.
	container1 addIncome: randomInteger2 on: randomDate.
	self assert: (container valuationOn: randomDate) equals: randomInteger1.
	self assert: (container1 valuationOn: randomDate) equals: randomInteger2.
	container addSubcontainer: container1.
	self assert: (container valuationOn: randomDate) equals: randomInteger1.
	self assert: (container1 valuationOn: randomDate) equals: randomInteger2.
	container removeSubcontainer: container1.
	self assert: (container valuationOn: randomDate) equals: randomInteger1.
	self assert: (container1 valuationOn: randomDate) equals: randomInteger2
]

{ #category : #'tests - totalCapital' }
ContainerTest >> testIntegerTotalCapital1 [

	container addIncome: randomInteger1 on: randomDate.
	self assert: (container valuationOn: randomDate) equals: randomInteger1
]

{ #category : #'tests - totalCapital' }
ContainerTest >> testIntegerTotalCapital2 [

	container addIncome: randomInteger2 negated on: randomDate.
	self
		assert: (container valuationOn: randomDate)
		equals: randomInteger2 negated
]

{ #category : #tests }
ContainerTest >> testName [

	self assert: container name equals: ''.
	container name: 'test'.
	self assert: container name equals: 'test'.
	self assert: container printString equals: 'test (0)'.
	container name: Color yellow.
	self assert: container name equals: Color yellow
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
	subContainer2 addIncome: randomInteger1 on: randomDate.
	container1 addSubcontainer.
	container removeEmptySubcontainers.
	self assert: container subcontainers equals: { container2 }.
	self assert: container1 subcontainers isEmpty.
	self assert: subContainer2 subcontainers isEmpty.
	self assert: container2 subcontainers equals: { subContainer2 }
]

{ #category : #tests }
ContainerTest >> testReset [

	self assert: (container reset valuationOn: randomDate) equals: 0.
	self assert: container reset equals: container.
	container
		addIncome: 5 on: randomDate;
		reset.
	self assert: (container valuationOn: randomDate) equals: 0
]

{ #category : #'tests - moving' }
ContainerTest >> testSendTo [

	container addIncome: randomInteger1 on: (randomDate addDays: -1).
	self
		assert: (Container
				 move: randomInteger2
				 from: container
				 to: container1
				 on: randomDate)
		equals: randomInteger2.
	self
		assert: (container valuationOn: (randomDate addDays: -1))
		equals: randomInteger1.
	self
		assert: (container valuationOn: randomDate)
		equals: randomInteger1 - randomInteger2.
	self
		assert: (container1 valuationOn: (randomDate addDays: -1))
		equals: 0.
	self
		assert: (container1 valuationOn: randomDate)
		equals: randomInteger2
]

{ #category : #'tests - moving' }
ContainerTest >> testSendToSelf [

	container addIncome: randomInteger1 on: randomDate.
	self assert: (container valuationOn: randomDate) equals: randomInteger1.
	self
		assert: (Container
				 move: randomInteger2
				 from: container
				 to: container
				 on: randomDate)
		equals: randomInteger2.
	self assert: (container valuationOn: randomDate) equals: randomInteger1
]

{ #category : #'tests - moving' }
ContainerTest >> testSendToSubcontainer [

	container addIncome: randomInteger1 on: randomDate.
	container addSubcontainer: (container1
			 name: 'existing container';
			 yourself).
	self
		assert: (container
				 send: randomInteger2
				 toSubcontainerNamed: 'existing container'
				 on: randomDate)
		equals: randomInteger2.
	self
		assert: (container valuationOn: randomDate)
		equals: randomInteger1 - randomInteger2.
	self assert: (container1 valuationOn: randomDate) equals: randomInteger2.
	self
		assert: (container
				 send: randomInteger2
				 toSubcontainerNamed: 'new container'
				 on: randomDate)
		equals: randomInteger2.
	self
		assert: (container valuationOn: randomDate)
		equals: randomInteger1 - randomInteger2 - randomInteger2.
	self assert: (container1 valuationOn: randomDate) equals: randomInteger2.
	self
		assert:
		((container subcontainerNamed: 'new container') valuationOn: randomDate)
		equals: randomInteger2.
	container addSubcontainerNamed: 'existing container'.
	self
		should: [ 
			container
				send: randomInteger2
				toSubcontainerNamed: 'existing container'
				on: randomDate ]
		raise: Error
		whoseDescriptionIncludes: 'Ambiguous'
		description: '2 containers with the same name'
]

{ #category : #'tests - subcontainers' }
ContainerTest >> testShouldNotRemoveSubcontainersIfAnyIncomeIsNotZero [

	container addSubcontainer: container1.
	container1 addSubcontainer: container2.
	container1 addIncome: randomInteger1 on: randomDate.
	container2 addIncome: randomInteger1 negated on: randomDate.
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
