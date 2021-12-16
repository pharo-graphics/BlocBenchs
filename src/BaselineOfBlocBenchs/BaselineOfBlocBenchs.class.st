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
				declareFFICallLoggerOn: spec;
				declareDataFrameOn: spec;
				declareSaucoPerfMeterOn: spec;
				declareSpecBrickOn: spec.

			spec
				package: 'BlocBenchs-MeteringCases'
					with: [ spec requires: #('SpecBrick' 'SaucoPerfMeter' 'FFICallLogger') ];
				package: 'BlocBenchs-Printing'
					with: [ spec requires: #('SpecBrick' 'BlocBenchs-MeteringCases' 'DataFrame') ];
				package: 'BlocBenchs-NullRenderer'
					with: [ spec requires: #('SpecBrick') ];
				package: 'BlocBenchs-PureCairo'
					with: [ spec requires: #('SpecBrick' 'BlocBenchs-Printing' 'DataFrame' 'FFICallLogger' 'BlocBenchs-NullRenderer') ];
				package: 'BlocBenchs-Sparta'
					with: [ spec requires: #('SpecBrick' 'BlocBenchs-Printing' 'DataFrame') ].
 ]
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
		with: [ spec repository: 'github://pharo-graphics/Spec-Brick/src' ]
]
