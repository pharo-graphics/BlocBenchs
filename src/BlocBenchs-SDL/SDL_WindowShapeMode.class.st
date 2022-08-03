"
I represent a SDL2's SDL_WindowShapeMode.

See: https://github.com/libsdl-org/SDL/blob/53dea9830964eee8b5c2a7ee0a65d6e268dc78a1/include/SDL_shape.h#L111
"
Class {
	#name : #'SDL_WindowShapeMode',
	#superclass : #SDL2Structure,
	#classVars : [
		'OFFSET_MODE',
		'OFFSET_PARAMETERS'
	],
	#category : #'BlocBenchs-SDL-ShapedWindow'
}

{ #category : #'field definition' }
SDL_WindowShapeMode class >> fieldsDesc [
	"
	self rebuildFieldAccessors
	"

	^ #(
		SDL_WindowShapeModeEnum mode;
		SDL_WindowShapeParams parameters;
		)
]

{ #category : #'instance creation' }
SDL_WindowShapeMode class >> mode: aSDL_WindowShapeModeEnum parameters: aSDL_WindowShapeParams [

	^ self new
		  mode: aSDL_WindowShapeModeEnum;
		  parameters: aSDL_WindowShapeParams;
		  yourself
]

{ #category : #'accessing - structure variables' }
SDL_WindowShapeMode >> mode [
	"This method was automatically generated"
	^SDL_WindowShapeModeEnum fromInteger: (handle unsignedLongAt: OFFSET_MODE)
]

{ #category : #'accessing - structure variables' }
SDL_WindowShapeMode >> mode: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: OFFSET_MODE put: anObject value
]

{ #category : #'accessing - structure variables' }
SDL_WindowShapeMode >> parameters [
	"This method was automatically generated"
	^ SDL_WindowShapeParams fromHandle: (handle referenceStructAt: OFFSET_PARAMETERS length: SDL_WindowShapeParams byteSize)
]

{ #category : #'accessing - structure variables' }
SDL_WindowShapeMode >> parameters: anObject [
	"This method was automatically generated"
	handle structAt: OFFSET_PARAMETERS put: anObject getHandle length: SDL_WindowShapeParams byteSize
]
