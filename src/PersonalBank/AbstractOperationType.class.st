Class {
	#name : #AbstractOperationType,
	#superclass : #Object,
	#category : #'PersonalBank-Core'
}

{ #category : #accessing }
AbstractOperationType class >> icon [

	^ Smalltalk ui theme iconNamed: self iconName
]

{ #category : #accessing }
AbstractOperationType class >> iconName [

	self subclassResponsibility
]

{ #category : #accessing }
AbstractOperationType class >> isAbstract [

	^ true
]

{ #category : #accessing }
AbstractOperationType class >> possibleTypes [

	^ self allSubclasses reject: [ :each | each isAbstract ]
]
