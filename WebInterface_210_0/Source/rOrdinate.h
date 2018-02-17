/* rOrdinate */

#import <Cocoa/Cocoa.h>

@interface rOrdinate : NSView
{
int							Tag;
NSPoint						AchsenEcke;
NSPoint						AchsenSpitze;
int							MaxOrdinate;
NSString*					Einheit;
int							MajorTeile;		// Teile der Hauptskala
int							MinorTeile;		// Teile der subSkala
float							Max;			// Obere Grenze der Anzeige
float							Min;			// Untere Grenze der Anzeige
float							Nullpunkt;
float							Offset;		// Offset des Nullpunktes
float							Zoom;			// Streckung des Anzeigebereichs
float							GrundlinienOffset;
int							Schriftgroesse;
NSMutableArray*			EinheitenArray;
}
- (void)setTag:(int)derTag;
- (void)setOrdinatenlageY:(float)OrdinatenlageY;
- (void)setGrundlinienOffset:(float)offset;
- (void)AchseZeichnen;
- (void)setMaxOrdinate:(int)laenge;
- (void)setEinheit:(NSString*)einheit;
- (void)setAchsenDic:(NSDictionary*)derAchsenDic;
@end
