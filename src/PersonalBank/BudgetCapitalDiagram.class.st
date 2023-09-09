Class {
	#name : #BudgetCapitalDiagram,
	#superclass : #Model,
	#instVars : [
		'original',
		'containerBeingInspected',
		'canvas',
		'pie',
		'outerPie',
		'subContainersToDisplay',
		'shouldShowAmounts',
		'date'
	],
	#category : #'PersonalBank-GUI'
}

{ #category : #utilities }
BudgetCapitalDiagram class >> onContainer: budgets [

	^ self new setOriginal: budgets
]

{ #category : #utilities }
BudgetCapitalDiagram >> build [

	containerBeingInspected := original.
	subContainersToDisplay := self containersToDisplayFromBudgets:
		                          original.

	pie := RSPie new.
	outerPie := RSPie new.
	pie
		objects: subContainersToDisplay;
		slice: [ :each | 
			each roundedValuationWithSubcontainersOn: self date ].
	pie sliceShape
		externalRadius: 120;
		innerRadius: 50;
		border: (RSBorder new
				 width: 0.2;
				 color: self theme backgroundColor);
		segmentSpacing: 0.
	pie container: canvas.

	outerPie := RSPie new.
	outerPie
		objects: self outerPieObjects;
		slice: [ :each | 
			each class = Container
				ifTrue: [ each roundedValuationWithSubcontainersOn: self date ]
				ifFalse: [ each ] ].
	outerPie sliceShape
		externalRadius: 140;
		innerRadius: 120;
		border: (RSBorder new
				 width: 0.2;
				 color: self theme backgroundColor);
		segmentSpacing: 0.
	outerPie container: canvas.
	self rebuildPie.


	canvas color: self theme backgroundColor.

	^ canvas
]

{ #category : #accessing }
BudgetCapitalDiagram >> canvas [

	^ canvas
]

{ #category : #query }
BudgetCapitalDiagram >> containersToDisplayFromBudgets: budgets [

	^ (budgets subcontainers reject: [ :each | 
		   (each roundedValuationWithSubcontainersOn: self date) <= 0 ]) 
		  asSortedCollection: [ :a :b | 
			  (a roundedValuationWithSubcontainersOn: self date)
			  > (b roundedValuationWithSubcontainersOn: self date) ]
]

{ #category : #accessing }
BudgetCapitalDiagram >> date [

	^ date
]

{ #category : #accessing }
BudgetCapitalDiagram >> date: anObject [

	date := anObject
]

{ #category : #utilities }
BudgetCapitalDiagram >> findFirstSubcontainerHavingSeveralSubcontainersStartingWith: budgets [

	| container |
	container := budgets.

	[ container subcontainers size <= 1 ] whileTrue: [ 
		container subcontainers isEmpty ifTrue: [ ^ container ].
		container := container subcontainers first ].
	^ container
]

{ #category : #initialization }
BudgetCapitalDiagram >> initialize [

	date := Date today.
	shouldShowAmounts := false.
	canvas := RSCanvas new.

	canvas when: RSExtentChangedEvent do: [ canvas zoomToFit ] for: self
]

{ #category : #query }
BudgetCapitalDiagram >> legendTitle [

	^ self shouldShowAmounts
		  ifTrue: [ 
			  'Total in ' , containerBeingInspected name , ': '
			  , (pie totalSum printShowingDecimalPlaces: 2) ]
		  ifFalse: [ containerBeingInspected name ]
]

{ #category : #utilities }
BudgetCapitalDiagram >> outerPieObjects [

	| objects |
	objects := OrderedCollection new.
	subContainersToDisplay do: [ :each | 
		| valuation |
		objects addAll: (self containersToDisplayFromBudgets: each).
		valuation := each roundedValuationOn: self date.
		valuation isZero ifFalse: [ objects add: valuation ] ].
	^ objects
]

{ #category : #utilities }
BudgetCapitalDiagram >> rebuildLegendForPie [

	| pieCanvas legend colors |
	pieCanvas := pie canvas.
	legend := RSLegend new.
	colors := NSScale category20b.
	legend defaultLabel: (RSLabel new
			 color: self theme textColor;
			 fontSize: 12;
			 yourself).
	legend defaultTitle: (RSLabel new
			 color: self theme textColor;
			 fontSize: 16;
			 yourself).
	legend beFixedWithTitle: self legendTitle.
	legend text: self date displayString.
	legend text: 'Details:'.
	(containerBeingInspected subcontainers asSortedCollection: [ :a :b | 
		 (a roundedValuationWithSubcontainersOn: self date)
		 > (b roundedValuationWithSubcontainersOn: self date) ]) do: [ 
		:eachSubcontainer | 
		| proportion text |
		proportion := ((eachSubcontainer 
			                roundedValuationWithSubcontainersOn: self date)
		               * 100 / pie totalSum) rounded.

		text := legend
			        text: (String streamContents: [ :stream | 
					         stream nextPutAll: eachSubcontainer name.
					         self shouldShowAmounts ifTrue: [ 
						         stream
							         nextPutAll: ' - ';
							         nextPutAll:
								         (eachSubcontainer 
									          roundedValuationWithSubcontainersOn: self date)
									         asString ].
					         proportion > 0 ifTrue: [ 
						         stream
							         nextPutAll: ' - ';
							         nextPutAll: proportion asString;
							         nextPutAll: '%' ] ])
			        withCircleColor: colors.
		(eachSubcontainer roundedValuationWithSubcontainersOn: self date)
		< 0 ifTrue: [ 
			(text children detect: [ :each | each isLabel ]) color:
				self theme dangerTextColor ] ].

	legend legendDo: [ :l | l padding: 20 ].
	legend container: pieCanvas.
	legend build
]

{ #category : #utilities }
BudgetCapitalDiagram >> rebuildPie [

	| pieCanvas labels pieColors outerPieCanvas outerLabels |
	pieCanvas := pie canvas.
	outerPieCanvas := outerPie canvas.
	pieCanvas shapes , pieCanvas fixedShapes do: [ :each | each remove ].
	outerPieCanvas shapes do: [ :each | each remove ].
	pie shapes ifNotNil: [ :shapes | shapes do: [ :each | each remove ] ].
	outerPie shapes ifNotNil: [ :shapes | 
		shapes do: [ :each | each remove ] ].
	pie slice: [ :each | 
		each roundedValuationWithSubcontainersOn: self date ].
	pieColors := NSScale category20b.
	pie sliceColor: pieColors.
	pie build.
	labels := RSPieLabeledInteraction new.
	labels labelShape fontSize: 7.
	labels
		labelColor: self theme textColor;
		labelText: [ :obj | 
			| proportion |
			proportion := ((obj roundedValuationWithSubcontainersOn: self date)
			               * 100 / pie totalSum) rounded.
			proportion > 0
				ifTrue: [ obj name ]
				ifFalse: [ '' ] ].
	pie shapes @ labels.
	pie shapes @ (RSPopup text: [ :obj | 
		 String streamContents: [ :stream | 
			 obj
				 printValuationOn: self date
				 hideAmounts: self shouldShowAmounts not
				 onStream: stream ] ]).
	pie container: canvas.
	outerPie
		objects: self outerPieObjects;
		slice: [ :each | 
			each class = Container
				ifTrue: [ each roundedValuationWithSubcontainersOn: self date ]
				ifFalse: [ each ] ].
	outerPie sliceColor: [ :obj | 
		obj model class = Container
			ifTrue: [ 
				| mainColor |
				mainColor := pieColors rsValue: (pie shapes detect: [ :each | 
						              each model subcontainers identityIncludes:
							              obj model ]).
				mainColor ]
			ifFalse: [ self theme backgroundColor ] ].
	outerPie build.
	outerLabels := RSPieLabeledInteraction new.
	outerLabels labelShape fontSize: 4.
	outerLabels
		labelColor: self theme textColor;
		labelText: [ :obj | 
			obj class = Container
				ifTrue: [ 
					| proportion |
					proportion := ((obj roundedValuationWithSubcontainersOn:
							                self date) * 100 / pie totalSum) rounded.
					proportion > 0
						ifTrue: [ obj name ]
						ifFalse: [ '' ] ]
				ifFalse: [ '' ] ].
	outerPie shapes @ outerLabels.
	outerPie shapes @ (RSPopup text: [ :obj | 
		 String streamContents: [ :stream | 
			 obj class = Container
				 ifTrue: [ 
					 obj
						 printValuationOn: self date
						 hideAmounts: self shouldShowAmounts not
						 onStream: stream ]
				 ifFalse: [ obj printOn: stream ] ] ]).
	outerPie container: canvas.
	self registerMouseEventsOnPie.
	self rebuildLegendForPie
]

{ #category : #utilities }
BudgetCapitalDiagram >> registerMouseEventsOnPie [

	pie shapes , outerPie shapes
		when: RSMouseLeftClick
		do: [ :evt | 
			| containersToDisplay |
			containersToDisplay := self containersToDisplayFromBudgets:
				                       evt shape model.
			containersToDisplay ifNotEmpty: [ 
				subContainersToDisplay removeAll.
				subContainersToDisplay addAll: containersToDisplay.
				containerBeingInspected := evt shape model ].
			self rebuildPie ]
		for: self.
	pie shapes , outerPie shapes
		when: RSMouseRightClick
		do: [ :evt | 
			subContainersToDisplay removeAll.
			subContainersToDisplay addAll:
				(self containersToDisplayFromBudgets: original).
			containerBeingInspected := original.
			self rebuildPie ]
		for: self
]

{ #category : #accessing }
BudgetCapitalDiagram >> setOriginal: aContainer [

	original := self 
		            findFirstSubcontainerHavingSeveralSubcontainersStartingWith:
		            aContainer
]

{ #category : #accessing }
BudgetCapitalDiagram >> shouldShowAmounts [

	^ shouldShowAmounts
]

{ #category : #accessing }
BudgetCapitalDiagram >> shouldShowAmounts: anObject [

	shouldShowAmounts := anObject
]
