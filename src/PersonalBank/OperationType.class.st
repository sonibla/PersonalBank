Class {
	#name : #OperationType,
	#superclass : #Object,
	#category : #'PersonalBank-Core'
}

{ #category : #testing }
OperationType class >> bankFieldOptional [

	^ self isTransfer
]

{ #category : #'instance creation' }
OperationType class >> fromString: aString [

	^ self possibleTypes detect: [ :each | each printString = aString ]
]

{ #category : #accessing }
OperationType class >> icon [

	^ Smalltalk ui theme iconNamed: self iconName
]

{ #category : #accessing }
OperationType class >> iconName [

	self subclassResponsibility
]

{ #category : #accessing }
OperationType class >> isAbstract [

	^ true
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

{ #category : #accessing }
OperationType class >> possibleTypes [

	^ self allSubclasses reject: [ :each | each isAbstract ]
]
