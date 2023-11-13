"
Profiling case where Boids example is shown in a space during some seconds.
"
Class {
	#name : #BlBoidsProfileCase,
	#superclass : #BlFixedDurationProfileCase,
	#instVars : [
		'boidsSkyElementClass'
	],
	#category : #'BlocBenchs-Old-ProfileCases'
}

{ #category : #examples }
BlBoidsProfileCase class >> exampleFFI [
	
	[ 	| case |
		case := self new
			hostClass: BlOSWindowSDL2Host;
			yourself.

		(BlProfileRunner newForCase: case)
			enableFFICounter;
"			enableFFILogger;"
			run;
			openMeterReports ] fork
]

{ #category : #examples }
BlBoidsProfileCase class >> exampleFPS [
	
	[ 	| case |
		case := self new
			hostClass: BlOSWindowSDL2Host;
			yourself.

		(BlProfileRunner newForCase: case)
			enableFPS;
			run;
			openMeterReports ] fork
]

{ #category : #examples }
BlBoidsProfileCase class >> exampleProfile [
	
	[ 	| case |
		case := self new
			hostClass: BlOSWindowSDL2Host;
			yourself.

		(BlProfileRunner newForCase: case)
			enableASProfiler;
			run;
			openMeterReports ] fork
]

{ #category : #accessing }
BlBoidsProfileCase >> boidsSkyElementClass [

	^ boidsSkyElementClass
]

{ #category : #accessing }
BlBoidsProfileCase >> boidsSkyElementClass: aBoidsSkyElementClass [

	boidsSkyElementClass := aBoidsSkyElementClass
]

{ #category : #initialization }
BlBoidsProfileCase >> initialize [ 

	super initialize.
	
	boidsSkyElementClass := BoidsSkyUsingGeometryElement 
]

{ #category : #hooks }
BlBoidsProfileCase >> newElement [

	^ boidsSkyElementClass new
]
