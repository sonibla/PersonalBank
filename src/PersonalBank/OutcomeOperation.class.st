Class {
	#name : #OutcomeOperation,
	#superclass : #OperationTypeIncomeOutcome,
	#category : #'PersonalBank-Core'
}

{ #category : #accessing }
OutcomeOperation class >> iconName [

	^ #glamorousOver
]

{ #category : #accessing }
OutcomeOperation class >> isAbstract [

	^ false
]

{ #category : #testing }
OutcomeOperation class >> mayDecreaseTotalCapital [

	^ true
]

{ #category : #testing }
OutcomeOperation class >> mayIncreaseTotalCapital [

	^ false
]

{ #category : #printing }
OutcomeOperation class >> printOn: aStream [

	aStream << 'OUT'
]
