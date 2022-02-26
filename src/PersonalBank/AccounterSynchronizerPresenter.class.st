Class {
	#name : #AccounterSynchronizerPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'accounterSynchronizer',
		'toolBar',
		'openButton',
		'saveButton',
		'saveAsButton',
		'autosaveButton',
		'deleteButton',
		'inspectButton',
		'filenameLabel',
		'syncStatusImage',
		'syncImage',
		'sanityStatusImage',
		'sanityImage',
		'undoButton'
	],
	#category : #'PersonalBank-GUI'
}

{ #category : #layout }
AccounterSynchronizerPresenter class >> defaultLayout [

	^ SpBoxLayout newLeftToRight
		  add: #toolBar expand: false;
		  add: (SpBoxLayout newTopToBottom
				   add: #sanityImage withConstraints: [ :constraints | 
					   constraints
						   padding: 5;
						   height: 35;
						   width: 35;
						   expand: false ];
				   add: #sanityStatusImage withConstraints: [ :constraints | 
				   constraints
					   padding: 0;
					   expand: false ])
		  withConstraints: [ :constraints | 
			  constraints
				  padding: 20;
				  expand: false ];
		  add: (SpBoxLayout newTopToBottom
				   add: #syncImage withConstraints: [ :constraints | 
					   constraints
						   padding: 5;
						   height: 35;
						   width: 35;
						   expand: false ];
				   add: #syncStatusImage withConstraints: [ :constraints | 
				   constraints
					   padding: 0;
					   expand: false ])
		  withConstraints: [ :constraints | 
			  constraints
				  padding: 20;
				  expand: false ];
		  add: (SpBoxLayout newTopToBottom
				   add: #filenameLabel
				   withConstraints: [ :constraints | 
					   constraints
						   width: 400;
						   padding: 20;
						   expand: false ])
		  expand: false;
		  yourself
]

{ #category : #accessing }
AccounterSynchronizerPresenter >> accounter [

	^ accounterSynchronizer accounter
]

{ #category : #accessing }
AccounterSynchronizerPresenter >> autosaveButton [

	^ autosaveButton ifNil: [ 
		  autosaveButton := SpToolbarToggleButtonPresenter new
			                    label: 'Autosave';
			                    icon: (self iconNamed: #smallDoIt);
			                    help: 'Automatically save';
			                    whenToggledDo: [ 
				                    autosaveButton ifNotNil: [ 
						                    self isAutosaveButtonSynchronized ifFalse: [ 
								                    self toggleAutosave ] ] ];
			                    state: accounterSynchronizer autosave;
			                    yourself ]
]

{ #category : #actions }
AccounterSynchronizerPresenter >> debugSanityIssues [

	self accounter errorWhileProcessing
		ifNotNil: [ :exception | exception inspect ]
		ifNil: [ 
			UIManager default
				alert: self sanityIssuesString
				title: 'Sanity issues' ]
]

{ #category : #accessing }
AccounterSynchronizerPresenter >> deleteButton [

	^ deleteButton ifNil: [ 
		  deleteButton := SpToolbarButtonPresenter new
			                  label: 'New';
			                  icon: (self iconNamed: #smallNew);
			                  help: 'Won''t save';
			                  action: [ 
				                  (self userReallyWantsToDiscardChangesTo:
						                   'create new accounter') ifTrue: [ 
						                  accounterSynchronizer setAccounter:
								                  Accounter new ] ];
			                  yourself ]
]

{ #category : #accessing }
AccounterSynchronizerPresenter >> filenameLabel [

	^ filenameLabel
]

{ #category : #initialization }
AccounterSynchronizerPresenter >> initializePresenters [

	accounterSynchronizer ifNil: [ 
		accounterSynchronizer := AccounterSynchronizer new ].
	toolBar := self newToolbar
		           addItem: self deleteButton;
		           addItem: self openButton;
		           addItem: self saveButton;
		           addItem: self saveAsButton;
		           addItem: self autosaveButton;
		           addItem: self undoButton;
		           addItem: self inspectButton;
		           yourself.
	syncStatusImage := self newImage
		                   image: (self theme iconNamed: #testNotRun);
		                   help: 'Sync status'.
	syncImage := self newImage image: (self theme iconNamed: #database).
	sanityStatusImage := self newImage
		                     image: (self theme iconNamed: #testGreen);
		                     help: 'Sanity status'.
	sanityImage := self newButton
		               icon: (self theme iconNamed: #smallDebug);
		               action: [ self debugSanityIssues ];
		               enabled: false.
	filenameLabel := self newTextInput beNotEditable.
	self whenBuiltDo: [ self update: #unsavedChanges ]
]

{ #category : #accessing }
AccounterSynchronizerPresenter >> inspectButton [

	^ inspectButton ifNil: [ 
		  inspectButton := SpToolbarButtonPresenter new
			                   label: 'Inspect';
			                   icon: (self iconNamed: #smallInspectIt);
			                   help: 'Inspect model';
			                   action: [ self accounter inspect ];
			                   yourself ]
]

{ #category : #query }
AccounterSynchronizerPresenter >> isAutosaveButtonSynchronized [

	^ accounterSynchronizer autosave = autosaveButton state
]

{ #category : #accessing }
AccounterSynchronizerPresenter >> openButton [

	^ openButton ifNil: [ 
		  openButton := SpToolbarButtonPresenter new
			                label: 'Open';
			                icon: (self iconNamed: #smallOpen);
			                help: 'Load from file';
			                action: [ 
				                (self userReallyWantsToDiscardChangesTo:
						                 'load data') ifTrue: [ 
						                self openDialogToOpenExistingFile ] ];
			                yourself ]
]

{ #category : #actions }
AccounterSynchronizerPresenter >> openDialogToOpenExistingFile [

	| filename |
	filename := UIManager default
		            chooseExistingFileReference: 'Choose file to open'
		            extensions: #( 'json' )
		            path: accounterSynchronizer filename.
	^ filename ifNotNil: [ accounterSynchronizer loadFromFile: filename ]
]

{ #category : #query }
AccounterSynchronizerPresenter >> sanityIssues [

	^ self accounter bankAndBudgetsEqualCapitals not or: [ 
		  self accounter negativeCapitals or: [ 
			  self accounter partialSplits or: [ 
				  self accounter duplicatedNames ] ] ]
]

{ #category : #query }
AccounterSynchronizerPresenter >> sanityIssuesString [

	^ String streamContents: [ :stream | 
		  self accounter bankAndBudgetsEqualCapitals ifFalse: [ 
			  stream
				  nextPutAll: 'bankAndBudgetsEqualCapitals';
				  cr ].
		  self accounter negativeCapitals ifTrue: [ 
			  stream
				  nextPutAll: 'negativeCapitals';
				  cr ].
		  self accounter partialSplits ifTrue: [ 
			  stream
				  nextPutAll: 'partialSplits';
				  cr ].
		  self accounter duplicatedNames ifTrue: [ 
			  stream
				  nextPutAll: 'duplicatedNames';
				  cr ] ]
]

{ #category : #accessing }
AccounterSynchronizerPresenter >> sanityStatusImage [

	^ sanityStatusImage
]

{ #category : #query }
AccounterSynchronizerPresenter >> sanityStatusImageToDisplay [

	^ self accounter errorWhileProcessing
		  ifNotNil: [ #testRed ]
		  ifNil: [ 
			  self sanityIssues
				  ifTrue: [ #testYellow ]
				  ifFalse: [ #testGreen ] ]
]

{ #category : #actions }
AccounterSynchronizerPresenter >> saveAs [

	| filename |
	filename := UIManager default
		            chooseForSaveFileReference: 'Save as?'
		            extensions: #( 'json' )
		            path: accounterSynchronizer filename.
	filename ifNotNil: [ accounterSynchronizer saveOnFile: filename ]
]

{ #category : #accessing }
AccounterSynchronizerPresenter >> saveAsButton [

	^ saveAsButton ifNil: [ 
		  saveAsButton := SpToolbarButtonPresenter new
			                  label: 'Save as';
			                  icon: (self iconNamed: #smallSaveAs);
			                  help: 'Save into new file';
			                  action: [ self saveAs ];
			                  yourself ]
]

{ #category : #accessing }
AccounterSynchronizerPresenter >> saveButton [

	^ saveButton ifNil: [ 
		  saveButton := SpToolbarButtonPresenter new
			                label: 'Save';
			                icon: (self iconNamed: #smallSave);
			                help: 'Save into file';
			                action: [ 
				                accounterSynchronizer filename
					                ifEmpty: [ self saveAs ]
					                ifNotEmpty: [ accounterSynchronizer save ] ];
			                yourself ]
]

{ #category : #initialization }
AccounterSynchronizerPresenter >> setAccounterSynchronizer: anAccounterSynchronizer [

	anAccounterSynchronizer == accounterSynchronizer ifTrue: [ ^ self ].
	accounterSynchronizer ifNotNil: [ 
		accounterSynchronizer removeDependent: self ].
	accounterSynchronizer := anAccounterSynchronizer.
	accounterSynchronizer addDependent: self.
	self update: #accounterSynchronizer
]

{ #category : #accessing }
AccounterSynchronizerPresenter >> syncStatusImage [

	^ syncStatusImage
]

{ #category : #query }
AccounterSynchronizerPresenter >> syncStatusImageToDisplay [

	^ self unsavedChanges
		  ifFalse: [ #testGreen ]
		  ifTrue: [ 
			  accounterSynchronizer filename
				  ifEmpty: [ 
					  accounterSynchronizer accounter = Accounter new
						  ifTrue: [ #testNotRun ]
						  ifFalse: [ #testRed ] ]
				  ifNotEmpty: [ #testYellow ] ]
]

{ #category : #actions }
AccounterSynchronizerPresenter >> toggleAutosave [

	accounterSynchronizer autosave: accounterSynchronizer autosave not
]

{ #category : #accessing }
AccounterSynchronizerPresenter >> undoButton [

	^ undoButton ifNil: [ 
		  undoButton := SpToolbarButtonPresenter new
			                label: 'Discard changes';
			                icon: (self iconNamed: #smallDelete);
			                help: 'Reload file from disk';
			                action: [ 
				                (self userReallyWantsToDiscardChangesTo:
						                 'reload from file') ifTrue: [ 
						                accounterSynchronizer reload ] ];
			                enabled:
				                (self unsavedChanges and: [ 
						                 accounterSynchronizer filename notEmpty ]);
			                yourself ]
]

{ #category : #query }
AccounterSynchronizerPresenter >> unsavedChanges [

	^ accounterSynchronizer unsavedChanges
]

{ #category : #updating }
AccounterSynchronizerPresenter >> update: aSymbol [

	aSymbol = #unsavedChanges ifTrue: [ 
		syncStatusImage image:
			(self theme iconNamed: self syncStatusImageToDisplay).
		undoButton enabled: (self unsavedChanges and: [ 
				 accounterSynchronizer filename notEmpty ]) ].
	aSymbol = #accounter ifTrue: [ 
		syncStatusImage image:
			(self theme iconNamed: self syncStatusImageToDisplay) ].
	aSymbol = #filename ifTrue: [ 
		syncStatusImage image:
			(self theme iconNamed: self syncStatusImageToDisplay).
		filenameLabel text = accounterSynchronizer filename ifFalse: [ 
			filenameLabel text: accounterSynchronizer filename ] ].
	aSymbol = #autosave ifTrue: [ 
		accounterSynchronizer autosave = autosaveButton state ifFalse: [ 
			autosaveButton state: accounterSynchronizer autosave ] ].
	aSymbol = #statistics ifTrue: [ 
		sanityImage enabled:
			(self accounter errorWhileProcessing notNil or: [ 
				 self sanityIssues ]).
		sanityStatusImage image:
			(self theme iconNamed: self sanityStatusImageToDisplay) ].

	toolBar update
]

{ #category : #query }
AccounterSynchronizerPresenter >> userReallyWantsToDiscardChangesTo: descriptionString [

	^ self unsavedChanges
		  ifFalse: [ true ]
		  ifTrue: [ 
			  UIManager default confirm:
				  'Unsaved changes! Do you really want to ' , descriptionString
				  , ' ?' ]
]
