Class {
	#name : #PCTopSolidLayerBenchCase,
	#superclass : #PCLayerCompositionBenchCase,
	#category : #'BlocBenchs-FPS'
}

{ #category : #hook }
PCTopSolidLayerBenchCase >> indexOfElementToRefresh [

	^ self indexOfTopElement
]
