"
I replace GrafPort but only for swapping bytes.

The intention was optimizing FPS but didn't improve it.

"
Class {
	#name : #PCBitBlt,
	#superclass : #BitBlt,
	#category : #'BlocBenchs-FPS'
}

{ #category : #'instance creation' }
PCBitBlt class >> sourceForm: aForm sourceRect: sourceRectangle [
	"More info about combinationRule in: https://github.com/pharo-project/opensmalltalk-vm/blob/pharo-9/smalltalksrc/VMMaker/BitBltSimulation.class.st
	Values other than 34 such as Form over or Form paint only lowered FPS from 77 to 67."

	^ self new
		  sourceForm: aForm;
		  sourceRect: sourceRectangle;
		  combinationRule: 34;
		  yourself
]

{ #category : #copying }
PCBitBlt >> copyBitsTo: aForm at: aPoint clipRect: aRectangle [

	self
		setDestForm: aForm;
		destOrigin: aPoint;
		clipRect: aRectangle;
		copyBits
]
