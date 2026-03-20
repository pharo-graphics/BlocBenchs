Class {
	#name : #BlBBoidsSkyCase,
	#superclass : #BlBBlocCase,
	#instVars : [
		'element'
	],
	#category : #'BlocBenchs-Benchs-Bloc'
}

{ #category : #benchmarking }
BlBBoidsSkyCase class >> benchMatrix [ 

	^ ParametrizedTestMatrix new
		addCase: { #label -> 'BlBBoidsSkyCase using custom draw'. #element -> BoidsCustomDrawSkyElement new };
		addCase: { #label -> 'BlBBoidsSkyCase using triangle geometry'. #element -> BoidsUsingTriangleSkyElement new };
		addCase: { #label -> 'BlBBoidsSkyCase using custom geometry'. #element -> BoidsCustomGeometrySkyElement new }.
]

{ #category : #accessing }
BlBBoidsSkyCase >> element: aBoidsCustomDrawSkyElement [ 
	
	element := aBoidsCustomDrawSkyElement
]

{ #category : #'instance creation' }
BlBBoidsSkyCase >> newElement [

	^ element
]
