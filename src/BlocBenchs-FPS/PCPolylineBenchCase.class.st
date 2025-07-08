Class {
	#name : #PCPolylineBenchCase,
	#superclass : #PCTranslatingFiguresBenchCase,
	#category : #'BlocBenchs-FPS-Cases'
}

{ #category : #hook }
PCPolylineBenchCase >> borderWidth [

	^ 1
]

{ #category : #hook }
PCPolylineBenchCase >> newFigureWith: random [

	^ BlElement new
		  geometry: (BlPolylineGeometry vertices: self vertices);
		  extent: (Rectangle encompassing: self vertices) extent;
		  border: (BlBorder paint: (Color random: random) width: self borderWidth);
		  background: Color transparent;
		  yourself
]

{ #category : #'instance creation' }
PCPolylineBenchCase >> newRawSDLCairoWindow [

	^ PCPolylinesCachingWindow newWith: self
]

{ #category : #'instance creation' }
PCPolylineBenchCase >> newRoassalWrapperMorph [

	^ PCRoassalPolylineMorph new
		  case: self;
		  yourself
]

{ #category : #hook }
PCPolylineBenchCase >> vertices [

	self subclassResponsibility
]
