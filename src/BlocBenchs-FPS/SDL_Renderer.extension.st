Extension { #name : #'SDL_Renderer' }

{ #category : #'*BlocBenchs-FPS' }
SDL_Renderer >> copy: texture srcRect: srcRect dstRect: dstRect angle: angle center: center [

	^ self ffiCall: #( 
		int SDL_RenderCopyEx (
			self,
			SDL_Texture texture,
			const SDL_Rect * srcRect,
			const SDL_Rect * dstRect,
			const double angle,
			const SDL_Point * center,
			const "SDL_RendererFlip"int 2) )

]
