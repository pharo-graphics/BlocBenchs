Class {
	#name : #AeGradientBlurFilter,
	#superclass : #Object,
	#instVars : [
		'blurMargin',
		'ramp',
		'color',
		'context'
	],
	#category : #'BlocBenchs-Alexandrie-Blur'
}

{ #category : #drawing }
AeGradientBlurFilter >> draw [

	self subclassResponsibility
]
