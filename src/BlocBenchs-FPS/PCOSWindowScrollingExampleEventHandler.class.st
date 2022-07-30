Class {
	#name : #PCOSWindowScrollingExampleEventHandler,
	#superclass : #OSWindowGenericRendererExampleEventHandler,
	#category : #'BlocBenchs-FPS-Scrolling'
}

{ #category : #visiting }
PCOSWindowScrollingExampleEventHandler >> visitMouseWheelEvent: anEvent [

	example scrollHorizontal: anEvent scrollHorizontal.
	example scrollVertical: anEvent scrollVertical.
]
