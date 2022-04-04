Class {
	#name : #PCSurfacePluginDispatch,
	#superclass : #FFIExternalStructure,
	#instVars : [
		'getSurfaceFormatFn',
		'lockSurfaceFn',
		'showSurfaceFn',
		'unlockSurfaceFn'
	],
	#classVars : [
		'OFFSET_GETSURFACEFORMATFN',
		'OFFSET_LOCKSURFACEFN',
		'OFFSET_MAJORVERSION',
		'OFFSET_MINORVERSION',
		'OFFSET_SHOWSURFACEFN',
		'OFFSET_UNLOCKSURFACEFN'
	],
	#category : #'BlocBenchs-PCRenderer-CairoFFI'
}

{ #category : #'field definition' }
PCSurfacePluginDispatch class >> fieldsDesc [

" self rebuildFieldAccessors

A structure from SurfacePlugin.h 
 

typedef struct sqSurfaceDispatch {
	/* Version information. Must be provided by the client
	   so the surface manager can check if certain operations
	   are supported. */
	int majorVersion;
	int minorVersion;

	/* Version 1.0 */
	fn_getSurfaceFormat getSurfaceFormat;
	fn_lockSurface lockSurface;
	fn_unlockSurface unlockSurface;
	fn_showSurface showSurface;
} sqSurfaceDispatch; 
"
	^ #(
		int majorVersion;
		int minorVersion;
		FFICallback getSurfaceFormatFn;
		FFICallback lockSurfaceFn;
		FFICallback unlockSurfaceFn;
		FFICallback showSurfaceFn
	)
]

{ #category : #private }
PCSurfacePluginDispatch class >> rebuildFieldAccessors [
	"Prevent rebuild, because methods are modified to ensure callbacks are not GCed"
]

{ #category : #'accessing - structure variables' }
PCSurfacePluginDispatch >> getSurfaceFormatFn [
	"This method was automatically generated"
	^FFICallback forAddress: ((handle pointerAt: OFFSET_GETSURFACEFORMATFN) asInteger)
]

{ #category : #'accessing - structure variables' }
PCSurfacePluginDispatch >> getSurfaceFormatFn: aCallback [
	"This method was automatically generated"
	getSurfaceFormatFn := aCallback.
	handle 
		pointerAt: OFFSET_GETSURFACEFORMATFN 
		put: aCallback thunk asExternalAddress
]

{ #category : #initialization }
PCSurfacePluginDispatch >> initialize [
	super initialize.
	self
		majorVersion: 1; 
		minorVersion: 0
]

{ #category : #'accessing - structure variables' }
PCSurfacePluginDispatch >> lockSurfaceFn [
	"This method was automatically generated"
	^FFICallback forAddress: ((handle pointerAt: OFFSET_LOCKSURFACEFN) asInteger)
]

{ #category : #'accessing - structure variables' }
PCSurfacePluginDispatch >> lockSurfaceFn: aCallback [
	"This method was automatically generated"
	lockSurfaceFn := aCallback.
	handle 
		pointerAt: OFFSET_LOCKSURFACEFN 
		put: aCallback thunk asExternalAddress
]

{ #category : #'accessing - structure variables' }
PCSurfacePluginDispatch >> majorVersion [
	"This method was automatically generated"
	^handle signedLongAt: OFFSET_MAJORVERSION
]

{ #category : #'accessing - structure variables' }
PCSurfacePluginDispatch >> majorVersion: anObject [
	"This method was automatically generated"
	handle signedLongAt: OFFSET_MAJORVERSION put: anObject
]

{ #category : #'accessing - structure variables' }
PCSurfacePluginDispatch >> minorVersion [
	"This method was automatically generated"
	^handle signedLongAt: OFFSET_MINORVERSION
]

{ #category : #'accessing - structure variables' }
PCSurfacePluginDispatch >> minorVersion: anObject [
	"This method was automatically generated"
	handle signedLongAt: OFFSET_MINORVERSION put: anObject
]

{ #category : #'accessing - structure variables' }
PCSurfacePluginDispatch >> showSurfaceFn [
	"This method was automatically generated"
	^FFICallback forAddress: ((handle pointerAt: OFFSET_SHOWSURFACEFN) asInteger)
]

{ #category : #'accessing - structure variables' }
PCSurfacePluginDispatch >> showSurfaceFn: aCallbackOrNil [
	"This method was automatically generated"
	showSurfaceFn := aCallbackOrNil.
	handle 
		pointerAt: OFFSET_SHOWSURFACEFN 
		put: (aCallbackOrNil 
			ifNotNil: [ aCallbackOrNil thunk asExternalAddress ]
			ifNil: [ ExternalAddress null ])
]

{ #category : #'accessing - structure variables' }
PCSurfacePluginDispatch >> unlockSurfaceFn [
	"This method was automatically generated"
	^FFICallback forAddress: ((handle pointerAt: OFFSET_UNLOCKSURFACEFN) asInteger)
]

{ #category : #'accessing - structure variables' }
PCSurfacePluginDispatch >> unlockSurfaceFn: aCallbackOrNil [
	"This method was automatically generated"
	unlockSurfaceFn := aCallbackOrNil.
	handle 
		pointerAt: OFFSET_UNLOCKSURFACEFN 
		put: (aCallbackOrNil 
			ifNotNil: [ aCallbackOrNil thunk asExternalAddress ]
			ifNil: [ ExternalAddress null ])
]
