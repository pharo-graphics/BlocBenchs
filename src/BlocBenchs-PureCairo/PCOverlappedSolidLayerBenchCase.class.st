Class {
	#name : #PCOverlappedSolidLayerBenchCase,
	#superclass : #PCLayerCompositionBenchCase,
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #hook }
PCOverlappedSolidLayerBenchCase >> indexOfElementToRefresh [

	^ self indexOfOverlappedElement
]
