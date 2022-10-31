Class {
	#name : #MoneyStorage,
	#superclass : #Object,
	#category : #'PersonalBank-Core'
}

{ #category : #'adding/removing' }
MoneyStorage class >> move: aNumber from: transmitterAccount to: receiverAccount on: aDate [

	"Transfer funds between 2 containers"

	| bank sent |
	bank := self new.
	bank
		addIncome: (transmitterAccount addOutcome: aNumber on: aDate)
		on: aDate.
	sent := bank
		        addOutcome:
		        (receiverAccount addIncome: (bank valuationOn: aDate) on: aDate)
		        on: aDate.
	bank
		addOutcome:
		(transmitterAccount addIncome: (bank valuationOn: aDate) on: aDate)
		on: aDate.
	self assert: [ (bank valuationOn: aDate) isZero ].
	^ sent
]

{ #category : #adding }
MoneyStorage >> addIncome: aNumber on: aDate [

	self subclassResponsibility
]

{ #category : #adding }
MoneyStorage >> addOutcome: aNumber on: aDate [

	self subclassResponsibility
]

{ #category : #testing }
MoneyStorage >> isEmpty [

	self subclassResponsibility
]

{ #category : #accessing }
MoneyStorage >> roundedValuationOn: aDate [

	| rounded |
	rounded := (self valuationOn: aDate) asFloat round: 2.
	^ rounded = rounded asInteger
		  ifTrue: [ rounded asInteger ]
		  ifFalse: [ rounded ]
]

{ #category : #moving }
MoneyStorage >> send: aNumber to: aContainer on: aDate [

	^ self class
		  move: aNumber
		  from: self
		  to: aContainer
		  on: aDate
]

{ #category : #accessing }
MoneyStorage >> valuationOn: aDate [

	self subclassResponsibility
]
