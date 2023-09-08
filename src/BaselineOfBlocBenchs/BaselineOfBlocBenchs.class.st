Class {
	#name : #BaselineOfBlocBenchs,
	#superclass : #BaselineOf,
	#category : #BaselineOfBlocBenchs
}

{ #category : #baselines }
BaselineOfBlocBenchs >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ 
			self
				declareBlocOn: spec;
				declareToploOn: spec;
				declareFFICallLoggerOn: spec;
				declareDataFrameOn: spec;
				declareSaucoPerfMeterOn: spec;
				declareSdlExperimentsOn: spec.
			spec
				package: 'BlocBenchs-SDL'
					with: [ spec requires: #('SDLExperiments') ];
				package: 'BlocBenchs-Printing'
					with: [ spec requires: #('DataFrame') ];
				package: 'BlocBenchs-Alexandrie'
					with: [ spec requires: #('Bloc' 'BlocBenchs-Printing') ];
				package: 'BlocBenchs-BoidsExample'
					with: [ spec requires: #('Bloc') ];
				package: 'BlocBenchs-Old'
					with: [ spec requires: #('BlocBenchs-BoidsExample' 'Toplo' 'SaucoPerfMeter' 'FFICallLogger' 'BlocBenchs-Printing') ];
				package: 'BlocBenchs-FPS'
					with: [ spec requires: #('BlocBenchs-SDL' 'DataFrame' 'FFICallLogger' 'BlocBenchs-Printing') ]
			]
]

{ #category : #'external projects' }
BaselineOfBlocBenchs >> declareBlocOn: spec [

	spec
		baseline: 'Bloc'
		with: [
			spec repository: 'github://pharo-graphics/bloc:dev-1.0/src' ]
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
BaselineOfBlocBenchs >> declareSdlExperimentsOn: spec [
	spec
		baseline: 'SDLExperiments'
		with: [ spec repository: 'github://tinchodias/pharo-sdl-experiments:main/' ]
]

{ #category : #'external projects' }
BaselineOfBlocBenchs >> declareToploOn: spec [
	spec
		baseline: 'Toplo'
		with: [ spec repository: 'github://plantec/toplo:master/src' ]
]
