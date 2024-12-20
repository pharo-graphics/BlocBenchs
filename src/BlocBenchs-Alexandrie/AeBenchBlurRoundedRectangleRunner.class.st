"
Compare several implementations to paint a blurred rounded rectangle.
"
Class {
	#name : #AeBenchBlurRoundedRectangleRunner,
	#superclass : #Object,
	#instVars : [
		'mainSurface',
		'mainContext',
		'shadowCorners',
		'shadowColor',
		'shadowRamp',
		'shadowSides',
		'rectangle',
		'blurRadius',
		'changedRadius',
		'radii'
	],
	#category : #'BlocBenchs-Alexandrie-Blur'
}
