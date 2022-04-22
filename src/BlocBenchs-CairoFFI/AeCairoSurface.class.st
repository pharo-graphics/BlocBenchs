"
I am a Cairo FFI binding for `cairo_surface_t`.

See: https://www.cairographics.org/manual/cairo-cairo-surface-t.html
"
Class {
	#name : #AeCairoSurface,
	#superclass : #FFIExternalReference,
	#traits : 'AeTCairoLibrary',
	#classTraits : 'AeTCairoLibrary classTrait',
	#category : #'BlocBenchs-CairoFFI-Core'
}

{ #category : #converting }
AeCairoSurface class >> asExternalTypeOn: generator [
	^ FFIExternalObjectType objectClass: self
]

{ #category : #API }
AeCairoSurface >> flush [

	self primFlush
]

{ #category : #API }
AeCairoSurface >> markDirty [

	self primMarkDirty
]

{ #category : #'private - ffi' }
AeCairoSurface >> primFlush [

	^ self ffiCall: #(void cairo_surface_flush ( self ) )
]

{ #category : #'private - ffi' }
AeCairoSurface >> primMarkDirty [
	
	^ self ffiCall: #(void cairo_surface_mark_dirty ( self ) )
]
