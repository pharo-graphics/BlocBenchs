Class {
	#name : #PCCairoSurface,
	#superclass : #Object,
	#traits : 'TCairoLibrary',
	#classTraits : 'TCairoLibrary classTrait',
	#instVars : [
		'handle',
		'context',
		'id',
		'session'
	],
	#pools : [
		'PCCairoDefinitions'
	],
	#classInstVars : [
		'session',
		'dispatch',
		'dispatchStruct'
	],
	#category : #'BlocBenchs-PCRenderer-CairoFFI'
}

{ #category : #converting }
PCCairoSurface class >> asExternalTypeOn: generator [ 
	"use handle ivar to hold my instance (cairo_surface_t)"
	^ FFIExternalObjectType objectClass: self
]

{ #category : #'session management' }
PCCairoSurface class >> checkSession [
	session == Smalltalk session 
		ifFalse: [ self initializeForNewSession ]
]

{ #category : #'instance creation' }
PCCairoSurface class >> createFromFile: aFileName ifFailed: aBlock [
	"Right now, this protocol is Cairo backend only. "
	
 	| surface cstring |
	cstring := aFileName , (Character value: 0) asString.
	surface :=  self primCreateFromFile: cstring.
	surface isSuccess not
		ifTrue: [ 
			self destroySurfaceHandle: surface handle asInteger.
			^ aBlock cull: surface status ]
		ifFalse: [ surface initialize ].
	^ surface .
]

{ #category : #'surface plugin callbacks' }
PCCairoSurface class >> createGetSurfaceFormatFn [
	"
		int getSurfaceFormat(sqIntptr_t handle, int* width, int* height, int* depth, int* isMSB);

		Return general information about the OS drawing surface.
		Return true if successful, false otherwise.

		The returned values describe the basic properties such as
		width, height, depth and LSB vs. MSB pixels.
	"
	^ FFICallback 
		signature: #(int (void *handle, int* width, int* height, int* depth, int* isMSB))
		block: [ :handle :width :height :depth :isMSB |
			[width signedLongAt: 1 put: (self get_width: handle).
			 height signedLongAt: 1 put: (self get_height: handle).
			 depth signedLongAt: 1 put: 32.
			 isMSB signedLongAt: 1 put: 0. 
			 1 "Everything ok"] 
			on: Error do: [ :e | 0 "Error happened" ]]
]

{ #category : #'surface plugin callbacks' }
PCCairoSurface class >> createLockSurfaceFn [
	"
	int lockSurface(sqIntptr_t handle, int *pitch, int x, int y, int w, int h);
		Lock the bits of the surface.
		Return a pointer to the actual surface bits, or NULL on failure.
		If successful, store the pitch of the surface (e.g., the bytes
		per scan line).

		For equal source/dest handles only one locking operation is performed.
		This is to prevent locking of overlapping areas which does not work with
		certain APIs (e.g., DirectDraw prevents locking of overlapping areas). 
		A special case for non-overlapping but equal source/dest handle would 
		be possible but we would have to transfer this information over to 
		unlockSurfaces somehow (currently, only one unlock operation is 
		performed for equal source and dest handles). Also, this would require
		a change in the notion of ioLockSurface() which is right now interpreted
		as a hint and not as a requirement to lock only the specific portion of
		the surface.

		The arguments in ioLockSurface() provide the implementation with
		an explicit hint what area is affected. It can be very useful to
		know the max. affected area beforehand if getting the bits requires expensive
		copy operations (e.g., like a roundtrip to the X server or a glReadPixel op).
		However, the returned pointer *MUST* point to the virtual origin of the surface
		and not to the beginning of the rectangle. The promise made by BitBlt
		is to never access data outside the given rectangle (aligned to 4byte boundaries!)
		so it is okay to return a pointer to the virtual origin that is actually outside
		the valid memory area.

		The area provided in ioLockSurface() is already clipped (e.g., it will always
		be inside the source and dest boundingBox) but it is not aligned to word boundaries
		yet. It is up to the support code to compute accurate alignment if necessary.
	"

	^ FFICallback 
		signature: #(void * (void *handle, int *pitch, int x, int y, int w, int h))
		block: [ :handle :pitch :x :y :w :h |
			pitch signedLongAt: 1 put: (self get_stride: handle).
			self get_data: handle ]
]

{ #category : #'surface plugin callbacks' }
PCCairoSurface class >> createShowSurfaceFn [
	"
	int showSurface(sqIntptr_t handle, int x, int y, int w, int h);
		Display the contents of the surface on the actual screen.

		If ioShowSurface() is called the surface in question represents a DisplayScreen.

	"
	^ nil
	"^ FFICallback 
		signature: #(int (void *handle, int x, int y, int w, int h))
		block: [ :handle :x :y :w :h | 0 ""Do nothing"" ]"
]

{ #category : #'surface plugin callbacks' }
PCCairoSurface class >> createUnlockSurfaceFn [
	"
		int unlockSurface(sqIntptr_t handle, int x, int y, int w, int h);
		Unlock the bits of a (possibly modified) surface after BitBlt completed.
		The return value is ignored.

		The arguments provided specify the dirty region of the surface. If the
		surface is unmodified all arguments are set to zero.

	"
	^ nil
	"^ FFICallback 
		signature: #(int (void *handle, int x, int y, int w, int h))
		block: [ :handle :x :y :w :h | 0 ""Do nothing"" ]"
]

{ #category : #private }
PCCairoSurface class >> destroyContextHandle: aHandle [
	^ self ffiCall: #( 	void cairo_destroy (size_t aHandle) )
]

{ #category : #private }
PCCairoSurface class >> destroySurfaceHandle: handle [
	^ self ffiCall: #( void cairo_surface_destroy ( ulong handle ) )
]

{ #category : #'surface plugin callbacks' }
PCCairoSurface class >> dispatchStruct [
	self checkSession.
	^ dispatchStruct
]

{ #category : #'instance creation' }
PCCairoSurface class >> extent: anExtent [
	^ self extent: anExtent format: CAIRO_FORMAT_ARGB32
]

{ #category : #'instance creation' }
PCCairoSurface class >> extent: anExtent format: aFormat [
	^ ( self primImage: aFormat width: anExtent x height: anExtent y + 1) initialize
]

{ #category : #'finalize resources' }
PCCairoSurface class >> finalizeResourceData: data [
	"Finalize external state"

	| handle id contextHandle |
	handle := data first.
	id := data second.
	contextHandle := data third.
	
	(self findSurface: id) = handle value ifFalse: [ 
		"self error: 'surface is not registered with surface plugin'."
		^ self ].
	
	self unregisterSurfaceWithId: id.
	self destroyContextHandle: contextHandle value. 
	self destroySurfaceHandle: handle value
]

{ #category : #private }
PCCairoSurface class >> findSurface: surfaceId [
	| buf |
	buf := ByteArray new: 4.  "sizeof(int)"
	
	
	(self primFindSurface: surfaceId handle: buf) ifTrue: [
		^ buf unsignedLongAt: 1
		].
	
	^ nil.
]

{ #category : #'instance creation' }
PCCairoSurface class >> fromForm: aForm [
	| form surface newBits |
	form := aForm unhibernate; asFormOfDepth: 32.
	surface := self extent: aForm extent.
	"we should convert form bits with premultiplied alpha"
	newBits := form bits collect: [:pixel |
		| alpha r g b|
		alpha := (pixel >> 24) / 255.
		r := ( (pixel bitAnd: 255) * alpha ) asInteger.
		g := ( (pixel >>8 bitAnd: 255) * alpha ) asInteger.
		b := ( (pixel >>16 bitAnd: 255) * alpha ) asInteger.
		(pixel bitAnd: 16rFF000000) + (b<<16) + (g<<8) + r
		].
	LibC memCopy: newBits to: surface getDataPtr getHandle size: (form width * form height *4).
	surface markDirty.
	^ surface.
]

{ #category : #'surface plugin callbacks' }
PCCairoSurface class >> get_data: surface [
	^ self ffiCall: #(void *cairo_image_surface_get_data (void *surface))
]

{ #category : #'surface plugin callbacks' }
PCCairoSurface class >> get_height: surface [
	^ self ffiCall: #(int cairo_image_surface_get_height (void *surface))
]

{ #category : #'surface plugin callbacks' }
PCCairoSurface class >> get_stride: surface [
	^ self ffiCall: #(int cairo_image_surface_get_stride (void *surface))
]

{ #category : #'surface plugin callbacks' }
PCCairoSurface class >> get_width: surface [
	^ self ffiCall: #(int cairo_image_surface_get_width (void *surface))
]

{ #category : #'session management' }
PCCairoSurface class >> initializeForNewSession [
	session := Smalltalk session.
	"create a dispatch structure"
	dispatchStruct := SQSurfaceDispatch externalNew.
	dispatchStruct 
		getSurfaceFormatFn: self createGetSurfaceFormatFn;
		lockSurfaceFn: self createLockSurfaceFn;
		unlockSurfaceFn: self createUnlockSurfaceFn;
		showSurfaceFn: self createShowSurfaceFn.
	"assign the pointer"
	dispatch := dispatchStruct getHandle.
]

{ #category : #private }
PCCairoSurface class >> primCreateFromFile: aFileName [
	^ self ffiCall: #(PCCairoSurface cairo_image_surface_create_from_png (char* aFileName))
]

{ #category : #private }
PCCairoSurface class >> primFindSurface: id handle: handlePtr [
		"Find the surface with the given ID, and, optionally,
		the given set of surface functions. The registered handle
		is returned in surfaceHandle. Return true if successful
		(e.g., the surface has been found), false otherwise."

	<primitive: 'primitiveFindSurface' module: 'SurfacePlugin'>
]

{ #category : #private }
PCCairoSurface class >> primImage: aFormat width: aWidth height: aHeight [
	^ self ffiCall: #(PCCairoSurface cairo_image_surface_create (int aFormat,
                                                         int aWidth,
                                                         int aHeight) )
]

{ #category : #private }
PCCairoSurface class >> primImageFromData: data width: width height: height pitch: stride [
	
	"CAIRO_FORMAT_ARGB32 -> 0"
	
	^ self ffiCall: #(PCCairoSurface cairo_image_surface_create_for_data (
		void *data,
		0,
		int width,
		int height,
		int stride) )
]

{ #category : #private }
PCCairoSurface class >> primRegisterSurface: aCairoSurfaceHandle dispatch: sqSurfaceDispatchPtr surfaceId: idHolder [
"
	Register a new surface with the given handle and
	the set of surface functions. The new ID is returned
	in surfaceID. Returns true if successful, false 
	otherwise."

	<primitive: 'primitiveRegisterSurface' module: 'SurfacePlugin'>
	^false
]

{ #category : #private }
PCCairoSurface class >> primUnregisterSurface: aCairoSurfaceId [
"
	ioUnregisterSurface:
	Unregister the surface with the given id.
	Returns true if successful, false otherwise. 

"
	<primitive: 'primitiveUnregisterSurface' module: 'SurfacePlugin'>
]

{ #category : #private }
PCCairoSurface class >> primWidth: aWidth height: aHeight [
	^ self ffiCall: #( PCCairoSurface cairo_image_surface_create (
						CAIRO_FORMAT_ARGB32,
						int aWidth,
						int aHeight) )
]

{ #category : #private }
PCCairoSurface class >> registerSurface: aPCCairoSurface [
	"register the cairo surface with surface plugin,
	so, it can be used directly by bitblt operations.
	Answer an id and unique session object"
	| id address |

	self checkSession.

	id := ByteArray new: 4.
	address := aPCCairoSurface getHandle.
	(self primRegisterSurface: address dispatch: dispatch surfaceId: id)
		ifFalse: [ self error: 'Unable to register surface with SurfacePlugin' ].
	id := id signedLongAt: 1.
	
	^ id
]

{ #category : #private }
PCCairoSurface class >> unregisterSurfaceWithId: anPCCairoSurfaceId [

	self primUnregisterSurface: anPCCairoSurfaceId
]

{ #category : #'instance creation' }
PCCairoSurface class >> width: aWidth height: aHeight [
	^ (self primWidth: aWidth height: aHeight+1) initialize
]

{ #category : #converting }
PCCairoSurface >> asForm [
	"create a form and copy an image data there"
	self checkSession.
	self flush.
 	^ (PCCairoSurfaceForm extent: (self width@(self height)) depth: 32 bits: id)
		surface: self;
		yourself
]

{ #category : #private }
PCCairoSurface >> checkSession [
	session == Smalltalk session ifFalse: [ 
		self error: 'Attempt to use invalid external resource (left from previous session)' ]
]

{ #category : #accessing }
PCCairoSurface >> clear [
	^ self clear: Color transparent
]

{ #category : #accessing }
PCCairoSurface >> extent [
	^ self width @ self height
]

{ #category : #private }
PCCairoSurface >> finish [
	^ self ffiCall: #( void cairo_surface_finish (self) )
]

{ #category : #private }
PCCairoSurface >> flush [
	^ self ffiCall: #( void cairo_surface_flush (self) )
]

{ #category : #accessing }
PCCairoSurface >> getDataPtr [
	"get a pointer to surface bitmap data"
	
	^ self ffiCall: #(
		void* cairo_image_surface_get_data ( self ) )
]

{ #category : #accessing }
PCCairoSurface >> getHandle [
	
	^ handle
]

{ #category : #accessing }
PCCairoSurface >> getType [
	"https://www.cairographics.org/manual/cairo-cairo-surface-t.html#cairo-surface-get-type"
	
	^ self ffiCall: #(
		uint cairo_surface_get_type ( self ) )
]

{ #category : #accessing }
PCCairoSurface >> handle [
	^ handle value
]

{ #category : #accessing }
PCCairoSurface >> height [
	
	^self privateHeight - 1
]

{ #category : #initialization }
PCCairoSurface >> initialize [
	"the handle should be set already since we using an NB callout to create an instance"
	handle value = 0 ifTrue: [ 
		self error: 'Error creating new surface' ].
	
	session := Smalltalk session.
	
	id := self class registerSurface: self.
		
	context := self primCreateContext.
	
	FFIExternalResourceManager addResource: self.
]

{ #category : #testing }
PCCairoSurface >> isSuccess [
	^ self status  =	CAIRO_STATUS_SUCCESS
]

{ #category : #private }
PCCairoSurface >> markDirty [
	^ self ffiCall: #( void cairo_surface_mark_dirty (self) )
]

{ #category : #private }
PCCairoSurface >> primCreateContext [
	^ self ffiCall: #( PCCairoContext cairo_create (self) )
]

{ #category : #accessing }
PCCairoSurface >> privContext [
	"Answer the cairo context for this surface (often named canvas in Athens)."

	^ context
]

{ #category : #private }
PCCairoSurface >> privateHeight [
	^ self ffiCall: #(
		int cairo_image_surface_get_height ( self ) )
]

{ #category : #'as yet unclassified' }
PCCairoSurface >> pureCairoAsFormExtent: aPoint [
	"Based on asForm but simplified (e.g. avoid calling FFI twice for w and h)"

 	^ Form extent: aPoint depth: 32 bits: id
]

{ #category : #initialization }
PCCairoSurface >> resourceData [
	^ { handle value. id. context handle }
]

{ #category : #private }
PCCairoSurface >> showPage [
	^ self ffiCall: #( void cairo_surface_show_page (self) )
]

{ #category : #accessing }
PCCairoSurface >> status [
	^ self ffiCall: #(int cairo_surface_status (self) )
]

{ #category : #private }
PCCairoSurface >> statusToString: aCairoStatusT [
	^ self ffiCall: #(String   cairo_status_to_string  (cairo_status_t aCairoStatusT))
]

{ #category : #accessing }
PCCairoSurface >> stride [
	^ self ffiCall: #(
		int cairo_image_surface_get_stride ( self ) )
]

{ #category : #accessing }
PCCairoSurface >> width [
	^ self ffiCall: #(
		int cairo_image_surface_get_width ( self ) )
]

{ #category : #converting }
PCCairoSurface >> writeToPng: aFileName [
	^ self ffiCall: #(void cairo_surface_write_to_png (self, String aFileName) )
]
