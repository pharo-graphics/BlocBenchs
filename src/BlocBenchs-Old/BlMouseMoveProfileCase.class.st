"
I'm a benchmarking case that simulates mouse move in a circle over a grid of elements.

This is a scenario where updating only dirty rectangles can benefit.
"
Class {
	#name : 'BlMouseMoveProfileCase',
	#superclass : 'BlFixedDurationProfileCase',
	#category : 'BlocBenchs-Old-ProfileCases',
	#package : 'BlocBenchs-Old',
	#tag : 'ProfileCases'
}

{ #category : 'examples' }
BlMouseMoveProfileCase class >> example [
	
	[ 	| case |
		case := self new
			hostClass: BlOSWindowSDL2Host;
			yourself.

		(BlProfileRunner newForCase: case)
			enableASProfiler;
			enableFPS;
			run;
			openMeterReports ] fork
]

{ #category : 'hooks' }
BlMouseMoveProfileCase >> newElement [
	"Answer the element under study."

	| columnCount rowCount boardExtent cellExtent board |
	columnCount := rowCount := self numberOfCellsOnEachSide.

	boardExtent := self spaceExtent.
	cellExtent := Point
		x: boardExtent x / columnCount
		y: boardExtent y / rowCount.

	board := Array2D
		rows: rowCount
		columns: columnCount
		tabulate: [ :row :col |
			BlElement new
				id: (col@row) asString;
				geometry: BlEllipseGeometry new;
				position: (Point
					x: cellExtent x * (col-1)
					y: cellExtent y * (row-1));
				size: cellExtent + 1;
				background: Color random darker;
				clipChildren: false;
				when: BlMouseMoveEvent
				do: [ :evt |
					"Highlight element, but enforce changing color only 
					if has not been already highlighted.
					This avoids triggering many redraws."
					evt target background paint color = Color white
						ifFalse: [ evt target background: Color white ] ];
				yourself ].

	^ BlElement new
		addAnimation: self newSteppingAnimation;
		addChildren: board asArray;
		clipChildren: false;
		size: boardExtent;
		yourself
]

{ #category : 'private' }
BlMouseMoveProfileCase >> newSteppingAnimation [

	| oldPosition newPosition center |
	newPosition := 0.0 asPoint.
	center := self spaceExtent / 2.
	
	^ BlNumberTransition new
		  duration: duration;
		  from: 0.0;
		  to: Float twoPi;
		  onStepDo: [ :angle |
				| anEvent |
				oldPosition := newPosition.
				newPosition :=
					center
					+ ((center x * angle cos) @ (center y * angle sin)).
				anEvent := BlMouseMoveEvent new
					position: newPosition;
					screenPosition: space position + newPosition;
					delta: newPosition - oldPosition;
					timestamp: DateAndTime now;
					yourself.
				space dispatchEvent: anEvent ];
		  yourself
]

{ #category : 'private' }
BlMouseMoveProfileCase >> numberOfCellsOnEachSide [

	^ 100
]

{ #category : 'hooks' }
BlMouseMoveProfileCase >> spaceExtent [

	^ 500 asPoint
]
