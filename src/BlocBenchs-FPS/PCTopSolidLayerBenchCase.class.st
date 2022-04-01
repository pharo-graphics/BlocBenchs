Class {
	#name : #PCTopSolidLayerBenchCase,
	#superclass : #PCLayerCompositionBenchCase,
	#category : #'BlocBenchs-FPS-Cases'
}

{ #category : #hook }
PCTopSolidLayerBenchCase >> indexOfElementToRefresh [

	^ self indexOfTopElement
]
