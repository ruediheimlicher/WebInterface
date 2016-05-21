//
//  rDatenlegende.h
//  WebInterface
//
//  Created by Ruedi Heimlicher on 18.Januar.13.
//
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "defines.h"

@interface rDatenlegende : NSObject
{
   float randunten, randoben, abstandnach, abstandvor, mindistanz;
   NSMutableArray* LegendeArray;
}
- (void)setVorgabenDic:(NSDictionary*)vorgabendic;
- (void)setLegendeArray:(NSArray*)array;
- (NSArray*)LegendeArray;

@end
