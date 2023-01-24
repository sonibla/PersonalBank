Class {
	#name : #AccountingNotebookPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'notebook',
		'capitalDiagram',
		'operationEditor',
		'accounterSynchronizer',
		'synchronizerPresenter',
		'toolBar',
		'showAmountsButton',
		'triggerUpdateButton'
	],
	#category : #'PersonalBank-GUI'
}

{ #category : #layout }
AccountingNotebookPresenter class >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: (SpBoxLayout newLeftToRight
				   add: #synchronizerPresenter expand: false;
				   add: #toolBar withConstraints: [ :constraints | 
					   constraints
						   padding: 5;
						   height: 35;
						   width: 35;
						   expand: false ];
				   yourself)
		  expand: false;
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

	toolBar := self newToolbar
		           addItem: self showAmountsButton;
		           addItem: self triggerUpdateButton;
		           yourself.
	synchronizerPresenter := self instantiate:
		                         AccounterSynchronizerPresenter new.
	capitalDiagram := self instantiate: CapitalDiagramPresenter new.
	capitalDiagram shouldShowAmounts: self showAmountsButton state.
	operationEditor := self instantiate: OperationEditorPresenter new.
	capitalDiagram shouldShowAmounts: self showAmountsButton state.
	notebook := self newNotebook.

	notebook
		addPage: self operationEditorPage;
		addPage: self capitalDiagramPage
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

{ #category : #initialization }
AccountingNotebookPresenter >> showAmountsButton [

	^ showAmountsButton ifNil: [ 
		  showAmountsButton := SpToolbarToggleButtonPresenter new
			                       label: 'Show amounts';
			                       icon: (self iconNamed: #smallFind);
			                       help: 'Display amounts';
			                       whenToggledDo: [ 
				                       showAmountsButton ifNotNil: [ 
						                       capitalDiagram shouldShowAmounts:
								                       showAmountsButton state.
						                       operationEditor shouldShowAmounts:
								                       showAmountsButton state ] ];
			                       state: false;
			                       yourself ]
]

{ #category : #accessing }
AccountingNotebookPresenter >> triggerUpdateButton [

	^ triggerUpdateButton ifNil: [ 
		  triggerUpdateButton := SpToolbarButtonPresenter new
			                         label: 'Update';
			                         icon: (self iconNamed: #glamorousRefresh);
			                         help: 'Force recomputation and update';
			                         action: [ 
				                         self accounter changed: #operations ];
			                         yourself ]
]

{ #category : #updating }
AccountingNotebookPresenter >> update: aSymbol [

	aSymbol = #accounter ifTrue: [ 
		capitalDiagram setAccounter: accounterSynchronizer accounter.
		operationEditor setAccounter: accounterSynchronizer accounter ].
	aSymbol = #unsavedChanges ifTrue: [ 
		self window ifNotNil: [ 
			self window title:
				'Accounting notebook' , (accounterSynchronizer unsavedChanges
					 ifTrue: [ ' *' ]
					 ifFalse: [ '' ]) ] ]
]
