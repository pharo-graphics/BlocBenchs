Extension { #name : #'SDL_Window' }

{ #category : #'*BlocBenchs-FPS' }
SDL_Window >> size [
	"Answer the logical size of this window. See renderer's outputSize forthe pixel size."

	| w h |
	w := ByteArray new: 4.
	h := ByteArray new: 4.
	self getSizeW: w h: h.
	^ (w signedLongAt: 1) @ (h signedLongAt: 1)

]
