Extension { #name : #'SDL_RendererInfo' }

{ #category : #'*BlocBenchs-FPS' }
SDL_RendererInfo >> nameString [

	^ self name fromCString
]

{ #category : #'*BlocBenchs-FPS' }
SDL_RendererInfo >> printOn: aStream [

	super printOn: aStream.

	aStream
		nextPutAll: '(';
		nextPutAll: self nameString;
		nextPutAll: ' '.
	
	(#(isSoftware
	isAccelerated
	isSupportRenderTexture
	isSynchronizedWithRefreshRate)
		select:[ :each | (self perform: each) ])
			do: [ :each | aStream nextPutAll: each  ]
			separatedBy: [ aStream nextPutAll: ' ' ].

	aStream nextPutAll: ')'
]
