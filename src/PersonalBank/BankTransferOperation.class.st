Class {
	#name : #BankTransferOperation,
	#superclass : #OperationTypeTransfer,
	#category : #'PersonalBank-Core'
}

{ #category : #accessing }
BankTransferOperation class >> iconName [

	^ #diff
]

{ #category : #accessing }
BankTransferOperation class >> isAbstract [

	^ false
]

{ #category : #testing }
BankTransferOperation class >> isTransferBetweenBanks [

	^ true
]

{ #category : #testing }
BankTransferOperation class >> isTransferBetweenBudgets [

	^ false
]

{ #category : #printing }
BankTransferOperation class >> printOn: aStream [

	aStream << 'BK-TR'
]
