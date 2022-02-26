Class {
	#name : #OperationEditorPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'source',
		'destination',
		'amount',
		'bank',
		'type',
		'date',
		'operationBeingEdited',
		'operationsTable',
		'accounter'
	],
	#category : #'PersonalBank-GUI'
}

{ #category : #accessing }
OperationEditorPresenter class >> amountWidth [

	^ 120
]

{ #category : #accessing }
OperationEditorPresenter class >> dateWidth [

	^ 80
]

{ #category : #layout }
OperationEditorPresenter class >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: #operationsTable;
		  add: (SpBoxLayout newLeftToRight
				   spacing: 2;
				   add: #type width: self typeWidth;
				   add: #date width: self dateWidth;
				   add: #source;
				   add: #amount width: self amountWidth;
				   add: #destination;
				   add: #bank;
				   yourself)
		  height: self toolbarHeight;
		  yourself
]

{ #category : #accessing }
OperationEditorPresenter class >> typeWidth [

	^ 85
]

{ #category : #actions }
OperationEditorPresenter >> addOperation: anOperation [

	accounter addOperation: anOperation
]

{ #category : #accessing }
OperationEditorPresenter >> amount [

	^ amount
]

{ #category : #accessing }
OperationEditorPresenter >> bank [

	^ bank
]

{ #category : #initialization }
OperationEditorPresenter >> connectPresenters [

	operationsTable whenSelectionChangedDo: [ :selection | 
		selection selectedItems size = 1
			ifTrue: [ self editOperation: selection selectedItem ]
			ifFalse: [ self editDummyOperation ] ].
	bank whenSubmitDo: [ self submitEditedOperationClearingForm: true ].
	destination whenSubmitDo: [ 
		self submitEditedOperationClearingForm: true ].
	source whenSubmitDo: [ self submitEditedOperationClearingForm: true ].
	destination whenSubmitDo: [ 
		self submitEditedOperationClearingForm: true ].
	amount whenSubmitDo: [ self submitEditedOperationClearingForm: true ].
	date whenSubmitDo: [ self submitEditedOperationClearingForm: true ].
	type whenSelectionChangedDo: [ :selection | 
		bank editable: selection selectedItem model bankFieldOptional not.
		self submitEditedOperationClearingForm: false ].
	self presenters do: [ :each | 
		each
			bindKeyCombination: Character escape
			toAction: [ self unselectAll ] ]
]

{ #category : #initialization }
OperationEditorPresenter >> contextMenuItemNamed: name iconNamed: iconName action: aBlock [

	^ [ :anItem | 
	  anItem
		  name: [ 
			  operationsTable selectedItems size = 1
				  ifTrue: [ name ]
				  ifFalse: [ 
					  name , ' (' , operationsTable selectedItems size asString , ')' ] ];
		  iconName: iconName;
		  action: [ 
			  | selectedOperations |
			  selectedOperations := operationsTable selectedItems.
			  self unselectAll.
			  aBlock value: selectedOperations.
			  self updateTable ] ]
]

{ #category : #actions }
OperationEditorPresenter >> copyOperations: aCollection [

	| copy |
	copy := aCollection collect: [ :each | 
		        each copy
			        date: Date today;
			        yourself ].
	copy do: [ :each | self addOperation: each ].

	self selectItems: copy
]

{ #category : #accessing }
OperationEditorPresenter >> date [

	^ date
]

{ #category : #accessing }
OperationEditorPresenter >> destination [

	^ destination
]

{ #category : #actions }
OperationEditorPresenter >> editDummyOperation [

	self editOperation: Operation dummy
]

{ #category : #actions }
OperationEditorPresenter >> editOperation: anOperation [

	operationBeingEdited := nil.
	self fillFormWith: anOperation copy.
	operationBeingEdited := anOperation
]

{ #category : #actions }
OperationEditorPresenter >> fillFormWith: anOperation [

	type selectItem: anOperation type.
	date text: anOperation date ddmmyyyy asString.
	source text: anOperation source asString.
	amount number: anOperation amount asNumber.
	destination text: anOperation destination asString.
	bank text: (anOperation bank
			 ifNil: [ '' ]
			 ifNotNil: [ :bankName | bankName asString ])
]

{ #category : #initialization }
OperationEditorPresenter >> initializePresenters [

	accounter ifNil: [ accounter := Accounter new ].
	self instanciateOperationTable.
	self instanciateOperationEditor.
	self editDummyOperation
]

{ #category : #initialization }
OperationEditorPresenter >> instanciateOperationEditor [

	type := self newDropList
		        items: OperationType possibleTypes;
		        displayIcon: [ :eachType | eachType icon ].
	source := self newTextInput placeholder: 'Source'.
	date := self newTextInput placeholder: 'Date'.
	destination := self newTextInput placeholder: 'Destination'.
	amount := self newNumberInput
		          beFloat;
		          digits: 2;
		          climbRate: 1.
	bank := self newTextInput placeholder: 'Bank'
]

{ #category : #initialization }
OperationEditorPresenter >> instanciateOperationTable [

	operationsTable := self newTable
		                   beMultipleSelection;
		                   addColumn: (SpCompositeTableColumn new
				                    title: 'Type';
				                    addColumn:
					                    ((SpImageTableColumn evaluated: [ 
							                      :eachOperation | eachOperation type icon ]) 
						                     width: 20);
				                    addColumn:
					                    (SpStringTableColumn evaluated: [ 
							                     :eachOperation | eachOperation type ]);
				                    width: self class typeWidth;
				                    yourself);
		                   addColumn: ((SpStringTableColumn
				                     title: 'Date'
				                     evaluated: [ :eachOperation | 
				                     eachOperation date ddmmyyyy ]) width:
				                    self class dateWidth);
		                   addColumn: (SpStringTableColumn
				                    title: 'Source'
				                    evaluated: [ :eachOperation | 
				                    eachOperation source asString ]);
		                   addColumn: ((SpStringTableColumn
				                     title: 'Amount'
				                     evaluated: [ :eachOperation | 
				                     eachOperation amount asString ]) width:
				                    self class amountWidth);
		                   addColumn: (SpStringTableColumn
				                    title: 'Destination'
				                    evaluated: [ :eachOperation | 
				                    eachOperation destination asString ]);
		                   addColumn:
			                   (SpStringTableColumn
				                    title: 'Bank'
				                    evaluated: [ :eachOperation | 
					                    eachOperation type bankFieldOptional
						                    ifFalse: [ eachOperation bank asString ]
						                    ifTrue: [ '' ] ]);
		                   contextMenu: self operationTableContextMenu;
		                   beNotResizable
]

{ #category : #accessing }
OperationEditorPresenter >> operationList [

	^ accounter operations
]

{ #category : #initialization }
OperationEditorPresenter >> operationTableContextMenu [

	^ self newMenu
		  addItem: (self
				   contextMenuItemNamed: 'Delete'
				   iconNamed: #delete
				   action: [ :toRemove | self removeOperations: toRemove ]);
		  addItem: (self
				   contextMenuItemNamed: 'Copy'
				   iconNamed: #smallCopy
				   action: [ :toCopy | self copyOperations: toCopy ]);
		  addItem: (self
				   contextMenuItemNamed: 'Push up'
				   iconNamed: #up
				   action: [ :toCopy | self pushUpOperations: toCopy ]);
		  addItem: (self
				   contextMenuItemNamed: 'Pull down'
				   iconNamed: #down
				   action: [ :toCopy | self pullDownOperations: toCopy ])
]

{ #category : #accessing }
OperationEditorPresenter >> operationsTable [

	^ operationsTable
]

{ #category : #accessing }
OperationEditorPresenter >> presenters [

	^ { 
		  operationsTable.
		  destination.
		  source.
		  destination.
		  amount.
		  date.
		  type }
]

{ #category : #actions }
OperationEditorPresenter >> pullDownOperations: aCollection [

	accounter pullDownOperations: aCollection.
	self selectItems: aCollection
]

{ #category : #actions }
OperationEditorPresenter >> pushUpOperations: aCollection [

	accounter pushUpOperations: aCollection.
	self selectItems: aCollection
]

{ #category : #actions }
OperationEditorPresenter >> removeOperations: aCollection [

	accounter removeOperations: aCollection
]

{ #category : #actions }
OperationEditorPresenter >> selectItems: aCollection [

	operationsTable selectionMode selectIndexes:
		(aCollection collect: [ :anItem | 
			 operationsTable selectionMode model collection identityIndexOf:
				 anItem ])
]

{ #category : #initialization }
OperationEditorPresenter >> setAccounter: anAccounter [

	anAccounter == accounter ifTrue: [ ^ self ].
	accounter ifNotNil: [ accounter removeDependent: self ].
	accounter := anAccounter.
	accounter addDependent: self.
	self editDummyOperation.
	self update: #operations
]

{ #category : #accessing }
OperationEditorPresenter >> source [

	^ source
]

{ #category : #actions }
OperationEditorPresenter >> submitEditedOperationClearingForm: shouldClearForm [

	((self submitEditedOperationInto: Operation dummy) makesSense not 
		 or: [ operationBeingEdited isNil ]) ifTrue: [ ^ self ].
	type selectedItem bankFieldOptional ifTrue: [ bank clearContent ].
	self submitEditedOperationInto: operationBeingEdited.
	self addOperation: operationBeingEdited.
	self editOperation: (shouldClearForm
			 ifFalse: [ operationBeingEdited ]
			 ifTrue: [ 
				 self unselectAll.
				 Operation dummy ]).
	self updateTable
]

{ #category : #actions }
OperationEditorPresenter >> submitEditedOperationInto: anOperation [

	^ anOperation
		  source: source text;
		  type: type selectedItem;
		  bank: bank text;
		  date: (Date readFrom: date text pattern: 'd/m/y');
		  amount: amount number;
		  destination: destination text;
		  yourself
]

{ #category : #accessing }
OperationEditorPresenter >> type [

	^ type
]

{ #category : #actions }
OperationEditorPresenter >> unselectAll [

	operationsTable unselectAll.
	self editDummyOperation
]

{ #category : #updating }
OperationEditorPresenter >> update [

	super update.
	self updateTable
]

{ #category : #updating }
OperationEditorPresenter >> update: aSymbol [

	aSymbol = #operations ifTrue: [ self update ]
]

{ #category : #updating }
OperationEditorPresenter >> updateTable [

	operationsTable model collection:
		(self operationList copy reversed sorted: [ :a :b | a date < b date ]).
	operationsTable refresh
]
