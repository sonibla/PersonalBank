Class {
	#name : #IncomeOperation,
	#superclass : #OperationTypeIncomeOutcome,
	#category : #'PersonalBank-Core'
}

{ #category : #accessing }
IncomeOperation class >> iconName [

	^ #glamorousInto
]

{ #category : #accessing }
IncomeOperation class >> isAbstract [

	^ false
]

{ #category : #printing }
IncomeOperation class >> jsonId [

	^ 'IN'
]

{ #category : #testing }
IncomeOperation class >> mayDecreaseTotalCapital [

	^ false
]

{ #category : #testing }
IncomeOperation class >> mayIncreaseTotalCapital [

	^ true
]

{ #category : #printing }
IncomeOperation class >> printOn: aStream [

	aStream << 'IN'
]
