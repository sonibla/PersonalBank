Class {
	#name : #CapitalDiagramPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'accounter',
		'bankDiagram',
		'budgetDiagram',
		'budgetCapitalDiagram',
		'bankCapitalDiagram',
		'shouldShowAmounts'
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

{ #category : #accessing }
CapitalDiagramPresenter >> bankCapitalDiagram [

	^ bankCapitalDiagram ifNil: [ self defaultCanvasForError: false ]
]

{ #category : #accessing }
CapitalDiagramPresenter >> bankCapitalDiagram: anObject [

	bankCapitalDiagram := anObject
]

{ #category : #accessing }
CapitalDiagramPresenter >> budgetCapitalDiagram [

	^ budgetCapitalDiagram ifNil: [ self defaultCanvasForError: false ]
]

{ #category : #accessing }
CapitalDiagramPresenter >> budgetCapitalDiagram: anObject [

	budgetCapitalDiagram := anObject
]

{ #category : #accessing }
CapitalDiagramPresenter >> defaultCanvasForError: error [

	| canvas |
	canvas := RSCanvas new
		          color: self theme backgroundColor;
		          yourself.
	error ifTrue: [ 
		canvas add: ((RSLabel text: 'Error while generating diagram')
				 color: self theme dangerTextColor;
				 yourself) ].
	^ canvas
]

{ #category : #utilities }
CapitalDiagramPresenter >> generateBankCapitalDiagram [

	^ [ 
	  (BankCapitalDiagram onContainer: accounter processor banks)
		  shouldShowAmounts: shouldShowAmounts;
		  build;
		  canvas ]
		  on: Error
		  do: [ self defaultCanvasForError: true ]
]

{ #category : #utilities }
CapitalDiagramPresenter >> generateBudgetCapitalDiagram [

	^ [ 
	  (BudgetCapitalDiagram onContainer: accounter processor budgets)
		  shouldShowAmounts: shouldShowAmounts;
		  build;
		  canvas ]
		  on: Error
		  do: [ self defaultCanvasForError: true ]
]

{ #category : #initialization }
CapitalDiagramPresenter >> initialize [

	super initialize.
	shouldShowAmounts := false
]

{ #category : #initialization }
CapitalDiagramPresenter >> initializePresenters [

	accounter ifNil: [ accounter := Accounter new ].
	bankDiagram := self instantiate: SpRoassalPresenter.
	budgetDiagram := self instantiate: SpRoassalPresenter.
]

{ #category : #updating }
CapitalDiagramPresenter >> regerenateDiagrams [

	self bankCapitalDiagram: self generateBankCapitalDiagram.
	self budgetCapitalDiagram: self generateBudgetCapitalDiagram.
	budgetDiagram canvas: budgetCapitalDiagram.
	bankDiagram canvas: bankCapitalDiagram.
	self update
]

{ #category : #initialization }
CapitalDiagramPresenter >> setAccounter: anAccounter [

	anAccounter == accounter ifTrue: [ ^ self ].
	accounter ifNotNil: [ accounter removeDependent: self ].
	accounter := anAccounter.
	accounter addDependent: self.
	self regerenateDiagrams
]

{ #category : #accessing }
CapitalDiagramPresenter >> shouldShowAmounts [

	^ shouldShowAmounts
]

{ #category : #accessing }
CapitalDiagramPresenter >> shouldShowAmounts: anObject [

	shouldShowAmounts := anObject.
	self regerenateDiagrams
]

{ #category : #updating }
CapitalDiagramPresenter >> update: aSymbol [

	aSymbol = #processingFinished ifTrue: [ self regerenateDiagrams ]
]
