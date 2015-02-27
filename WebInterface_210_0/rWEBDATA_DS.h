//
//  rWEBDATA_DS.h
//  WebInterface
//
//  Created by Sysadmin on 28.August.09.
//  Copyright 2009 Ruedi Heimlicher. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface rWEBDATA_DS : NSObject <NSTableViewDataSource, NSTableViewDelegate>
{
NSMutableArray* ValueKeyTabelle;
//NSMutableArray* DumpTabelle;

}
- (void)setValueKeyArray:(NSArray*) derWochenplan;
- (void)addValueKeyArray:(NSArray*)derTagplan;
- (void)addValueKeyZeile:(NSDictionary*)dieZeile;
- (int)numberOfRowsInTableView:(NSTableView *)aTableView;
- (id)tableView:(NSTableView *)aTableView
    objectValueForTableColumn:(NSTableColumn *)aTableColumn 
			row:(int)rowIndex;
- (void)tableView:(NSTableView *)aTableView 
   setObjectValue:(id)anObject 
   forTableColumn:(NSTableColumn *)aTableColumn 
			  row:(int)rowIndex;			
- (void)setRaumData:(NSDictionary*) derDataDic;
@end

