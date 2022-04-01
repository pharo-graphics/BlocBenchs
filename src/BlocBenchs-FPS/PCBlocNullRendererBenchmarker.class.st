"
I'm a benchmarker for the Null renderer.
"
Class {
	#name : #PCBlocNullRendererBenchmarker,
	#superclass : #PCBlocBenchmarker,
	#category : #'BlocBenchs-FPS'
}

{ #category : #accessing }
PCBlocNullRendererBenchmarker >> host [

	^ BlNullRendererMorphicWindowHost new
]

{ #category : #accessing }
PCBlocNullRendererBenchmarker >> label [

	^ 'Bloc NullRenderer'
]
