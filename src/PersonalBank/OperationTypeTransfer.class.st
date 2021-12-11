Class {
	#name : #OperationTypeTransfer,
	#superclass : #OperationType,
	#category : #'PersonalBank-Core'
}

{ #category : #testing }
OperationTypeTransfer class >> mayDecreaseTotalCapital [

	^ false
]

{ #category : #testing }
OperationTypeTransfer class >> mayIncreaseTotalCapital [

	^ false
]
