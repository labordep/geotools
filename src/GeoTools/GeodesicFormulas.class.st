Class {
	#name : #GeodesicFormulas,
	#superclass : #Object,
	#instVars : [
		'fastModeFormulas',
		'fastModeThresholdInRadians'
	],
	#category : #'GeoTools-Geodesic'
}

{ #category : #accessing }
GeodesicFormulas class >> defaultFastModeFormulasClass [
		
	^ GeodesicHaversineFormulas 
]

{ #category : #accessing }
GeodesicFormulas class >> defaultFastModeThresholdInRadians [
	"Threshold below which Haversine formula is used instead of other formula (i.e. Vincenty) faster but less precise.
	1e-4 radians ≈ 640 meters at equator"
	
	^ 1e-4
]

{ #category : #tools }
GeodesicFormulas >> absoluteCoordinatesAlongGeodesicFrom: aFromAbsoluteCoordinate to: aToAbsoluteCoordinate atFraction: aFraction [

	self subclassResponsibility 
]

{ #category : #tools }
GeodesicFormulas >> absoluteCoordinatesFrom: anAbsoluteCoordinates distanceInMeters: aDistanceInM azimuthInRadians: anAzimuthInRadians [

	self subclassResponsibility 
]

{ #category : #tools }
GeodesicFormulas >> azimuthInRadiansFrom: aFromAbsoluteCoordinate to: aToAbsoluteCoordinate [

	self subclassResponsibility 
]

{ #category : #tools }
GeodesicFormulas >> distanceInMetersFrom: aFromAbsoluteCoordinate to: anEndAbsoluteCoordinate [

	self subclassResponsibility 
]

{ #category : #'tools - fast mode' }
GeodesicFormulas >> fastDistanceInMetersFrom: aFromAbsoluteCoordinate to: aToAbsoluteCoordinate [

	^ self fastModeFormulas distanceInMetersFrom: aFromAbsoluteCoordinate to: aToAbsoluteCoordinate
]

{ #category : #'fast mode' }
GeodesicFormulas >> fastModeFormulas [

	^ fastModeFormulas ifNil: [
		  fastModeFormulas := self class defaultFastModeFormulasClass new ]
]

{ #category : #'fast mode' }
GeodesicFormulas >> fastModeFormulas: anObject [

	fastModeFormulas := anObject
]

{ #category : #'fast mode' }
GeodesicFormulas >> fastModeThresholdInRadians [

	^ fastModeThresholdInRadians ifNil: [
			  fastModeThresholdInRadians := self class
				                                defaultFastModeThresholdInRadians ]
]

{ #category : #'fast mode' }
GeodesicFormulas >> fastModeThresholdInRadians: anObject [

	fastModeThresholdInRadians := anObject
]

{ #category : #'fast mode' }
GeodesicFormulas >> haversineDistanceFrom: aFromAbsoluteCoordinate to: aToAbsoluteCoordinate [
	
	self 
		deprecated: 'Use #fastDistanceInMetersFrom:to: instead'
		transformWith: '`@receiver haversineDistanceFrom: `@arg1 to: `@arg2' 
		-> '`@receiver fastDistanceInMetersFrom: `@arg1 to: `@arg2'.
	
	^ self fastDistanceInMetersFrom: aFromAbsoluteCoordinate to: aToAbsoluteCoordinate
]

{ #category : #private }
GeodesicFormulas >> normalizeLongitude: aLongitudeInRadians preservingHemisphereOf: originalLongitudeInRadians [
	"Normalize longitude to [-π, π] while preserving antimeridian hemisphere"

	| normalized |
	normalized := (aLongitudeInRadians + (3 * Float pi) euclideanModulo:
		               2 * Float pi) - Float pi.

	"If both original and result are on/near antimeridian, preserve hemisphere"
	((originalLongitudeInRadians abs - Float pi) abs < 1e-10 and: [
		 (normalized abs - Float pi) abs < 1e-10 ]) ifTrue: [
		^ originalLongitudeInRadians sign * Float pi ].

	^ normalized
]
