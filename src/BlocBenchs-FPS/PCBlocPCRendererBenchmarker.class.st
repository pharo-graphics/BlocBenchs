"
I'm a benchmarker for the Pure Cairo renderer.
"
Class {
	#name : #PCBlocPCRendererBenchmarker,
	#superclass : #PCBlocBenchmarker,
	#category : #'BlocBenchs-FPS'
}

{ #category : #accessing }
PCBlocPCRendererBenchmarker >> host [

	^ PCMorphicWindowHost new
]

{ #category : #accessing }
PCBlocPCRendererBenchmarker >> label [

	^ 'Bloc PureCairo'
]
