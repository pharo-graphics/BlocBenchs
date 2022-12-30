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
				declareBlocPacOn: spec;
				declareToploOn: spec;
				declareFFICallLoggerOn: spec;
				declareDataFrameOn: spec;
				declareSaucoPerfMeterOn: spec.
			spec
				package: 'BlocBenchs-SDL';
				package: 'BlocBenchs-Printing'
					with: [ spec requires: #('DataFrame') ];
				package: 'BlocBenchs-BoidsExample'
					with: [ spec requires: #('BlocPac') ];
				package: 'BlocBenchs-Old'
					with: [ spec requires: #('BlocBenchs-BoidsExample' 'Toplo' 'SaucoPerfMeter' 'FFICallLogger' 'BlocBenchs-Printing') ];
				package: 'BlocBenchs-FPS'
					with: [ spec requires: #('BlocBenchs-SDL' 'SpecBrick' 'DataFrame' 'FFICallLogger' 'BlocBenchs-Printing' 'Alexandrie') ]
			]
]

{ #category : #'external projects' }
BaselineOfBlocBenchs >> declareBlocPacOn: spec [

	spec
		baseline: 'BlocPac'
		with: [
			spec repository: 'github://pharo-graphics/bloc-pac:dev-1.0/src' ]
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
BaselineOfBlocBenchs >> declareToploOn: spec [
	spec
		baseline: 'Toplo'
		with: [ spec repository: 'github://plantec/toplo:master/src' ]
]
