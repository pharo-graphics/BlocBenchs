"
I represent a SDL2's SDL_WindowShapeParams union.

See: https://github.com/libsdl-org/SDL/blob/53dea9830964eee8b5c2a7ee0a65d6e268dc78a1/include/SDL_shape.h#L103
"
Class {
	#name : #'SDL_WindowShapeParams',
	#superclass : #SDL2Union,
	#category : #'BlocBenchs-SDL-ShapedWindow'
}

{ #category : #'instance creation' }
SDL_WindowShapeParams class >> binarizationCutoff: anInteger [

	^ self new
		  binarizationCutoff: anInteger;
		  yourself
]

{ #category : #'instance creation' }
SDL_WindowShapeParams class >> colorKey: aSDLColor [

	^ self new
		  colorKey: aSDLColor;
		  yourself
]

{ #category : #'field definition' }
SDL_WindowShapeParams class >> fieldsDesc [
	"
	self rebuildFieldAccessors
	"

	^#(
    Uint8 binarizationCutoff;
    SDL_Color colorKey;
 	)
]

{ #category : #'accessing - structure variables' }
SDL_WindowShapeParams >> binarizationCutoff [
	"This method was automatically generated"
	^handle unsignedByteAt: 1
]

{ #category : #'accessing - structure variables' }
SDL_WindowShapeParams >> binarizationCutoff: anInteger [
	"This method was automatically generated"
	handle unsignedByteAt: 1 put: anInteger
]

{ #category : #'accessing - structure variables' }
SDL_WindowShapeParams >> colorKey [
	"This method was automatically generated"
	^ SDL_Color fromHandle: (handle referenceStructAt: 1 length: SDL_Color byteSize)
]

{ #category : #'accessing - structure variables' }
SDL_WindowShapeParams >> colorKey: aSDLColor [
	"This method was automatically generated"
	handle structAt: 1 put: aSDLColor getHandle length: 4.
]
