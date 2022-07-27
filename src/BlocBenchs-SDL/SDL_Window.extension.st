Extension { #name : #'SDL_Window' }

{ #category : #'*BlocBenchs-SDL' }
SDL_Window >> createSoftwareRenderer [
	^ self createRenderer: -1 flags: SDL_RENDERER_SOFTWARE 
]

{ #category : #'*BlocBenchs-SDL' }
SDL_Window >> size [
	"Answer the logical size of this window. See renderer's outputSize for the pixel size."

	| w h |
	w := FFIInt32 newBuffer.
	h := FFIInt32 newBuffer.
	self getSizeW: w h: h.
	^ (w signedLongAt: 1) @ (h signedLongAt: 1)

]
