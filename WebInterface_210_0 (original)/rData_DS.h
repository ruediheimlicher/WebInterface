//
//  rData_DS.h
//  WebInterface
//
//  Created by Sysadmin on 13.02.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface rData_DS : NSObject <NSTableViewDelegate, NSTableViewDataSource>
{
NSMutableArray* WochenplanTabelle;
NSMutableArray* DumpTabelle;

}
- (void)setWochenplan:(NSArray*) derWochenplan;




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
