Class {
	#name : #PCAddingCirclesMorph,
	#superclass : #PCMorph,
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #drawing }
PCAddingCirclesMorph >> drawOnAthensCanvas: aCanvas [

	| transform builder w h x y |
	w := surfaceExtent x / 2.0.
	h := surfaceExtent y / 2.0.
	x := random nextInteger: w.
	y := random nextInteger: h.
	transform := AthensCairoTransform for: aCanvas.

	transform save.

	transform translateX: x Y: y.
	aCanvas surface loadSolidColor: (Color random: random).

	builder := AthensCairoPathBuilder new.
	builder context: aCanvas.
	builder
		arcCenterX: 0.0
		centerY: 0.0
		radius: w / 4 * (random next + 0.1)
		startAngle: 0.0
		endAngle: Float pi * 2.
	aCanvas fill.

	transform restore.

]
