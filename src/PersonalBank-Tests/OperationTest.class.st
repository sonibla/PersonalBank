Class {
	#name : #OperationTest,
	#superclass : #TestCase,
	#category : #'PersonalBank-Tests-Core'
}

{ #category : #tests }
OperationTest >> testCopy [

	| operation |
	operation := Operation new
		             type: OutcomeOperation;
		             date: (Date newDay: 01 month: 01 year: 2000);
		             source: 'Source';
		             amount: 0;
		             destination: 'Destination';
		             bank: 'Bank'.

	self assert: operation equals: operation copy.
	self deny: operation identicalTo: operation copy.
	self deny: operation copy identicalTo: operation copy
]

{ #category : #tests }
OperationTest >> testEquals [

	| operation |
	operation := OutcomeOperation
		             on: (Date newDay: 01 month: 01 year: 2000)
		             from: 'Source'
		             to: 'Destination'
		             of: 0
		             bank: 'Bank'.

	self assert: operation equals: operation copy.
	self assert: operation hash equals: operation copy hash.
	self deny: operation equals: (operation copy
			 source: 'SOURCE';
			 yourself).
	self deny: operation equals: (operation copy
			 destination: nil;
			 yourself).
	self deny: operation equals: (operation copy
			 bank: 'BK';
			 yourself).
	self assert: operation equals: (operation copy
			 amount: 0.0;
			 yourself).
	self assert: operation hash equals: (operation copy
			 amount: 0.0;
			 hash).
	self deny: operation equals: (operation copy
			 amount: 0.1;
			 yourself).
	self deny: operation equals: (operation copy
			 type: IncomeOperation;
			 yourself)
]

{ #category : #tests }
OperationTest >> testMakesSenseBankTransfer [

	| operation |
	operation := Operation new type: BankTransferOperation.
	self deny: operation makesSense.
	operation
		date: (Date newDay: 01 month: 01 year: 2000);
		source: 'Source';
		amount: 0;
		destination: 'Destination';
		bank: 'Bank'.

	self assert: operation makesSense.
	operation bank: nil.
	self assert: operation makesSense.
	operation amount: '0'.
	self deny: operation makesSense.
	operation
		amount: 0;
		source: 123.
	self deny: operation makesSense.
	operation
		source: 'Source';
		date: '01/01/2000'.
	self deny: operation makesSense
]

{ #category : #tests }
OperationTest >> testMakesSenseBudgetTransfer [

	| operation |
	operation := Operation new type: BudgetTransferOperation.
	self deny: operation makesSense.
	operation
		date: (Date newDay: 01 month: 01 year: 2000);
		source: 'Source';
		amount: 0;
		destination: 'Destination';
		bank: 'Bank'.

	self assert: operation makesSense.
	operation bank: nil.
	self assert: operation makesSense.
	operation amount: '0'.
	self deny: operation makesSense.
	operation
		amount: 0;
		source: 123.
	self deny: operation makesSense.
	operation
		source: 'Source';
		date: '01/01/2000'.
	self deny: operation makesSense
]

{ #category : #tests }
OperationTest >> testMakesSenseIncome [

	| operation |
	operation := Operation new type: IncomeOperation.
	self deny: operation makesSense.
	operation
		date: (Date newDay: 01 month: 01 year: 2000);
		source: 'Source';
		amount: 0;
		destination: 'Destination';
		bank: 'Bank'.

	self assert: operation makesSense.
	operation bank: nil.
	self deny: operation makesSense.
	operation
		amount: '0';
		bank: 'Bank'.
	self deny: operation makesSense.
	operation
		amount: 0;
		source: 123.
	self deny: operation makesSense.
	operation
		source: 'Source';
		date: '01/01/2000'.
	self deny: operation makesSense
]

{ #category : #tests }
OperationTest >> testMakesSenseOutcome [

	| operation |
	operation := Operation new type: OutcomeOperation.
	self deny: operation makesSense.
	operation
		date: (Date newDay: 01 month: 01 year: 2000);
		source: 'Source';
		amount: 0;
		destination: 'Destination';
		bank: 'Bank'.

	self assert: operation makesSense.
	operation bank: nil.
	self deny: operation makesSense.
	operation
		amount: '0';
		bank: 'Bank'.
	self deny: operation makesSense.
	operation
		amount: 0;
		source: 123.
	self deny: operation makesSense.
	operation
		source: 'Source';
		date: '01/01/2000'.
	self deny: operation makesSense
]

{ #category : #tests }
OperationTest >> testPrintString [

	| operation |
	operation := Operation new.
	self assert: operation printString equals: 'Operation'.

	operation type: OutcomeOperation.
	self assert: operation printString equals: 'Operation (Outcome)'.

	operation date: (Date newDay: 01 month: 01 year: 2000).
	self
		assert: operation printString
		equals: 'Operation (Outcome) effective on 1 January 2000'.

	operation source: 'Source'.
	self
		assert: operation printString
		equals: 'Operation (Outcome) from Source effective on 1 January 2000'.

	operation destination: 'Destination'.
	self
		assert: operation printString
		equals:
		'Operation (Outcome) from Source to Destination effective on 1 January 2000'.

	operation bank: 'Bank'.
	self
		assert: operation printString
		equals:
		'Operation (Outcome) from Source to Destination effective on 1 January 2000 in bank Bank'
]
