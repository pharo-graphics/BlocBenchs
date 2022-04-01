Class {
	#name : #PCOverlappedSolidLayerBenchCase,
	#superclass : #PCLayerCompositionBenchCase,
	#category : #'BlocBenchs-FPS'
}

{ #category : #hook }
PCOverlappedSolidLayerBenchCase >> indexOfElementToRefresh [

	^ self indexOfOverlappedElement
]
