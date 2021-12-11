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
		  date: Date today;
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

	| unChanged |
	unChanged := anObject = amount.
	amount := anObject.
	unChanged ifFalse: [ self changed: #amount ]
]

{ #category : #accessing }
Operation >> bank [

	^ bank
]

{ #category : #accessing }
Operation >> bank: anObject [

	| unChanged |
	unChanged := anObject = bank.
	bank := anObject.
	unChanged ifFalse: [ self changed: #bank ]
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

	| unChanged |
	unChanged := anObject = date.
	date := anObject.
	unChanged ifFalse: [ self changed: #date ]
]

{ #category : #accessing }
Operation >> destination [

	^ destination
]

{ #category : #accessing }
Operation >> destination: anObject [

	| unChanged |
	unChanged := anObject = destination.
	destination := anObject.
	unChanged ifFalse: [ self changed: #destination ]
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

{ #category : #accessing }
Operation >> source [

	^ source
]

{ #category : #accessing }
Operation >> source: anObject [

	| unChanged |
	unChanged := anObject = source.
	source := anObject.
	unChanged ifFalse: [ self changed: #source ]
]

{ #category : #accessing }
Operation >> type [

	^ type
]

{ #category : #accessing }
Operation >> type: anObject [

	| unChanged |
	unChanged := anObject = type.
	type := anObject.
	unChanged ifFalse: [ self changed: #type ]
]
