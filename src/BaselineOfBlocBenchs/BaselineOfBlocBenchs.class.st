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
				declareBoidsOn: spec;
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
				package: 'BlocBenchs-Old'
					with: [ spec requires: #('BlocTutorialsBoids' 'Toplo' 'SaucoPerfMeter' 'FFICallLogger' 'BlocBenchs-Printing') ];
				package: 'BlocBenchs-FPS'
					with: [ spec requires: #('BlocBenchs-SDL' 'DataFrame' 'FFICallLogger' 'BlocBenchs-Printing') ];
				package: 'BlocBenchs-Alexandrie'
					with: [ spec requires: #('Toplo' 'BlocBenchs-Printing' 'BlocBenchs-FPS') ];
				package: 'BlocBenchs-Tests'
					with: [ spec requires: #('BlocBenchs-SDL' 'BlocBenchs-Alexandrie' 'BlocBenchs-Old' 'BlocBenchs-FPS') ];
				package: 'BlocBenchs-Core'
					with: [ spec requires: #('Bloc' 'BlocBenchs-FPS' 'FFICallLogger' 'SaucoPerfMeter' 'SDLExperiments') ];
				package: 'BlocBenchs-Benchs'
					with: [ spec requires: #('Toplo' 'BlocBenchs-Core' 'BlocTutorialsBoids') ]		
			]
]

{ #category : #'external projects' }
BaselineOfBlocBenchs >> declareBlocOn: spec [

	spec
		baseline: 'Bloc'
		with: [
			spec repository: 'github://pharo-graphics/Bloc:master/src' ]
]

{ #category : #'external projects' }
BaselineOfBlocBenchs >> declareBoidsOn: spec [

	spec
		baseline: 'BlocTutorialsBoids'
		with: [
			spec repository: 'github://pharo-graphics/Tutorials:master/src' ]
]

{ #category : #'external projects' }
BaselineOfBlocBenchs >> declareDataFrameOn: spec [
	spec
		baseline: 'DataFrame'
		with: [ spec repository: 'github://PolyMathOrg/DataFrame:master/src' ]
]

{ #category : #'external projects' }
BaselineOfBlocBenchs >> declareFFICallLoggerOn: spec [
	spec
		baseline: 'FFICallLogger'
		with: [ spec repository: 'github://tinchodias/FFICallLogger:master/' ]
]

{ #category : #'external projects' }
BaselineOfBlocBenchs >> declareSaucoPerfMeterOn: spec [
	spec
		baseline: 'SaucoPerfMeter'
		with: [ spec repository: 'github://tinchodias/pharo-sauco-profiler:master/' ]
]

{ #category : #'external projects' }
BaselineOfBlocBenchs >> declareSdlExperimentsOn: spec [
	spec
		baseline: 'SDLExperiments'
		with: [ spec repository: 'github://pharo-graphics/pharo-sdl-experiments:master/' ]
]

{ #category : #'external projects' }
BaselineOfBlocBenchs >> declareToploOn: spec [
	spec
		baseline: 'Toplo'
		with: [ spec repository: 'github://pharo-graphics/Toplo:dev/src' ]
]
