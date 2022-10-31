Class {
	#name : #AbstractContainersTest,
	#superclass : #TestCase,
	#instVars : [
		'epsilon',
		'randomPositive',
		'randomNegative',
		'randomInteger1',
		'randomInteger2',
		'randomInteger3',
		'randomFloat',
		'hugeInteger',
		'randomDate',
		'randomDate2'
	],
	#category : #'PersonalBank-Tests-Core'
}

{ #category : #initialization }
AbstractContainersTest >> setUp [

	super setUp.
	randomFloat := SharedRandom globalGenerator next.
	randomDate := Date fromSeconds: (SharedRandom globalGenerator nextInteger: 5000000000).
	randomDate2 := Date fromSeconds: (SharedRandom globalGenerator nextInteger: 5000000000).
	randomInteger1 := 1 + (SharedRandom globalGenerator nextInteger: 100).
	randomInteger2 := 1 + (SharedRandom globalGenerator nextInteger: 100).
	randomInteger3 := 1 + (SharedRandom globalGenerator nextInteger: 100).
	epsilon := 1.0e-50.
	randomPositive := 1 + SharedRandom globalGenerator next.
	randomNegative := (1 + SharedRandom globalGenerator next) negated.
	hugeInteger := 1e999
]
