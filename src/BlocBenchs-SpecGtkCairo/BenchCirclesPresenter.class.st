Class {
	#name : #BenchCirclesPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'athensPresenter',
		'random',
		'circleColors',
		'deltaY',
		'numberOfCircles',
		'transform',
		'pathBuilder',
		'lastMS',
		'radius',
		'prevMS',
		'fps'
	],
	#category : #'BlocBenchs-SpecGtkCairo'
}

{ #category : #examples }
BenchCirclesPresenter class >> example [
	| presenter |

	presenter := self new.
	presenter application: (SpApplication new useBackend: #Gtk).
	presenter openWithSpec

]

{ #category : #'private - drawing' }
BenchCirclesPresenter >> drawCirclesOn: aCanvas extent: surfaceExtent [ 
	| timeMS |
	
	timeMS := Time millisecondClockValue.
	circleColors
		ifNil: [
			"Prepare on first draw"
			deltaY := 0.
			circleColors := (1 to: numberOfCircles)
				collect: [ :each | self randomColor: random ].
			transform := AthensCairoTransform for: aCanvas.
			pathBuilder := AthensCairoPathBuilder new.
			pathBuilder context: aCanvas ]
		ifNotNil: [
			"Already prepared"
			deltaY := deltaY + (0.04 * (timeMS - lastMS)) ].

	prevMS := lastMS.
	lastMS := timeMS.

	"Clear background (https://www.cairographics.org/FAQ/#clear_a_surface)"
	aCanvas
		primSaveState;
		primSetSourceR: 1 g: 1 b: 1 a: 1;
		primPaint;
		primRestoreState.
"	surface clear: Color white."

	circleColors withIndexDo: [ :aColor :index | 
		aCanvas primSaveState.

		transform translateBy: radius asPoint + (index * 2 @ deltaY).
		aCanvas
			primSetSourceR: aColor red
			g: aColor green
			b: aColor blue
			a: 1.
		pathBuilder
			arcCenterX: 0.0
			centerY: 0.0
			radius: radius
			startAngle: 0.0
			endAngle: Float twoPi.
		aCanvas fill.

		aCanvas primRestoreState ]
]

{ #category : #private }
BenchCirclesPresenter >> increment [

	deltaY < 250 ifFalse: [ 
		fps average asFloat crTrace.
		^ self ].

	GRunLoop forceDefer: [ 
		athensPresenter redraw.
		fps add: (1000.0 / (lastMS - prevMS)) asInteger ]
]

{ #category : #initialization }
BenchCirclesPresenter >> initialize [

	super initialize.
	random := Random seed: 1.
	numberOfCircles := 300.
	radius := 50.0.	
	
	fps := OrderedCollection new: 1000.
	prevMS := 0.
	lastMS := 0
]

{ #category : #initialization }
BenchCirclesPresenter >> initializePresenters [

	self layout: (SpBoxLayout newTopToBottom
		add: (athensPresenter := self newAthens);
		yourself).

	athensPresenter drawBlock: [ :aCanvas :aRectangle | 
		self drawCirclesOn: aCanvas extent: aRectangle extent.
		self increment ]
]

{ #category : #initialization }
BenchCirclesPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter 
		title: 'Spec+Gtk+Cairo';
		initialExtent: 800@500
]

{ #category : #private }
BenchCirclesPresenter >> randomColor: aRandom [
	
	^ Color 
		h: (360.0 * aRandom next)
		s: (0.3 + (aRandom next * 0.7))
		v: (0.4 + (aRandom next * 0.6))
		alpha: 1.0
]
