"
I'm a benchmarker for the Pure Cairo renderer.
"
Class {
	#name : #PCBlocPCRendererBenchmarker,
	#superclass : #PCBlocBenchmarker,
	#category : #'BlocBenchs-FPS-Benchmarkers'
}

{ #category : #accessing }
PCBlocPCRendererBenchmarker >> host [

	^ AeMorphicWindowHost new
]

{ #category : #accessing }
PCBlocPCRendererBenchmarker >> label [

	^ 'Bloc Alexandrie'
]
