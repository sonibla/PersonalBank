Class {
	#name : #NoOperationType,
	#superclass : #AbstractOperationType,
	#category : #'PersonalBank-Core'
}

{ #category : #accessing }
NoOperationType class >> iconName [

	^ #empty
]

{ #category : #printing }
NoOperationType class >> printOn: aStream [

	aStream << ''
]
