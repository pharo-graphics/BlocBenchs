Class {
	#name : #BlNullRenderer,
	#superclass : #BlHostRenderer,
	#category : #'BlocBenchs-NullRenderer'
}

{ #category : #initialization }
BlNullRenderer >> initializeForHostSpace: aBlHostSpace [
	"Initialize this renderer for a given host space.
	Please note, that it I be called multiple times"
	
	session := Smalltalk session.
	
	"we should mark it as a current one before initializing a canvas as it may rely on opengl context"
	aBlHostSpace makeCurrent.
	
	"create a new surface of a specific type for a given host space"
	surface := BlHostRendererNullSurface new.
	surface initializeForHostSpace: aBlHostSpace.

	"creates surfaceRenderer and allocate / initialize a surface"
	surfaceRenderer := surface createSurfaceRendererOn: aBlHostSpace.
	surfaceRenderer initializeForSurface: surface.

	"creates spaceRenderer from the allocated surface"
	spaceRenderer := surface createSpaceRendererOn: self.
	spaceRenderer initializeForSurface: surface.

	textMeasurer := BlMockedTextMeasurer new
		ascent: -10;
		descent: 5;
		glyphWidth: 10;
		height: 15;
		yourself

]