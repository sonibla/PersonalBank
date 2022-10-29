"
For the Class part:  I represent anything that have money : an account, a vault, a transaction, a person...

For the Responsibility part: My responsibility is to remember the exact amount of money inside of me

For the Collaborators Part: I store my contents as a Number
"
Class {
	#name : #Container,
	#superclass : #Object,
	#instVars : [
		'income',
		'incomes',
		'subcontainers',
		'name'
	],
	#category : #'PersonalBank-Core'
}

{ #category : #testing }
Container class >> canStore: anObject [
	"Chack that anObject can be stored into myself"

	^ anObject isNumber
		and: [ anObject isNaN not and: [ anObject isInfinite not ] ]
]

{ #category : #computing }
Container class >> exactValueFor: aNumber [
	"Converts floats to fractions to have an exact representation of them"

	^ (aNumber isFloat and: [ (aNumber isNil | aNumber isInfinite) not ])
		ifTrue: [ aNumber asMinimalDecimalFraction ]
		ifFalse: [ aNumber ]
]

{ #category : #'adding/removing' }
Container class >> move: aNumber from: transmitterAccount to: receiverAccount [
	"Transfer funds between 2 containers"

	| bank sent |
	bank := self new.
	bank addIncome: (transmitterAccount addOutcome: aNumber).
	sent := bank addOutcome: (receiverAccount addIncome: bank income).
	bank addOutcome: (transmitterAccount addIncome: bank income).
	self assert: [ bank income isZero ].
	^ sent
]

{ #category : #'instance creation' }
Container class >> named: aString [

	^ self new
		  name: aString;
		  yourself
]

{ #category : #comparing }
Container >> = anObject [

	^ self totalIncome = anObject or: [ 
		  anObject class = self class and: [ 
			  self totalIncome = anObject totalIncome ] ]
]

{ #category : #'adding/removing' }
Container >> addIncome: aNumber [

	"Increment myself by aNumber"

	^ (self class canStore: aNumber)
		  ifTrue: [ 
			  | old |
			  old := self income.
			  self basicAddIncome: (self class exactValueFor: aNumber).
			  ^ self income - old ]
		  ifFalse: [ 0 ]
]

{ #category : #'adding/removing' }
Container >> addOutcome: aNumber [
	"Decrement myself by aNumber"

	^ (self class canStore: aNumber)
		ifTrue: [ (self addIncome: aNumber negated) negated ]
		ifFalse: [ 0 ]
]

{ #category : #'adding/removing' }
Container >> addSubcontainer [
	^ self addSubcontainer: self class new
]

{ #category : #'adding/removing' }
Container >> addSubcontainer: aContainer [

	subcontainers add: aContainer.
	^ aContainer
]

{ #category : #'adding/removing' }
Container >> addSubcontainerNamed: aString [

	^ self addSubcontainer: (self class named: aString)
]

{ #category : #'adding/removing' }
Container >> basicAddIncome: aNumber [

	incomes addLast: aNumber.
	income := income + aNumber
]

{ #category : #testing }
Container >> hasEmptySubcontainers [

	^ self subcontainers anySatisfy: #isEmpty
]

{ #category : #comparing }
Container >> hash [
	^ self totalIncome hash
]

{ #category : #accessing }
Container >> income [

	^ income
	"^ incomes ifEmpty: [ 0 ] ifNotEmpty: [ :list | list sum ]"
]

{ #category : #initialization }
Container >> initialize [
	super initialize.
	self reset
]

{ #category : #testing }
Container >> isEmpty [

	^ self totalIncome isZero and: [ self income isZero ]
]

{ #category : #accessing }
Container >> name [
	^ name
]

{ #category : #accessing }
Container >> name: aString [
	name := aString
]

{ #category : #accessing }
Container >> outcome [
	"Capital, negated"

	^ self income negated
]

{ #category : #printing }
Container >> printOn: aStream [

	self printStringTabulatedBy: 1 on: aStream
]

{ #category : #printing }
Container >> printStringTabulatedBy: tabulations on: aStream [

	self name
		ifNil: [ super printOn: aStream ]
		ifNotNil: [ aStream nextPutAll: self name ].
	aStream
		nextPutAll: ' (';
		nextPutAll: self rounded asString;
		nextPutAll: (self subcontainers isEmpty
				 ifTrue: [ ')' ]
				 ifFalse: [ ', ' , self roundedTotal asString , ' in total)' ]).
	self subContainersPrintStringTabulatedBy: tabulations on: aStream
]

{ #category : #accessing }
Container >> recursiveSubcontainerNamed: aString [

	^ self uniqueElementOf:
		  ((self recursiveSubcontainersNamed: aString) ifEmpty: [ 
			   { (self addSubcontainerNamed: aString) } ])
]

{ #category : #accessing }
Container >> recursiveSubcontainers [
	| set |
	set := IdentitySet new.
	set add: self.
	self recursiveSubcontainersCollectInto: set.
	^ set
]

{ #category : #accessing }
Container >> recursiveSubcontainersCollectInto: aCollection [
	self subcontainers
		reject: [ :each | aCollection includes: each ]
		thenDo: [ :each | each recursiveSubcontainersCollectInto: aCollection ].
	aCollection addAll: self subcontainers
]

{ #category : #accessing }
Container >> recursiveSubcontainersNamed: aString [
	^ self recursiveSubcontainers select: [ :each | each name = aString ]
]

{ #category : #accessing }
Container >> recursiveSubcontainersWithoutSelf [

	| set |
	set := IdentitySet new.
	self recursiveSubcontainersCollectInto: set.
	^ set
]

{ #category : #'adding/removing' }
Container >> removeEmptySubcontainers [

	self subcontainers do: #removeEmptySubcontainers.
	subcontainers removeAllSuchThat: #isEmpty
]

{ #category : #'adding/removing' }
Container >> removeSubcontainer: aContainer [
	^ subcontainers remove: aContainer ifAbsent: [ ^ nil ]
]

{ #category : #initialization }
Container >> reset [

	incomes := OrderedCollection new.
	income := 0.
	subcontainers := IdentitySet new
]

{ #category : #printing }
Container >> rounded [
	| rounded |
	rounded := self income asFloat round: 2.
	^ rounded = rounded asInteger
		ifTrue: [ rounded asInteger ]
		ifFalse: [ rounded ]
]

{ #category : #printing }
Container >> roundedTotal [
	| rounded |
	rounded := self totalIncome asFloat round: 2.
	^ rounded = rounded asInteger
		ifTrue: [ rounded asInteger ]
		ifFalse: [ rounded ]
]

{ #category : #moving }
Container >> send: aNumber to: aContainer [
	^ self class move: aNumber from: self to: aContainer
]

{ #category : #moving }
Container >> send: aNumber toSubcontainerNamed: aString [

	^ self send: aNumber to: (self subcontainerNamed: aString)
]

{ #category : #printing }
Container >> subContainersPrintStringTabulatedBy: tabulations on: aStream [

	self subcontainers do: [ :each | 
		aStream cr.
		tabulations timesRepeat: [ aStream tab ].
		each printStringTabulatedBy: tabulations + 1 on: aStream ]
]

{ #category : #accessing }
Container >> subcontainerNamed: aString [

	^ self uniqueElementOf:
		  ((self subcontainersNamed: aString) ifEmpty: [ 
			   { (self addSubcontainerNamed: aString) } ])
]

{ #category : #accessing }
Container >> subcontainers [
	^ subcontainers asArray
		sorted: [ :a :b | a totalIncome > b totalIncome ]
]

{ #category : #accessing }
Container >> subcontainersNamed: aString [
	^ self subcontainers select: [ :each | each name = aString ]
]

{ #category : #accessing }
Container >> subcontainersTree [

	^ self
	  ->
	  (self subcontainers collect: [ :each | each subcontainersTree ])
		  asSet
]

{ #category : #accessing }
Container >> totalIncome [
	"Current capital"

	^ (self recursiveSubcontainers sum: #income)
]

{ #category : #accessing }
Container >> uniqueElementOf: aCollection [

	aCollection size > 1 ifTrue: [ self error: 'Ambiguous' ].
	aCollection isEmpty ifTrue: [ self error: 'Empty' ].
	^ aCollection anyOne
]
