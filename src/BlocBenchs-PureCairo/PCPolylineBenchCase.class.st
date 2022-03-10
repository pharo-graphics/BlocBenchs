Class {
	#name : #PCPolylineBenchCase,
	#superclass : #PCTranslatingFiguresBenchCase,
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #hook }
PCPolylineBenchCase >> borderWidth [

	^ 1
]

{ #category : #hook }
PCPolylineBenchCase >> newFigureWith: random [

	^ BlElement new
		  geometry: (BlPolylineGeometry vertices: self vertices);
		  border: (BlBorder paint: (Color random: random) width: self borderWidth);
		  background: Color transparent;
		  yourself
]

{ #category : #'instance creation' }
PCPolylineBenchCase >> newMorph [

	^ PCPolylinesMorph2 new
		  case: self;
		  yourself
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
