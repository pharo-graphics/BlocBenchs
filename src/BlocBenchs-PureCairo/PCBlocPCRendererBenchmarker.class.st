Class {
	#name : #PCBlocPCRendererBenchmarker,
	#superclass : #PCBlocBenchmarker,
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #accessing }
PCBlocPCRendererBenchmarker >> host [

	^ PCMorphicWindowHost new
]

{ #category : #accessing }
PCBlocPCRendererBenchmarker >> label [

	^ 'Bloc PureCairo'
]
