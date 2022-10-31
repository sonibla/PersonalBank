Class {
	#name : #AbstractAccountingTest,
	#superclass : #TestCase,
	#instVars : [
		'dummyAccounter',
		'emptyAccounter',
		'dummyAccounterSynchronizer',
		'emptyAccounterSynchronizer'
	],
	#category : #'PersonalBank-Tests-Core'
}

{ #category : #utilities }
AbstractAccountingTest >> accounter [

	^ emptyAccounter ifNil: [ emptyAccounter := Accounter new ]
]

{ #category : #utilities }
AbstractAccountingTest >> dummyAccounter [

	^ dummyAccounter ifNil: [ 
		  dummyAccounter := Accounter onOperations: self dummyOperations ]
]

{ #category : #utilities }
AbstractAccountingTest >> dummyAccounterSynchronizer [

	^ dummyAccounterSynchronizer ifNil: [ 
		  dummyAccounterSynchronizer := AccounterSynchronizer onAccounter:
			                                self dummyAccounter ]
]

{ #category : #utilities }
AbstractAccountingTest >> dummyBankTransferOf: aNumber [

	^ BankTransferOperation
		  on: (Date newDay: 01 month: 01 year: 2000) translateToUTC
		  change: 'Bank3' -> aNumber -> 'Bank4'
]

{ #category : #utilities }
AbstractAccountingTest >> dummyBudgetTransferOf: aNumber [

	^ BudgetTransferOperation
		  on: (Date newDay: 04 month: 01 year: 2000) translateToUTC
		  change: 'Source4' -> aNumber -> 'Destination4'
]

{ #category : #utilities }
AbstractAccountingTest >> dummyIncomeOf: aNumber [

	^ IncomeOperation
		  on: (Date newDay: 03 month: 01 year: 2000) translateToUTC
		  change: 'Source2' -> aNumber -> 'Destination2'
		  bank: 'Bank2'
]

{ #category : #utilities }
AbstractAccountingTest >> dummyOperations [

	^ { 
		  (IncomeOperation
			   on: (Date newDay: 1 month: 1 year: 2000) translateToUTC
			   change: 'Source1' -> 1000 -> 'Budget1'
			   bank: 'Bank1').
		  (IncomeOperation
			   on: (Date newDay: 2 month: 1 year: 2000) translateToUTC
			   change: 'Source2' -> 1200 -> 'Budget1'
			   bank: 'Bank2').
		  (OutcomeOperation
			   on: (Date newDay: 2 month: 1 year: 2000) translateToUTC
			   change: 'Budget1' -> 200 -> 'Destination1'
			   bank: 'Bank1').
		  (BankTransferOperation
			   on: (Date newDay: 3 month: 1 year: 2000) translateToUTC
			   change: 'Bank1' -> 420 -> 'Bank2').
		  (BudgetTransferOperation
			   on: (Date newDay: 4 month: 1 year: 2000) translateToUTC
			   change: 'Budget1' -> 500 -> 'Budget1-SubA').
		  (BankTransferOperation
			   on: (Date newDay: 3 month: 1 year: 2000) translateToUTC
			   change: 'Bank1' -> 90 -> 'Bank3').
		  (IncomeOperation
			   on: (Date newDay: 1 month: 1 year: 2000) translateToUTC
			   change: 'Source3' -> 1000 -> 'Budget2'
			   bank: 'Bank1').
		  (BudgetTransferOperation
			   on: (Date newDay: 4 month: 1 year: 2000) translateToUTC
			   change: 'Budget1' -> 600 -> 'Budget1-SubB').
		  (BudgetTransferOperation
			   on: (Date newDay: 4 month: 1 year: 2000) translateToUTC
			   change: 'Budget1' -> 900 -> 'Budget1-SubC').
		  (OutcomeOperation
			   on: (Date newDay: 7 month: 1 year: 2000) translateToUTC
			   change: 'Budget1-SubB' -> 52 -> 'Destination2'
			   bank: 'Bank1') }
]

{ #category : #utilities }
AbstractAccountingTest >> dummyOutcomeOf: aNumber [

	^ OutcomeOperation
		  on: (Date newDay: 02 month: 01 year: 2000) translateToUTC
		  change: 'Source1' -> aNumber -> 'Destination1'
		  bank: 'Bank1'
]

{ #category : #utilities }
AbstractAccountingTest >> emptyAccounter [

	^ emptyAccounter ifNil: [ emptyAccounter := Accounter new ]
]

{ #category : #utilities }
AbstractAccountingTest >> emptyAccounterSynchronizer [

	^ emptyAccounterSynchronizer ifNil: [ 
		  emptyAccounterSynchronizer := AccounterSynchronizer onAccounter:
			                                self emptyAccounter ]
]

{ #category : #running }
AbstractAccountingTest >> filenameForTesting [

	^ './accounter-test-file.json'
]
