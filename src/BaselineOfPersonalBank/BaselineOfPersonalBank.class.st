Class {
	#name : #BaselineOfPersonalBank,
	#superclass : #BaselineOf,
	#category : #BaselineOfPersonalBank
}

{ #category : #baselines }
BaselineOfPersonalBank >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
		spec
			baseline: 'Roassal3' with: [ 
				spec
					repository: 'github://ObjectProfile/Roassal3/src';
					loads: #( 'Full' ) ];
			package: 'PersonalBank' with: [ spec requires: #( 'Roassal3' ) ];
			package: 'PersonalBank-Tests'
			with: [ spec requires: #( 'PersonalBank' 'Roassal3' ) ] ]
]
