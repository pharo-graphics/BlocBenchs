"
I represent a SDL2's WindowShapeMode enum.

See: https://github.com/libsdl-org/SDL/blob/53dea9830964eee8b5c2a7ee0a65d6e268dc78a1/include/SDL_shape.h#L94

"
Class {
	#name : #'SDL_WindowShapeModeEnum',
	#superclass : #FFIExternalEnumeration,
	#classVars : [
		'ShapeModeBinarizeAlpha',
		'ShapeModeColorKey',
		'ShapeModeDefault',
		'ShapeModeReverseBinarizeAlpha'
	],
	#category : #'BlocBenchs-SDL'
}

{ #category : #'accessing enum' }
SDL_WindowShapeModeEnum class >> ShapeModeBinarizeAlpha [
	"This method was automatically generated"
	^ ShapeModeBinarizeAlpha
]

{ #category : #'accessing enum' }
SDL_WindowShapeModeEnum class >> ShapeModeColorKey [
	"This method was automatically generated"
	^ ShapeModeColorKey
]

{ #category : #'accessing enum' }
SDL_WindowShapeModeEnum class >> ShapeModeDefault [
	"This method was automatically generated"
	^ ShapeModeDefault
]

{ #category : #'accessing enum' }
SDL_WindowShapeModeEnum class >> ShapeModeReverseBinarizeAlpha [
	"This method was automatically generated"
	^ ShapeModeReverseBinarizeAlpha
]

{ #category : #'enum declaration' }
SDL_WindowShapeModeEnum class >> enumDecl [
	"
	self rebuildEnumAccessors
	"

	^ #(
ShapeModeDefault 0
ShapeModeBinarizeAlpha 1
ShapeModeReverseBinarizeAlpha 2
ShapeModeColorKey 3
	)
]

{ #category : #initialization }
SDL_WindowShapeModeEnum class >> initialize [
	self initializeEnumeration
]
