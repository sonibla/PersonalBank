Class {
	#name : #CapitalDiagramPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'accounter',
		'bankDiagram',
		'budgetDiagram'
	],
	#category : #'PersonalBank-GUI'
}

{ #category : #layout }
CapitalDiagramPresenter class >> defaultLayout [

	^ SpPanedLayout newLeftToRight
		  positionOfSlider: 0.7;
		  add: #budgetDiagram;
		  add: #bankDiagram ;
		  yourself
]

{ #category : #initialization }
CapitalDiagramPresenter >> initializePresenters [

	accounter ifNil: [ accounter := Accounter new ].
	bankDiagram := self instantiate: SpRoassalPresenter.
	budgetDiagram := self instantiate: SpRoassalPresenter.
]

{ #category : #initialization }
CapitalDiagramPresenter >> setAccounter: anAccounter [

	anAccounter == accounter ifTrue: [ ^ self ].
	accounter ifNotNil: [ accounter removeDependent: self ].
	accounter := anAccounter.
	accounter addDependent: self.
	self update: #budgetCapitalDiagram.
	self update: #bankCapitalDiagram
]

{ #category : #updating }
CapitalDiagramPresenter >> update: aSymbol [

	aSymbol = #budgetCapitalDiagram ifTrue: [ 
		budgetDiagram canvas: accounter budgetCapitalDiagram.
		self update ].
	aSymbol = #bankCapitalDiagram ifTrue: [ 
		bankDiagram canvas: accounter bankCapitalDiagram.
		self update ]
]
