"
I'm a benchmarker for the Pure Cairo renderer.
"
Class {
	#name : #PCBlocAlexandrieBenchmarker,
	#superclass : #PCBlocBenchmarker,
	#category : 'BlocBenchs-FPS-Benchmarkers'
}

{ #category : #accessing }
PCBlocAlexandrieBenchmarker >> host [

	^ BlOSWindowSDL2Host new
]

{ #category : #accessing }
PCBlocAlexandrieBenchmarker >> label [

	^ 'Bloc Alexandrie'
]
