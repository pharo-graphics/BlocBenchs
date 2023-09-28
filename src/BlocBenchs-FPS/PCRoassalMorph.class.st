Class {
	#name : 'PCRoassalMorph',
	#superclass : 'PCMorph',
	#instVars : [
		'roassalAthensMorph'
	],
	#category : 'BlocBenchs-FPS-RawMorph-Old',
	#package : 'BlocBenchs-FPS',
	#tag : 'RawMorph-Old'
}

{ #category : 'drawing' }
PCRoassalMorph >> drawOnCairoSurface [

	cairoSurface drawDuring: [ :aCairoCanvas | 
		roassalAthensMorph
			signalUpdate;
			drawOnAthensCanvas: aCairoCanvas ].
]

{ #category : 'drawing' }
PCRoassalMorph >> initializeSurface [ 

	cairoSurface := AthensCairoSurface extent: surfaceExtent.
	cairoContext := nil
]
