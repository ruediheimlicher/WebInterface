/* rMehrkanalDiagramm */

#import <Cocoa/Cocoa.h>
#import "rOrdinate.h"

@interface rMehrkanalDiagramm : NSView
{
	NSPoint						DiagrammEcke;
	
	NSPoint						lastPunkt;
	NSMutableArray*			GraphArray;	
	NSMutableArray*			GraphFarbeArray;	
	NSMutableArray*			GraphKanalArray;	
	NSMutableArray*			GraphKanalOptionenArray;
	NSBezierPath*				Graph;
	NSColor*						GraphFarbe;
	NSMutableArray*			NetzlinienX;
	NSMutableArray*			NetzlinienY;
	NSMutableArray*			DatenArray;
	NSMutableArray*			DatenFeldArray;
   NSMutableArray*			DatenWertArray;
	
	int							Tag;
	int							AnzKanal;		// Anzahl darzustellender Kanäle
	int							MajorTeileY;	// Teile der Hauptskala
	int							MinorTeileY;	// Teile der subSkala
	float							MaxY;			// Obere Grenze der Anzeige
	float							MinY;			// Untere Grenze der Anzeige
	float							NullpunktY;		// Offset des Nullpunktes
	float							MaxOrdinate;		// Laenge der Ordinate
	float							MaxEingangsWert;	// Maximaler Eingangswert der Daten
	
	float							StartwertX;			// Abszisse des ersten Werts
	float							FaktorY;		// Umrechnungsfaktor auf Diagrammhoehe
	float							ZeitKompression;	// Streckung des Anzeigebereichs
	float							GrundlinienOffset;
	NSString*					Einheit;
	NSMutableArray*			EinheitenYArray;
	NSMutableArray*			DatenTitelArray;
	NSCalendarDate*			DatenserieStartZeit;

	int							OffsetY;
	
	rOrdinate*					Ordinate;
	
	int							Darstellungsoption; 

}
- (void)setTag:(int)derTag;
- (void)setDiagrammlageY:(float)DiagrammlageY;
- (void)setOffsetX:(float)x;
- (void)setOffsetY:(float)y;
- (void)setGrundlinienOffset:(float)offset;
- (float)GrundlinienOffset;
- (void)setMaxOrdinate:(int)laenge;
- (void)setMaxEingangswert:(int)maxEingang;


- (void)setWert:(NSPoint)derWert  forKanal:(int)derKanal;
- (void)setEinheitenDicY:(NSDictionary*)derEinheitenDic;
- (void)setZeitKompression:(float)dieKompression;
- (void)StartAktion:(NSNotification*)note;
- (void)setGraphFarbe:(NSColor*) dieFarbe forKanal:(int) derKanal;
- (void)setWertMitX:(float)x mitY:(float)y forKanal:(int)derKanal;
- (void)setStartWerteArray:(NSArray*)Werte;
- (void)setStartZeit:(NSCalendarDate*)dasDatum;
- (void)setWerteArray:(NSArray*)derWerteArray mitKanalArray:(NSArray*)derKanalArray;
- (void)setWerteArray:(NSArray*)derWerteArray mitKanalArray:(NSArray*)derKanalArray mitVorgabenDic:(NSDictionary*)dieVorgaben;
- (void)setOrdinate:(id)dieOrdinate;
- (int)MaxOrdinate;
- (void)clean;
- (void)logRect:(NSRect)r;
void r_itoa(int32_t zahl, char* string);
@end
