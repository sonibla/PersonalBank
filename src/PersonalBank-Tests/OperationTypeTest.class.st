Class {
	#name : #OperationTypeTest,
	#superclass : #TestCase,
	#category : #'PersonalBank-Tests-Core'
}

{ #category : #tests }
OperationTypeTest >> testFromJsonId [

	self assert: (OperationType fromJsonId: 'IN') equals: IncomeOperation.
	self
		assert: (OperationType fromJsonId: 'OUT')
		equals: OutcomeOperation.
	self
		assert: (OperationType fromJsonId: 'BG-TR')
		equals: BudgetTransferOperation.
	self
		assert: (OperationType fromJsonId: 'BK-TR')
		equals: BankTransferOperation
]

{ #category : #tests }
OperationTypeTest >> testInstanceCreationBankTransfer [

	self
		assert: (BankTransferOperation
				 on: (Date newDay: 1 month: 2 year: 2012)
				 from: 'source'
				 to: 'destination'
				 of: 42)
		equals: (Operation new
				 type: BankTransferOperation;
				 date: (Date newDay: 1 month: 2 year: 2012);
				 source: 'source';
				 amount: 42;
				 destination: 'destination';
				 yourself)
]

{ #category : #tests }
OperationTypeTest >> testInstanceCreationBudgetTransfer [

	self
		assert: (BudgetTransferOperation
				 on: (Date newDay: 1 month: 2 year: 2012)
				 change: 'From' -> 42 -> 'To')
		equals: (Operation new
				 type: BudgetTransferOperation;
				 date: (Date newDay: 1 month: 2 year: 2012);
				 source: 'From';
				 amount: 42;
				 destination: 'To';
				 yourself)
]

{ #category : #tests }
OperationTypeTest >> testInstanceCreationIncome [

	self
		assert: (IncomeOperation
				 on: (Date newDay: 1 month: 2 year: 2012)
				 change: 'From' -> 42 -> 'To'
				 bank: 'Bank')
		equals: (Operation new
				 type: IncomeOperation;
				 date: (Date newDay: 1 month: 2 year: 2012);
				 source: 'From';
				 amount: 42;
				 destination: 'To';
				 bank: 'Bank';
				 yourself)
]

{ #category : #tests }
OperationTypeTest >> testInstanceCreationOutcome [

	self
		assert: (OutcomeOperation
				 on: (Date newDay: 1 month: 2 year: 2012)
				 from: 'source'
				 to: 'destination'
				 of: 42
				 bank: 'Bank')
		equals: (Operation new
				 type: OutcomeOperation;
				 date: (Date newDay: 1 month: 2 year: 2012);
				 source: 'source';
				 amount: 42;
				 destination: 'destination';
				 bank: 'Bank';
				 yourself)
]
