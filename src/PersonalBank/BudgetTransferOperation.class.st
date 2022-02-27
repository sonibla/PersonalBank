Class {
	#name : #BudgetTransferOperation,
	#superclass : #OperationTypeTransfer,
	#category : #'PersonalBank-Core'
}

{ #category : #accessing }
BudgetTransferOperation class >> iconName [

	^ #publish
]

{ #category : #accessing }
BudgetTransferOperation class >> isAbstract [

	^ false
]

{ #category : #testing }
BudgetTransferOperation class >> isTransferBetweenBanks [

	^ false
]

{ #category : #testing }
BudgetTransferOperation class >> isTransferBetweenBudgets [

	^ true
]

{ #category : #printing }
BudgetTransferOperation class >> jsonId [

	^ 'BG-TR'
]

{ #category : #printing }
BudgetTransferOperation class >> printOn: aStream [

	aStream << 'Budget'
]
