Class {
	#name : #Operation,
	#superclass : #Model,
	#instVars : [
		'type',
		'date',
		'source',
		'amount',
		'destination',
		'bank'
	],
	#category : #'PersonalBank-Core'
}

{ #category : #'instance creation' }
Operation class >> dummy [

	^ self new
		  source: '';
		  bank: '';
		  date: Date today translateToUTC;
		  amount: 0;
		  destination: '';
		  type: OutcomeOperation;
		  yourself
]

{ #category : #comparing }
Operation >> = anOperation [

	^ anOperation class = self class and: [ 
		  anOperation amount = amount and: [ 
			  anOperation bank = bank and: [ 
				  anOperation date = date and: [ 
					  anOperation destination = destination and: [ 
						  anOperation source = source and: [ anOperation type = type ] ] ] ] ] ]
]

{ #category : #accessing }
Operation >> amount [

	^ amount
]

{ #category : #accessing }
Operation >> amount: anObject [

	self setInstVarNamed: #amount to: anObject
]

{ #category : #accessing }
Operation >> bank [

	^ bank
]

{ #category : #accessing }
Operation >> bank: anObject [

	self setInstVarNamed: #bank to: anObject
]

{ #category : #copying }
Operation >> copy [

	^ self class new
		  amount: amount copy;
		  bank: bank copy;
		  date: date copy;
		  destination: destination copy;
		  source: source copy;
		  type: type;
		  yourself
]

{ #category : #accessing }
Operation >> date [

	^ date
]

{ #category : #accessing }
Operation >> date: anObject [

	self setInstVarNamed: #date to: anObject
]

{ #category : #accessing }
Operation >> destination [

	^ destination
]

{ #category : #accessing }
Operation >> destination: anObject [

	self setInstVarNamed: #destination to: anObject
]

{ #category : #comparing }
Operation >> hash [

	^ amount hash bitXor: (bank hash bitXor: (date hash bitXor:
				    (destination hash bitXor: (source hash bitXor: type hash))))
]

{ #category : #testing }
Operation >> makesSense [

	^ amount isNumber and: [ 
		  destination isString and: [ 
			  source isString and: [ 
				  destination notEmpty and: [ 
					  source notEmpty and: [ 
						  (OperationType possibleTypes includes: type) and: [ 
							  date class = Date and: [ 
								  type bankFieldOptional or: [ 
									  bank isString and: [ bank notEmpty ] ] ] ] ] ] ] ] ]
]

{ #category : #printing }
Operation >> printAmountOn: aStream [

	amount ifNotNil: [ 
		aStream << ' of '.
		amount printOn: aStream ]
]

{ #category : #printing }
Operation >> printBankOn: aStream [

	bank ifNotNil: [ 
		aStream << ' in bank '.
		bank displayStringOn: aStream ]
]

{ #category : #printing }
Operation >> printDateOn: aStream [

	date ifNotNil: [ 
		aStream << ' effective on '.
		date printOn: aStream ].
]

{ #category : #printing }
Operation >> printDestinationOn: aStream [

	destination ifNotNil: [ 
		aStream << ' to '.
		destination displayStringOn: aStream ].
]

{ #category : #printing }
Operation >> printOn: aStream [

	aStream << 'Operation'.
	self
		printTypeOn: aStream;
		printAmountOn: aStream;
		printSourceOn: aStream;
		printDestinationOn: aStream;
		printDateOn: aStream;
		printBankOn: aStream
]

{ #category : #printing }
Operation >> printSourceOn: aStream [

	source ifNotNil: [ 
		aStream << ' from '.
		source displayStringOn: aStream ].
]

{ #category : #printing }
Operation >> printTypeOn: aStream [

	type ifNotNil: [ 
		aStream << ' ('.
		type printOn: aStream.
		aStream << ')' ]
]

{ #category : #private }
Operation >> setInstVarNamed: instVarName to: anObject [

	"I know, it's ugly. I did this to avoid code duplication"

	| unChanged instVarValue |
	instVarValue := self instVarNamed: instVarName.
	unChanged := anObject = instVarValue.
	self instVarNamed: instVarName put: anObject.
	unChanged ifFalse: [ self changed: instVarName ]
]

{ #category : #accessing }
Operation >> source [

	^ source
]

{ #category : #accessing }
Operation >> source: anObject [

	self setInstVarNamed: #source to: anObject
]

{ #category : #accessing }
Operation >> type [

	^ type
]

{ #category : #accessing }
Operation >> type: anObject [

	self setInstVarNamed: #type to: anObject
]
