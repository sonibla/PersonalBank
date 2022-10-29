Class {
	#name : #AccounterSynchronizerPresenterTest,
	#superclass : #AbstractAccountingTest,
	#instVars : [
		'synchronizer',
		'presenter',
		'window'
	],
	#category : #'PersonalBank-Tests-GUI'
}

{ #category : #running }
AccounterSynchronizerPresenterTest >> setUp [

	super setUp.
	presenter := AccounterSynchronizerPresenter new 
		             setAccounterSynchronizer:
		             self dummyAccounterSynchronizer.
	window := presenter open
]

{ #category : #running }
AccounterSynchronizerPresenterTest >> tearDown [

	window close.
	super tearDown
]

{ #category : #running }
AccounterSynchronizerPresenterTest >> testAutosaveButton [

	self deny: self dummyAccounterSynchronizer autosave.
	self deny: presenter autosaveButton state.
	self dummyAccounterSynchronizer autosave: true.
	self assert: self dummyAccounterSynchronizer autosave.
	self assert: presenter autosaveButton state
]

{ #category : #running }
AccounterSynchronizerPresenterTest >> testFilenameLabel [

	self assert: presenter filenameLabel text equals: ''.
	self dummyAccounterSynchronizer filename: self filenameForTesting.
	self
		assert: presenter filenameLabel text
		equals: self filenameForTesting
]

{ #category : #running }
AccounterSynchronizerPresenterTest >> testSanityIssuesString [

	| operationToEdit |
	self assert: presenter sanityIssuesString equals: ''.
	operationToEdit := self dummyAccounter operations detect: [ :each | 
		                   each = (BudgetTransferOperation
			                    on: (Date newDay: 4 month: 1 year: 2000)
			                    change: 'Budget1' -> 500 -> 'Budget1-SubA') ].
	operationToEdit amount: 400.
	self assert: presenter sanityIssuesString equals: 'partialSplits
'.
	operationToEdit := self dummyAccounter operations detect: [ :each | 
		                   each = (BankTransferOperation
			                    on: (Date newDay: 3 month: 1 year: 2000)
			                    change: 'Bank1' -> 420 -> 'Bank2') ].
	operationToEdit amount: 3000.
	self assert: presenter sanityIssuesString equals: 'negativeCapitals
partialSplits
'.
	operationToEdit := self dummyAccounter operations detect: [ :each | 
		                   each = (BudgetTransferOperation
			                    on: (Date newDay: 4 month: 1 year: 2000)
			                    change: 'Budget1' -> 400 -> 'Budget1-SubA') ].
	operationToEdit amount: 500.
	self assert: presenter sanityIssuesString equals: 'negativeCapitals
'
]
