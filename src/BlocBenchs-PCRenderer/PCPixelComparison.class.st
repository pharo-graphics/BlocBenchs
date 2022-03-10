Class {
	#name : #PCPixelComparison,
	#superclass : #Object,
	#instVars : [
		'actualForm',
		'expectedForm'
	],
	#category : #'BlocBenchs-PCRenderer-Tests'
}

{ #category : #accessing }
PCPixelComparison >> actualForm [

	^ actualForm
]

{ #category : #accessing }
PCPixelComparison >> actualForm: anObject [

	actualForm := anObject
]

{ #category : #'as yet unclassified' }
PCPixelComparison >> actualVsExpectedMergedForm [

	| mergedForm |
	mergedForm := Form extent: (actualForm width + expectedForm width + 1) @ (expectedForm height max: actualForm height) depth: 32.
	mergedForm := mergedForm mergeWith: actualForm at: 0@0.
	mergedForm := mergedForm mergeWith: expectedForm at: (actualForm width + 1) @ 0.
		
	^ mergedForm

]

{ #category : #accessing }
PCPixelComparison >> expectedForm [

	^ expectedForm
]

{ #category : #accessing }
PCPixelComparison >> expectedForm: anObject [

	expectedForm := anObject
]

{ #category : #'as yet unclassified' }
PCPixelComparison >> inspectActualVsExpectedMergedForm [

	self actualVsExpectedMergedForm inspectWithLabel: 'actual vs. expected'
]

{ #category : #testing }
PCPixelComparison >> isMatch [

	^ 0 = (expectedForm pixelCompare: (0@0 corner: expectedForm extent) with: actualForm at: 0@0).
]
