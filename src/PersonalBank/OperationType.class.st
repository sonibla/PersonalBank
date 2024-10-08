Class {
	#name : #OperationType,
	#superclass : #AbstractOperationType,
	#category : #'PersonalBank-Core'
}

{ #category : #testing }
OperationType class >> bankFieldOptional [

	^ self isTransfer
]

{ #category : #'instance creation' }
OperationType class >> fromJsonId: aString [

	^ self possibleTypes detect: [ :each | each jsonId = aString ]
]

{ #category : #testing }
OperationType class >> isTransfer [

	^ self isTransferBetweenBudgets or: [ self isTransferBetweenBanks ]
]

{ #category : #testing }
OperationType class >> isTransferBetweenBanks [

	self subclassResponsibility
]

{ #category : #testing }
OperationType class >> isTransferBetweenBudgets [

	self subclassResponsibility
]

{ #category : #printing }
OperationType class >> jsonId [

	self subclassResponsibility
]

{ #category : #testing }
OperationType class >> mayDecreaseTotalCapital [

	self subclassResponsibility
]

{ #category : #testing }
OperationType class >> mayIncreaseTotalCapital [

	self subclassResponsibility
]

{ #category : #'instance creation' }
OperationType class >> on: aDate change: anAssociation [

	^ self
		  on: aDate
		  from: anAssociation key key
		  to: anAssociation value
		  of: anAssociation key value
]

{ #category : #'instance creation' }
OperationType class >> on: aDate from: source to: destination of: amount [

	^ Operation new
		  type: self;
		  date: aDate;
		  source: source;
		  destination: destination;
		  amount: amount;
		  yourself
]
