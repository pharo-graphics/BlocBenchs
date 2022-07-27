Extension { #name : #'SDL_Point' }

{ #category : #'*BlocBenchs-SDL' }
SDL_Point class >> newX: x y: y [

	^ self new
		  x: x;
		  y: y;
		  yourself
]
