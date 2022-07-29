Class {
	#name : #BaselineOfBlocBenchs,
	#superclass : #BaselineOf,
	#category : #BaselineOfBlocBenchs
}

{ #category : #baseline }
BaselineOfBlocBenchs >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ 
			self
				declareAlexandrieOn: spec;
				declareFFICallLoggerOn: spec;
				declareDataFrameOn: spec;
				declareSaucoPerfMeterOn: spec;
				declareSpecBrickOn: spec.
			spec
				package: 'BlocBenchs-SDL';
				package: 'BlocBenchs-Printing'
					with: [ spec requires: #('SpecBrick' 'DataFrame') ];
				package: 'BlocBenchs-Old'
					with: [ spec requires: #('SpecBrick' 'SaucoPerfMeter' 'FFICallLogger' 'BlocBenchs-Printing') ];
				package: 'BlocBenchs-FPS'
					with: [ spec requires: #('BlocBenchs-SDL' 'SpecBrick' 'DataFrame' 'FFICallLogger' 'BlocBenchs-Printing' 'Alexandrie') ]
			]
]

{ #category : #'external projects' }
BaselineOfBlocBenchs >> declareAlexandrieOn: spec [
	spec
		baseline: 'Alexandrie'
		with: [ spec repository: 'github://pharo-graphics/Alexandrie:master/src' ]
]

{ #category : #'external projects' }
BaselineOfBlocBenchs >> declareDataFrameOn: spec [
	spec
		baseline: 'DataFrame'
		with: [ spec repository: 'github://PolyMathOrg/DataFrame/src' ]
]

{ #category : #'external projects' }
BaselineOfBlocBenchs >> declareFFICallLoggerOn: spec [
	spec
		baseline: 'FFICallLogger'
		with: [ spec repository: 'github://tinchodias/FFICallLogger/' ]
]

{ #category : #'external projects' }
BaselineOfBlocBenchs >> declareSaucoPerfMeterOn: spec [
	spec
		baseline: 'SaucoPerfMeter'
		with: [ spec repository: 'github://tinchodias/pharo-sauco-profiler/' ]
]

{ #category : #'external projects' }
BaselineOfBlocBenchs >> declareSpecBrickOn: spec [
	spec
		baseline: 'SpecBrick'
		with: [ spec repository: 'github://pharo-graphics/Spec-Brick:dev-1.0/src' ]
]
