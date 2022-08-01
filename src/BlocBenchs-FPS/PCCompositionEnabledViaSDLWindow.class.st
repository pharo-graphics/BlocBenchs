Class {
	#name : #PCCompositionEnabledViaSDLWindow,
	#superclass : #PCCompositionWindow,
	#instVars : [
		'bottomLayerTexture',
		'topLayerTextureStrategy'
	],
	#category : #'BlocBenchs-FPS-Raw'
}

{ #category : #drawing }
PCCompositionEnabledViaSDLWindow >> resetAnimation [

	super resetAnimation.

	self resetBottomLayer.
	self resetTopLayer.

]

{ #category : #drawing }
PCCompositionEnabledViaSDLWindow >> resetBottomLayer [

	bottomLayerTexture := PCDirectDrawToStreamingTextureStrategy
		newExtent: (case logicalExtent * deviceScalePoint) asIntegerPoint
		renderer: sdlRenderer
		setupBlock: self textureStrategySetupBlock.

]

{ #category : #drawing }
PCCompositionEnabledViaSDLWindow >> resetTopLayer [

	topLayerTextureStrategy := PCUpdateStaticTextureStrategy
		newExtent: (case layerExtent * deviceScalePoint) asIntegerPoint
		renderer: sdlRenderer
		setupBlock: self textureStrategySetupBlock.
	topLayerTextureStrategy setBlendEnabled.

	topLayerTextureStrategy cairoContextDo: [ :aeCairoContext |
		self drawFiguresOn: aeCairoContext ]

]

{ #category : #drawing }
PCCompositionEnabledViaSDLWindow >> step [

	self stepAnimation.

"	sdlRenderer drawBlendMode: SDL_BLENDMODE_NONE."
	sdlRenderer clear.

	bottomLayerTexture cairoContextDo: [ :aeCairoContext |
		aeCairoContext
			setSourceRGBColor: backgroundColorGenerator next;
			primPaint ].
	sdlRenderer copy: bottomLayerTexture sdlTexture.

"	sdlRenderer drawBlendMode: SDL_BLENDMODE_BLEND."
	sdlRenderer
		copy: topLayerTextureStrategy sdlTexture
			srcRect: SDL_Rect null
			dstRect: topLayerTextureStrategy sdlRect.

	sdlRenderer present
]
