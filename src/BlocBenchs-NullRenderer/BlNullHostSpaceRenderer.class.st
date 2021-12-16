Class {
	#name : #BlNullHostSpaceRenderer,
	#superclass : #BlHostSpaceRenderer,
	#category : #'BlocBenchs-NullRenderer'
}

{ #category : #initialization }
BlNullHostSpaceRenderer >> initializeForSurface: aSurface [
	"Initalize space renderer to be used with a given surface"

	"Nothing"
]

{ #category : #rendering }
BlNullHostSpaceRenderer >> renderSpace: aSpace [
	"Render a space and return a collection of damaged rectangles"
	<return: #Collection of: #Rectangle>
	
	^ #()
]
