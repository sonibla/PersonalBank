Class {
	#name : #OperationTypeIncomeOutcome,
	#superclass : #OperationType,
	#category : #'PersonalBank-Core'
}

{ #category : #testing }
OperationTypeIncomeOutcome class >> isTransferBetweenBanks [

	^ false
]

{ #category : #testing }
OperationTypeIncomeOutcome class >> isTransferBetweenBudgets [

	^ false
]

{ #category : #'instance creation' }
OperationTypeIncomeOutcome class >> on: aDate change: anAssociation bank: bank [

	^ (self on: aDate change: anAssociation)
		  bank: bank;
		  yourself
]

{ #category : #'instance creation' }
OperationTypeIncomeOutcome class >> on: aDate from: source to: destination of: amount bank: bank [

	^ (self
		   on: aDate
		   from: source
		   to: destination
		   of: amount)
		  bank: bank;
		  yourself
]
