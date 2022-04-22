Class {
	#name : #AeCairoImageSurfaceTest,
	#superclass : #TestCase,
	#instVars : [
		'surface'
	],
	#category : #'BlocBenchs-CairoFFI-Tests'
}

{ #category : #testing }
AeCairoImageSurfaceTest class >> isAbstract [
	^ self = AthensCairoExportSurfaceTest
]

{ #category : #tests }
AeCairoImageSurfaceTest >> testCreateExtentFormat [

	surface := AeCairoImageSurface
		           createExtent: 100 @ 50
		           format: AeCairoSurfaceFormat CAIRO_FORMAT_ARGB32.

	self assert: surface extent equals: 100 @ 50
]

{ #category : #tests }
AeCairoImageSurfaceTest >> testCreateForDataExtentFormat [

	| extent format stride data |
	extent := 2000 @ 1500.
	format := AeCairoSurfaceFormat CAIRO_FORMAT_ARGB32.
	stride := AeCairoImageSurface primStrideForWidth: extent x format: format.

	data := FFIExternalArray externalNewType: FFIUInt8 size: stride * extent y.

	surface := AeCairoImageSurface 
		createForData: data
		extent: extent
		stride: stride
		format: format.

	self assert: surface extent equals: extent
]

{ #category : #tests }
AeCairoImageSurfaceTest >> testExtent [

	surface := AeCairoImageSurface extent: 100 @ 50.

	self assert: surface extent equals: 100 @ 50
]

{ #category : #tests }
AeCairoImageSurfaceTest >> testFromForm [

	| aForm |
	aForm := Smalltalk ui icons iconNamed: #classIcon.
	surface := AeCairoImageSurface fromForm: aForm.

	self assert: surface extent equals: aForm extent
]

{ #category : #tests }
AeCairoImageSurfaceTest >> testHeight [

	surface := AeCairoImageSurface extent: 100 @ 50.

	self assert: surface height equals: 50
]

{ #category : #tests }
AeCairoImageSurfaceTest >> testPrimFormatStrideForWidth [

	self
		assert: (AeCairoImageSurface
				 primStrideForWidth: 150
				 format: AeCairoSurfaceFormat CAIRO_FORMAT_ARGB32)
		equals: 150 * 4
]

{ #category : #tests }
AeCairoImageSurfaceTest >> testWidth [

	surface := AeCairoImageSurface extent: 100 @ 50.

	self assert: surface width equals: 100
]
