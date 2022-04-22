Class {
	#name : #PCRoassalMorph,
	#superclass : #PCMorph,
	#instVars : [
		'roassalAthensMorph'
	],
	#category : #'BlocBenchs-FPS-RawMorph'
}

{ #category : #drawing }
PCRoassalMorph >> drawOnCairoCanvas [

	cairoSurface drawDuring: [ :aCairoCanvas | 
		roassalAthensMorph
			signalUpdate;
			drawOnAthensCanvas: aCairoCanvas ].
]

{ #category : #drawing }
PCRoassalMorph >> initializeSurface [ 

	cairoSurface := AthensCairoSurface extent: surfaceExtent.
	cairoContext := nil
]
