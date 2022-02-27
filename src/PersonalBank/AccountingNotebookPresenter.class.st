Class {
	#name : #AccountingNotebookPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'notebook',
		'capitalDiagram',
		'operationEditor',
		'accounterSynchronizer',
		'synchronizerPresenter',
		'budgetTransfersDiagram'
	],
	#category : #'PersonalBank-GUI'
}

{ #category : #layout }
AccountingNotebookPresenter class >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: #synchronizerPresenter expand: false;
		  add: #notebook;
		  yourself
]

{ #category : #accessing }
AccountingNotebookPresenter >> accounter [

	^ accounterSynchronizer accounter
]

{ #category : #accessing }
AccountingNotebookPresenter >> accounterSynchronizer [

	^ accounterSynchronizer
]

{ #category : #pages }
AccountingNotebookPresenter >> budgetTransfersDiagramPage [

	^ SpNotebookPage
		  title: 'Budget transfers diagram'
		  icon: (self iconNamed: #publish)
		  provider: [ budgetTransfersDiagram ]
]

{ #category : #pages }
AccountingNotebookPresenter >> capitalDiagramPage [

	^ SpNotebookPage
		  title: 'Capital diagram'
		  icon: (self iconNamed: #glamorousBookmark)
		  provider: [ capitalDiagram ]
]

{ #category : #initialization }
AccountingNotebookPresenter >> initialize [

	super initialize.
	self setAccounterSynchronizer: AccounterSynchronizer new
]

{ #category : #initialization }
AccountingNotebookPresenter >> initializePresenters [

	synchronizerPresenter := self instantiate:
		                         AccounterSynchronizerPresenter new.
	capitalDiagram := self instantiate: CapitalDiagramPresenter new.
	budgetTransfersDiagram := self instantiate:
		                          BudgetTransfersDiagramPresenter new.
	operationEditor := self instantiate: OperationEditorPresenter new.
	notebook := self newNotebook.

	notebook
		addPage: self operationEditorPage;
		addPage: self capitalDiagramPage;
		addPage: self budgetTransfersDiagramPage
]

{ #category : #initialization }
AccountingNotebookPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		initialExtent: RealEstateAgent standardWindowExtent * 1.3;
		title: 'Accounting notebook';
		windowIcon: (self theme iconNamed: #glamorousTable)
]

{ #category : #pages }
AccountingNotebookPresenter >> operationEditorPage [

	^ SpNotebookPage
		  title: 'Operation editor'
		  icon: (self iconNamed: #history)
		  provider: [ operationEditor ]
]

{ #category : #initialization }
AccountingNotebookPresenter >> setAccounterSynchronizer: anAccounterSynchronizer [

	anAccounterSynchronizer == accounterSynchronizer ifTrue: [ ^ self ].
	accounterSynchronizer ifNotNil: [ 
		accounterSynchronizer removeDependent: self ].
	accounterSynchronizer := anAccounterSynchronizer.
	synchronizerPresenter setAccounterSynchronizer:
		anAccounterSynchronizer.
	accounterSynchronizer addDependent: self.
	self update: #accounter.
	self update: #unsavedChanges
]

{ #category : #updating }
AccountingNotebookPresenter >> update: aSymbol [

	aSymbol = #accounter ifTrue: [ 
		capitalDiagram setAccounter: accounterSynchronizer accounter.
		budgetTransfersDiagram setAccounter: accounterSynchronizer accounter.
		operationEditor setAccounter: accounterSynchronizer accounter ].
	aSymbol = #unsavedChanges ifTrue: [ 
		self window ifNotNil: [ 
			self window title:
				'Accounting notebook' , (accounterSynchronizer unsavedChanges
					 ifTrue: [ ' *' ]
					 ifFalse: [ '' ]) ] ]
]
