Class {
	#name : #BudgetTransfersDiagramPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'accounter',
		'budgetTransfersDiagram'
	],
	#category : #'PersonalBank-GUI'
}

{ #category : #layout }
BudgetTransfersDiagramPresenter class >> defaultLayout [

	^ SpBoxLayout newLeftToRight
		  add: #budgetTransfersDiagram;
		  yourself
]

{ #category : #updating }
BudgetTransfersDiagramPresenter >> initializePresenters [

	accounter ifNil: [ accounter := Accounter new ].
	budgetTransfersDiagram := self instantiate: SpRoassalPresenter
]

{ #category : #updating }
BudgetTransfersDiagramPresenter >> setAccounter: anAccounter [

	anAccounter == accounter ifTrue: [ ^ self ].
	accounter ifNotNil: [ accounter removeDependent: self ].
	accounter := anAccounter.
	accounter addDependent: self.
	self update: #budgetTransfersDiagram
]

{ #category : #updating }
BudgetTransfersDiagramPresenter >> update: aSymbol [

	aSymbol = #budgetTransfersDiagram ifTrue: [ 
		budgetTransfersDiagram canvas: accounter budgetTransfersDiagram.
		self update ]
]
