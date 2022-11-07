Class {
	#name : #Income,
	#superclass : #Object,
	#instVars : [
		'amount',
		'date'
	],
	#category : #'PersonalBank-Core'
}

{ #category : #testing }
Income class >> canUseAsAmount: anObject [
	"Chack that anObject can be stored into myself"

	^ anObject isNumber
		and: [ anObject isNaN not and: [ anObject isInfinite not ] ]
]

{ #category : #computing }
Income class >> exactValueFor: aNumber [
	"Converts floats to fractions to have an exact representation of them"

	^ (aNumber isFloat and: [ (aNumber isNil | aNumber isInfinite) not ])
		ifTrue: [ aNumber asMinimalDecimalFraction ]
		ifFalse: [ aNumber ]
]

{ #category : #'instance creation' }
Income class >> of: aNumber on: aDate [

	^ self new
		  amount: aNumber;
		  date: aDate;
		  yourself
]

{ #category : #accessing }
Income >> = anObject [

	^ self class = anObject class and: [ 
		  self date = anObject date and: [ self amount = anObject amount ] ]
]

{ #category : #accessing }
Income >> amount [

	^ amount
]

{ #category : #accessing }
Income >> amount: aNumber [

	amount := self class exactValueFor: aNumber
]

{ #category : #accessing }
Income >> date [

	^ date
]

{ #category : #accessing }
Income >> date: aDate [

	date := aDate translateToUTC
]

{ #category : #accessing }
Income >> hash [

	^ self amount hash bitXor: self date hash
]

{ #category : #initialization }
Income >> initialize [

	amount := 0.
	date := (Date fromSeconds: 0) translateToUTC
]

{ #category : #testing }
Income >> isEffectiveOn: aDate [

	^ self date <= aDate translateToUTC
]
