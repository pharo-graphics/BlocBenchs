Class {
	#name : #PCBlocNullRendererBenchmarker,
	#superclass : #PCBlocBenchmarker,
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #accessing }
PCBlocNullRendererBenchmarker >> host [

	^ BlMorphicWindowHostNullRenderer new
]

{ #category : #accessing }
PCBlocNullRendererBenchmarker >> label [

	^ 'Bloc NullRenderer'
]
