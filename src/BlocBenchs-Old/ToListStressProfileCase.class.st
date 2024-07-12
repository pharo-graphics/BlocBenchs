Class {
	#name : #ToListStressProfileCase,
	#superclass : #BlFixedDurationProfileCase,
	#category : #'BlocBenchs-Old-ProfileCases'
}

{ #category : #examples }
ToListStressProfileCase class >> exampleProfile [
	
	[ 	| case |
		case := self new
			hostClass: BlOSWindowSDL2Host;
			duration: 20 seconds;
			yourself.

		(BlProfileRunner newForCase: case)
			enableASProfiler;
			run;
			openMeterReports ] fork
]

{ #category : #printing }
ToListStressProfileCase >> label [

	^ 'Toplo list stress'
]

{ #category : #hooks }
ToListStressProfileCase >> newElement [
	"Answer the element under study."

	^ ToListElementStresserWithAdditionalSelecters new tabsPanel
]
