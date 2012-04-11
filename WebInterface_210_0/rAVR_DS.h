//
//  rAVR_DS.h
//  USBInterface
//
//  Created by Sysadmin on 13.02.08.
//  Copyright 2008 Ruedi Heimlicher. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface rAVR_DS : NSObject
{
NSMutableArray* WochenplanTabelle;
//NSMutableArray* DumpTabelle;

}
- (void)setWochenplan:(NSArray*) derWochenplan;
- (void)clearWochenplan;

- (int)numberOfRowsInTableView:(NSTableView *)aTableView;
- (id)tableView:(NSTableView *)aTableView
    objectValueForTableColumn:(NSTableColumn *)aTableColumn 
			row:(int)rowIndex;
- (void)tableView:(NSTableView *)aTableView 
   setObjectValue:(id)anObject 
   forTableColumn:(NSTableColumn *)aTableColumn 
			  row:(int)rowIndex;			
@end
