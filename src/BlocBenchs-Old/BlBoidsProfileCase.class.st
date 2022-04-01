"
Profiling case where Boids example is shown in a space during some seconds.
"
Class {
	#name : #BlBoidsProfileCase,
	#superclass : #BlFixedDurationProfileCase,
	#instVars : [
		'boidsSkyElementClass'
	],
	#category : #'BlocBenchs-Old'
}

{ #category : #accessing }
BlBoidsProfileCase >> boidsSkyElementClass [

	^ boidsSkyElementClass
]

{ #category : #accessing }
BlBoidsProfileCase >> boidsSkyElementClass: aBoidsSkyElementClass [

	boidsSkyElementClass := aBoidsSkyElementClass
]

{ #category : #hooks }
BlBoidsProfileCase >> initialize [ 

	super initialize.
	
	boidsSkyElementClass := BoidsCustomDrawSkyElement

]

{ #category : #hooks }
BlBoidsProfileCase >> newElement [

	^ boidsSkyElementClass new
]
