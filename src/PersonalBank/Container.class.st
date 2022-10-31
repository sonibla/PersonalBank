"
For the Class part:  I represent anything that have money : an account, a vault, a transaction, a person...

For the Responsibility part: My responsibility is to remember the exact amount of money inside of me

For the Collaborators Part: I store my contents as a Number
"
Class {
	#name : #Container,
	#superclass : #MoneyStorage,
	#instVars : [
		'incomes',
		'subcontainers',
		'name'
	],
	#category : #'PersonalBank-Core'
}

{ #category : #'instance creation' }
Container class >> named: aString [

	^ self new
		  name: aString;
		  yourself
]

{ #category : #comparing }
Container >> = anObject [

	^ anObject class = self class and: [ 
		  self incomesList asSet = anObject incomesList asSet ]
]

{ #category : #'adding/removing' }
Container >> addIncome: aNumber on: aDate [

	^ incomes addIncome: aNumber on: aDate
]

{ #category : #'adding/removing' }
Container >> addOutcome: aNumber on: aDate [

	^ incomes addOutcome: aNumber on: aDate
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

{ #category : #testing }
Container >> hasEmptySubcontainers [

	^ self subcontainers anySatisfy: #isEmpty
]

{ #category : #comparing }
Container >> hash [

	^ self incomesList asSet hash
]

{ #category : #accessing }
Container >> incomesList [

	^ incomes incomesList
]

{ #category : #initialization }
Container >> initialize [

	super initialize.
	name := ''.
	self reset
]

{ #category : #testing }
Container >> isEmpty [

	^ self recursiveSubcontainers allSatisfy: #noIncomes
]

{ #category : #accessing }
Container >> name [
	^ name
]

{ #category : #accessing }
Container >> name: aString [
	name := aString
]

{ #category : #testing }
Container >> noIncomes [

	^ incomes isEmpty
]

{ #category : #printing }
Container >> printOn: aStream [

	self printValuationOn: Date today onStream: aStream
]

{ #category : #printing }
Container >> printStringTabulatedBy: tabulations on: aDate onStream: aStream [

	self name
		ifNil: [ super printOn: aStream ]
		ifNotNil: [ aStream nextPutAll: self name ].
	aStream
		nextPutAll: ' (';
		nextPutAll: (self roundedValuationOn: aDate) asString;
		nextPutAll: (self subcontainers isEmpty
				 ifTrue: [ ')' ]
				 ifFalse: [ 
					 ', '
					 , (self roundedValuationWithSubcontainersOn: aDate) asString
					 , ' in total)' ]).
	self
		subContainersPrintStringTabulatedBy: tabulations
		on: aDate
		onStream: aStream
]

{ #category : #printing }
Container >> printValuationOn: aDate onStream: aStream [

	self printStringTabulatedBy: 1 on: aDate onStream: aStream
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

	incomes := IncomeCollection new.
	subcontainers := IdentitySet new
]

{ #category : #printing }
Container >> roundedValuationWithSubcontainersOn: aDate [

	| rounded |
	rounded := (self valuationWithSubcontainersOn: aDate) asFloat round:
		           2.
	^ rounded = rounded asInteger
		  ifTrue: [ rounded asInteger ]
		  ifFalse: [ rounded ]
]

{ #category : #moving }
Container >> send: aNumber toSubcontainerNamed: aString on: aDate [

	^ self send: aNumber to: (self subcontainerNamed: aString) on: aDate
]

{ #category : #printing }
Container >> subContainersPrintStringTabulatedBy: tabulations on: aDate onStream: aStream [

	self subcontainers do: [ :each | 
		aStream cr.
		tabulations timesRepeat: [ aStream tab ].
		each
			printStringTabulatedBy: tabulations + 1
			on: aDate
			onStream: aStream ]
]

{ #category : #accessing }
Container >> subcontainerNamed: aString [

	^ self uniqueElementOf:
		  ((self subcontainersNamed: aString) ifEmpty: [ 
			   { (self addSubcontainerNamed: aString) } ])
]

{ #category : #accessing }
Container >> subcontainers [

	^ subcontainers asArray sorted: [ :a :b | a name > b name ]
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
Container >> uniqueElementOf: aCollection [

	aCollection size > 1 ifTrue: [ self error: 'Ambiguous' ].
	aCollection isEmpty ifTrue: [ self error: 'Empty' ].
	^ aCollection anyOne
]

{ #category : #accessing }
Container >> valuationOn: aDate [

	^ incomes valuationOn: aDate
]

{ #category : #accessing }
Container >> valuationWithSubcontainersOn: aDate [

	^ self recursiveSubcontainers sum: [ :each | each valuationOn: aDate ]
]
