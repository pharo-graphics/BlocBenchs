Class {
	#name : #PCRoassalHexagonMorph,
	#superclass : #PCRoassalTranslatingFiguresMorph,
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #'instance creation' }
PCRoassalHexagonMorph >> newShape: index [

	| offset translatedPoints |
	offset := case figureOffset + ((index * case horizontalSeparation) @ 0).
	translatedPoints := case vertices collect: [ :each | each + offset ].
	"Didn't find a better way to translate the shape"

	^ RSPolyline new 
		controlPoints: translatedPoints;
		noPaint;
		border: (RSBorder new
			 color: (Color random: random);
			 width: case borderWidth);
		yourself

]
