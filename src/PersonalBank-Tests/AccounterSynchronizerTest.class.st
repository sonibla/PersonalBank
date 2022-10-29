Class {
	#name : #AccounterSynchronizerTest,
	#superclass : #AbstractAccountingTest,
	#category : #'PersonalBank-Tests-Core'
}

{ #category : #running }
AccounterSynchronizerTest >> tearDown [

	self filenameForTesting asFileReference deleteIfAbsent: [  ]
]

{ #category : #'tests - converting' }
AccounterSynchronizerTest >> testArrayConversion [

	self
		assert: (AccounterSynchronizer accounterFromArray:
				 (AccounterSynchronizer arrayFromAccounter: self dummyAccounter))
		equals: self dummyAccounter
]

{ #category : #'tests - file sync' }
AccounterSynchronizerTest >> testAutosave [

	self dummyAccounterSynchronizer filename: self filenameForTesting.
	self dummyAccounterSynchronizer accounter addOperation:
		(self dummyIncomeOf: 1).
	self assert: self dummyAccounterSynchronizer unsavedChanges.
	self dummyAccounterSynchronizer autosave: true.
	self deny: self dummyAccounterSynchronizer unsavedChanges.
	self
		assert:
			(self emptyAccounterSynchronizer loadFromFile:
				 self filenameForTesting) accounter
		equals: self dummyAccounterSynchronizer accounter.

	self dummyAccounterSynchronizer accounter addOperation:
		(self dummyIncomeOf: 2).
	self deny: self dummyAccounterSynchronizer unsavedChanges.
	self
		assert:
			(self emptyAccounterSynchronizer loadFromFile:
				 self filenameForTesting) accounter
		equals: self dummyAccounterSynchronizer accounter
]

{ #category : #'tests - converting' }
AccounterSynchronizerTest >> testFileConversion [

	AccounterSynchronizer
		write: self dummyAccounter
		onFile: self filenameForTesting asFileReference.
	self
		assert: (AccounterSynchronizer readFromFile:
				 self filenameForTesting asFileReference)
		equals: self dummyAccounter
]

{ #category : #'tests - converting' }
AccounterSynchronizerTest >> testFilenameConversion [

	AccounterSynchronizer
		write: self dummyAccounter
		onFile: self filenameForTesting.
	self
		assert:
		(AccounterSynchronizer readFromFile: self filenameForTesting)
		equals: self dummyAccounter
]

{ #category : #'tests - file sync' }
AccounterSynchronizerTest >> testFilenameSetAfterLoad [

	self dummyAccounterSynchronizer saveOnFile: self filenameForTesting.
	self emptyAccounterSynchronizer loadFromFile: self filenameForTesting.
	self
		assert: self emptyAccounterSynchronizer filename
		equals: self filenameForTesting.
	self
		assert: self dummyAccounterSynchronizer accounter
		equals: self emptyAccounterSynchronizer accounter
]

{ #category : #'tests - file sync' }
AccounterSynchronizerTest >> testFilenameSetAfterSaveAs [

	self dummyAccounterSynchronizer saveOnFile: self filenameForTesting.
	self
		assert: self dummyAccounterSynchronizer filename
		equals: self filenameForTesting.
	self
		assert:
			(self emptyAccounterSynchronizer loadFromFile:
				 self filenameForTesting) accounter
		equals: self dummyAccounterSynchronizer accounter
]

{ #category : #'tests - converting' }
AccounterSynchronizerTest >> testJsonFormat [

	self
		assert: (String streamContents: [ :stream | 
				 AccounterSynchronizer write: self dummyAccounter onStream: stream ])
		equals:
		'[{#source:''Source1'',#amount:''1000'',#bank:''Bank1'',#destination:''Budget1'',#date:Date[''2000-01-01+02:00''],#type:''IN''},{#source:''Source2'',#amount:''1200'',#bank:''Bank2'',#destination:''Budget1'',#date:Date[''2000-01-02+02:00''],#type:''IN''},{#source:''Budget1'',#amount:''200'',#bank:''Bank1'',#destination:''Destination1'',#date:Date[''2000-01-02+02:00''],#type:''OUT''},{#source:''Bank1'',#amount:''420'',#bank:nil,#destination:''Bank2'',#date:Date[''2000-01-03+02:00''],#type:''BK-TR''},{#source:''Budget1'',#amount:''500'',#bank:nil,#destination:''Budget2'',#date:Date[''2000-01-04+02:00''],#type:''BG-TR''},{#source:''Bank1'',#amount:''90'',#bank:nil,#destination:''Bank3'',#date:Date[''2000-01-03+02:00''],#type:''BK-TR''},{#source:''Budget1'',#amount:''600'',#bank:nil,#destination:''Budget3'',#date:Date[''2000-01-04+02:00''],#type:''BG-TR''},{#source:''Budget1'',#amount:''900'',#bank:nil,#destination:''Budget4'',#date:Date[''2000-01-04+02:00''],#type:''BG-TR''},{#source:''Budget3'',#amount:''52'',#bank:''Bank1'',#destination:''Destination2'',#date:Date[''2000-01-07+02:00''],#type:''OUT''}]'
]

{ #category : #'tests - file sync' }
AccounterSynchronizerTest >> testNoFilename [

	self
		assert: self dummyAccounterSynchronizer accounter
		equals: self dummyAccounter.
	self assert: self dummyAccounterSynchronizer filename equals: ''.
	self assert: self dummyAccounterSynchronizer unsavedChanges.
	self dummyAccounterSynchronizer autosave: true.
	self assert: self dummyAccounterSynchronizer autosave.
	self assert: self dummyAccounterSynchronizer unsavedChanges.
	self dummyAccounterSynchronizer save.
	self assert: self dummyAccounterSynchronizer unsavedChanges
]

{ #category : #'tests - file sync' }
AccounterSynchronizerTest >> testReload [

	self dummyAccounterSynchronizer reload.
	self dummyAccounterSynchronizer filename: self filenameForTesting.
	self dummyAccounterSynchronizer save.
	self dummyAccounterSynchronizer accounter addOperation:
		(self dummyOutcomeOf: 1).
	self assert: self dummyAccounterSynchronizer unsavedChanges.
	self dummyAccounterSynchronizer reload.
	self deny: self dummyAccounterSynchronizer unsavedChanges.
	self
		assert: self dummyAccounterSynchronizer accounter operations asArray
		equals: self dummyOperations.
	self
		assert:
			(self emptyAccounterSynchronizer loadFromFile:
				 self filenameForTesting) accounter
		equals: self dummyAccounterSynchronizer accounter
]

{ #category : #'tests - file sync' }
AccounterSynchronizerTest >> testSave [

	self dummyAccounterSynchronizer filename: self filenameForTesting.
	self dummyAccounterSynchronizer accounter addOperation:
		(self dummyOutcomeOf: 1).
	self assert: self dummyAccounterSynchronizer unsavedChanges.
	self dummyAccounterSynchronizer save.
	self deny: self dummyAccounterSynchronizer unsavedChanges.
	self
		assert:
			(self emptyAccounterSynchronizer loadFromFile:
				 self filenameForTesting) accounter
		equals: self dummyAccounterSynchronizer accounter
]

{ #category : #'tests - file sync' }
AccounterSynchronizerTest >> testSaveAfterLoad [

	self dummyAccounterSynchronizer saveOnFile: self filenameForTesting.
	self emptyAccounterSynchronizer loadFromFile: self filenameForTesting.
	self
		assert: self emptyAccounterSynchronizer filename
		equals: self filenameForTesting.
	self
		assert: self dummyAccounterSynchronizer accounter
		equals: self emptyAccounterSynchronizer accounter.
	self deny: self emptyAccounterSynchronizer unsavedChanges.
	self emptyAccounterSynchronizer accounter addOperation:
		(self dummyOutcomeOf: 1).
	self assert: self emptyAccounterSynchronizer unsavedChanges.
	self emptyAccounterSynchronizer save.
	self deny: self emptyAccounterSynchronizer unsavedChanges.
	self
		deny: self dummyAccounterSynchronizer accounter
		equals: self emptyAccounterSynchronizer accounter.
	self
		assert:
			(self dummyAccounterSynchronizer loadFromFile:
				 self filenameForTesting) accounter
		equals: self emptyAccounterSynchronizer accounter
]

{ #category : #'tests - file sync' }
AccounterSynchronizerTest >> testSaveAfterSaveAs [

	self dummyAccounterSynchronizer saveOnFile: self filenameForTesting.
	self
		assert: self dummyAccounterSynchronizer filename
		equals: self filenameForTesting.
	self dummyAccounterSynchronizer accounter addOperation:
		(self dummyOutcomeOf: 1).
	self assert: self dummyAccounterSynchronizer unsavedChanges.
	self dummyAccounterSynchronizer save.
	self deny: self dummyAccounterSynchronizer unsavedChanges.
	self
		assert:
			(self emptyAccounterSynchronizer loadFromFile:
				 self filenameForTesting) accounter
		equals: self dummyAccounterSynchronizer accounter
]

{ #category : #'tests - file sync' }
AccounterSynchronizerTest >> testSaveAsAndLoad [

	self dummyAccounterSynchronizer saveOnFile: self filenameForTesting.
	self deny: self dummyAccounterSynchronizer unsavedChanges.
	self
		assert: self dummyAccounterSynchronizer filename
		equals: self filenameForTesting.
	self
		assert:
			(self emptyAccounterSynchronizer loadFromFile:
				 self filenameForTesting) accounter
		equals: self dummyAccounterSynchronizer accounter
]

{ #category : #'tests - file sync' }
AccounterSynchronizerTest >> testSaveEmptyAccounter [

	| synchronizer |
	synchronizer := AccounterSynchronizer new.
	synchronizer saveOnFile: self filenameForTesting.
	self assert: synchronizer filename equals: self filenameForTesting.
	synchronizer accounter addOperation: (self dummyOutcomeOf: 1).
	self assert: synchronizer unsavedChanges.
	self dummyAccounterSynchronizer loadFromFile: self filenameForTesting.
	self deny: self dummyAccounterSynchronizer unsavedChanges.
	self
		assert: self dummyAccounterSynchronizer accounter
		equals: Accounter new
]

{ #category : #'tests - file sync' }
AccounterSynchronizerTest >> testShouldNotAutosaveInCaseOfSanityIssue [

	self dummyAccounterSynchronizer autosave: true.
	self dummyAccounterSynchronizer filename: self filenameForTesting.
	self dummyAccounterSynchronizer accounter
		addOperation: (BudgetTransferOperation
				 on: (Date newDay: 9 month: 1 year: 2000)
				 change: 'Budget2' -> 500 -> 'Budget2bis');
		addOperation: (BudgetTransferOperation
				 on: (Date newDay: 9 month: 1 year: 2000)
				 change: 'Budget1' -> 500 -> 'Budget2bis').
	self assert: self dummyAccounterSynchronizer accounter sanityIssues.
	self assert: self dummyAccounterSynchronizer unsavedChanges
]

{ #category : #'tests - converting' }
AccounterSynchronizerTest >> testStringConversion [

	self
		assert: (AccounterSynchronizer readFromStream:
				 (String streamContents: [ :stream | 
					  AccounterSynchronizer
						  write: self dummyAccounter
						  onStream: stream ]) readStream)
		equals: self dummyAccounter
]

{ #category : #'tests - file sync' }
AccounterSynchronizerTest >> testUnsavedChanges [

	self deny: AccounterSynchronizer new unsavedChanges.
	self assert: self dummyAccounterSynchronizer unsavedChanges.
	self dummyAccounterSynchronizer saveOnFile: self filenameForTesting.
	self dummyAccounterSynchronizer autosave: false.
	self dummyAccounterSynchronizer accounter removeOperations:
		self dummyAccounterSynchronizer accounter operations.
	self assert: self dummyAccounterSynchronizer unsavedChanges.
	self dummyAccounterSynchronizer filename: ''.
	self deny: self dummyAccounterSynchronizer unsavedChanges
]
