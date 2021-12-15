"
Profiling case where a BlElement is shown in a space during some seconds.

"
Class {
	#name : #BlFixedDurationProfileCase,
	#superclass : #BlProfileCase,
	#instVars : [
		'duration'
	],
	#category : #'BlocBenchs-MeteringCases'
}

{ #category : #accessing }
BlFixedDurationProfileCase >> duration [

	^ duration
]

{ #category : #accessing }
BlFixedDurationProfileCase >> duration: aDuration [

	duration := aDuration
]

{ #category : #hooks }
BlFixedDurationProfileCase >> executeBody [

	self duration wait
]

{ #category : #initialization }
BlFixedDurationProfileCase >> initialize [

	super initialize.
	
	duration := 5 seconds

]
