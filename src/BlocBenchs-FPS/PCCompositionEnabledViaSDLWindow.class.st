Class {
	#name : #PCCompositionEnabledViaSDLWindow,
	#superclass : #PCCompositionWindow,
	#instVars : [
		'bottomLayerTexture',
		'topLayerTexture'
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

	bottomLayerTexture := PCStreamingSDLTexture
		newExtent: (case logicalExtent * deviceScalePoint) asIntegerPoint
		renderer: sdlRenderer
		setupBlock: self textureSetupBlock.

]

{ #category : #drawing }
PCCompositionEnabledViaSDLWindow >> resetTopLayer [

	topLayerTexture := PCStaticSDLTexture
		newExtent: (case layerExtent * deviceScalePoint) asIntegerPoint
		renderer: sdlRenderer
		setupBlock: self textureSetupBlock.
	topLayerTexture setBlendEnabled.

	topLayerTexture cairoContextDo: [ :aeCairoContext |
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
		copy: topLayerTexture sdlTexture
			srcRect: SDL_Rect null
			dstRect: topLayerTexture sdlRect.

	sdlRenderer present
]
