Extension { #name : #'SDL_Renderer' }

{ #category : #'*BlocBenchs-SDL' }
SDL_Renderer >> copy: texture srcRect: srcRect dstRect: dstRect angle: angle center: center [
	"Copy a portion of the texture to the current rendering, with optional rotation and flipping.
	
	* srcRect: the source SDL_Rect structure or NULL for the entire texture.
	* dstRect: the destination SDL_Rect structure or NULL for the entire rendering target.
	* angle: The angle is spedified in degrees to indicate the rotation that will be applied to dstRect, rotating it in a clockwise direction.
	* center: a Point indicating the point around which dstRect will be rotated (if NULL, rotation will be done around `dstRect extent / 2`).
	
	See: https://wiki.libsdl.org/SDL_RenderCopyEx"

	^ self ffiCall: #( 
		int 
		SDL_RenderCopyEx (
			self,
			SDL_Texture texture,
			const SDL_Rect * srcRect,
			const SDL_Rect * dstRect,
			const double angle,
			const SDL_Point * center,
			const "SDL_RendererFlip"int 2) )

]

{ #category : #'*BlocBenchs-SDL' }
SDL_Renderer >> newTextureFromSurface: aSurface [

	^ (self primCreateTextureFromSurface: aSurface)
		  autoRelease;
		  yourself
]

{ #category : #'*BlocBenchs-SDL' }
SDL_Renderer >> primCreateTextureFromSurface: aSurface [

	^ self ffiCall: #( SDL_Texture SDL_CreateTextureFromSurface (
		self, 
		SDL_Surface aSurface ) )
]
