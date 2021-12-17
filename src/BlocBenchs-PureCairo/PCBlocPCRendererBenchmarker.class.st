Class {
	#name : #PCBlocPCRendererBenchmarker,
	#superclass : #PCBlocBenchmarker,
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #accessing }
PCBlocPCRendererBenchmarker >> host [

	^ PCMorphicWindowHost new
]

{ #category : #initialization }
PCBlocPCRendererBenchmarker >> initialize [

	super initialize.
	
	self beCairo.
]

{ #category : #accessing }
PCBlocPCRendererBenchmarker >> label [

	^ 'Bloc PureCairo'
]
