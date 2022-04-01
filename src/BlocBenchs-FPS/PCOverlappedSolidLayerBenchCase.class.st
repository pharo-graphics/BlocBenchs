Class {
	#name : #PCOverlappedSolidLayerBenchCase,
	#superclass : #PCLayerCompositionBenchCase,
	#category : #'BlocBenchs-FPS-Cases'
}

{ #category : #hook }
PCOverlappedSolidLayerBenchCase >> indexOfElementToRefresh [

	^ self indexOfOverlappedElement
]
