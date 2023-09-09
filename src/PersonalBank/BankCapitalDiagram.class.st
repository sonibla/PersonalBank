Class {
	#name : #BankCapitalDiagram,
	#superclass : #Model,
	#instVars : [
		'canvas',
		'shouldShowAmounts',
		'date',
		'banks'
	],
	#category : #'PersonalBank-GUI'
}

{ #category : #utilities }
BankCapitalDiagram class >> onContainer: banks [

	^ self new setContainer: banks
]

{ #category : #accessing }
BankCapitalDiagram >> bankCapitals [

	^ banks subcontainers
		  collect: [ :each | 
		  each name -> (each roundedValuationOn: Date today) ]
		  as: Set
]

{ #category : #accessing }
BankCapitalDiagram >> build [

	| data pie pieLabel legend colors |
	data := self bankCapitals sorted: [ :a :b | a value > b value ].
	pie := RSPie new
		       objects: (data reject: [ :each | each value <= 0 ]);
		       slice: #value.

	pie container: canvas.
	pie sliceShape
		externalRadius: 240;
		innerRadius: 150;
		segmentSpacing: 0.
	pie sliceColor: NSScale category20b.
	pieLabel := RSPieLabeledInteraction new.
	pieLabel labelShape fontSize: 13.
	pieLabel labelColor: self theme textColor.
	pieLabel labelText: [ :obj | 
		| proportion |
		proportion := (obj value * 100 / pie totalSum) rounded.
		proportion > 0
			ifTrue: [ obj key ]
			ifFalse: [ '' ] ].

	pie build.
	pie canvas
		when: RSExtentChangedEvent
		do: [ pie canvas zoomToFit ]
		for: self.
	pie shapes @ (RSPopup text: [ :obj | 
		 | proportion |
		 proportion := (obj value * 100 / pie totalSum) rounded.
		 String streamContents: [ :stream | 
			 stream nextPutAll: obj key.
			 self shouldShowAmounts ifTrue: [ 
				 stream
					 nextPutAll: ' - ';
					 nextPutAll: obj value asString ].
			 proportion > 0 ifTrue: [ 
				 stream
					 nextPutAll: ' - ';
					 nextPutAll: proportion asString;
					 nextPutAll: '%' ] ] ]).
	pie shapes @ pieLabel.
	canvas color: self theme backgroundColor.
	legend := RSLegend new.
	colors := NSScale category20b.
	legend defaultLabel: (RSLabel new
			 color: self theme textColor;
			 fontSize: 15;
			 yourself).
	legend defaultTitle: (RSLabel new
			 color: self theme textColor;
			 fontSize: 18;
			 yourself).
	legend title: (self shouldShowAmounts
			 ifTrue: [ 'Total: ' , (pie totalSum printShowingDecimalPlaces: 2) ]
			 ifFalse: [ 'Details:' ]).
	data do: [ :eachBank | 
		| proportion text |
		proportion := (eachBank value * 100 / pie totalSum) rounded.

		text := legend
			        text: (String streamContents: [ :stream | 
					         stream nextPutAll: eachBank key.
					         self shouldShowAmounts ifTrue: [ 
						         stream
							         nextPutAll: ' - ';
							         nextPutAll: eachBank value asString ].
					         proportion > 0 ifTrue: [ 
						         stream
							         nextPutAll: ' - ';
							         nextPutAll: proportion asString;
							         nextPutAll: '%' ] ])
			        withCircleColor: colors.
		eachBank value < 0 ifTrue: [ 
			(text children detect: [ :each | each isLabel ]) color:
				self theme dangerTextColor ] ].

	legend legendDo: [ :l | l padding: 20 ].
	legend container: canvas.
	legend build.
	^ canvas
]

{ #category : #accessing }
BankCapitalDiagram >> canvas [

	^ canvas
]

{ #category : #accessing }
BankCapitalDiagram >> date [

	^ date
]

{ #category : #accessing }
BankCapitalDiagram >> date: anObject [

	date := anObject
]

{ #category : #initialization }
BankCapitalDiagram >> initialize [

	date := Date today.
	shouldShowAmounts := false.
	canvas := RSCanvas new.

	canvas when: RSExtentChangedEvent do: [ canvas zoomToFit ] for: self
]

{ #category : #initialization }
BankCapitalDiagram >> setContainer: aContainer [

	banks := aContainer
]

{ #category : #accessing }
BankCapitalDiagram >> shouldShowAmounts [

	^ shouldShowAmounts
]

{ #category : #accessing }
BankCapitalDiagram >> shouldShowAmounts: anObject [

	shouldShowAmounts := anObject
]
