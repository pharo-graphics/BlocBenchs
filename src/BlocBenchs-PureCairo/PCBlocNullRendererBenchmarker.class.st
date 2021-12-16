Class {
	#name : #PCBlocNullRendererBenchmarker,
	#superclass : #PCBlocBenchmarker,
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #accessing }
PCBlocNullRendererBenchmarker >> host [

	^ BlMorphicWindowHostNullRenderer new
]

{ #category : #initialization }
PCBlocNullRendererBenchmarker >> initialize [

	super initialize.
	
	self beCairo.
]

{ #category : #accessing }
PCBlocNullRendererBenchmarker >> label [

	^ 'Bloc NullRenderer'
]
