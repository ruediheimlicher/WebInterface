//
//  rAVR_DS.m
//  USBInterface
//
//  Created by Sysadmin on 13.02.08.
//  Copyright 2008 Ruedi Heimlicher. All rights reserved.
//

#import "rAVR_DS.h"



@implementation rAVR_DS

- (id)init
{

	WochenplanTabelle=[[NSMutableArray alloc]initWithCapacity:0];
	return self;
}


- (void)setWochenplan:(NSArray*)derWochenplan
{
	//NSLog(@"AVR_DS setWochenplan: %@",[derWochenplan description]);
	int anzReports=[derWochenplan count];
	int i;
	for (i=0;i<anzReports;i++)
	{
	//NSMutableDictionary* tempTagDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	
//	[tempTagDic setObject:[NSNumber numberWithInt:3] forKey:@"drei"];
//	[WochenplanTabelle addObject:tempTagDic];
	[WochenplanTabelle setArray:derWochenplan]; 
	
	}
	
}

- (void)clearWochenplan
{
[WochenplanTabelle  removeAllObjects];

}

- (void)addTagplan:(NSArray*)derTagplan
{
	//NSLog(@"AVR_DS setWochenplan");
	int anz=[derTagplan count];
	int i,k;
	k=0;
	for (i=0;i<anz;i++)
	{

	NSMutableDictionary* tempTagDic=[[NSMutableDictionary alloc]initWithCapacity:0];
	[tempTagDic setObject:[NSNumber numberWithInt:i] forKey:@"stunde"];

	[WochenplanTabelle addObject:tempTagDic];
	
	
	}
	
}




- (int)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return [WochenplanTabelle count];
}


- (id)tableView:(NSTableView *)aTableView
    objectValueForTableColumn:(NSTableColumn *)aTableColumn 
			row:(int)rowIndex
{
	//NSLog(@"objectValueForTableColumn");
    NSDictionary *einTestDic = [NSDictionary dictionary];
	if (rowIndex<[WochenplanTabelle count])
	{
			einTestDic = [WochenplanTabelle objectAtIndex: rowIndex];
			
	}
	//NSLog(@"einTestDic  Testname: %@",[einTestDic objectForKey:@"name"]);

	return [einTestDic objectForKey:[aTableColumn identifier]];
	
}

- (void)tableView:(NSTableView *)aTableView 
   setObjectValue:(id)anObject 
   forTableColumn:(NSTableColumn *)aTableColumn 
			  row:(int)rowIndex
{
		//NSLog(@"setObjectValue ForTableColumn");

    NSMutableDictionary* einTestDic;
    if (rowIndex<[WochenplanTabelle count])
	{
		einTestDic=[WochenplanTabelle objectAtIndex:rowIndex];
		[einTestDic setObject:anObject forKey:[aTableColumn identifier]];
	}
}

@end
