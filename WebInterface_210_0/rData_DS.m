//
//  rData_DS.m
//  WebInterface
//
//  Created by Sysadmin on 13.02.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "rData_DS.h"



@implementation rData_DS

- (id)init
{

	WochenplanTabelle=[[NSMutableArray alloc]initWithCapacity:0];
	return self;
}

- (void)setRaumData:(NSDictionary*) derDataDic
{
NSLog(@"Data_DS setRaumData: DataDic: %@",[derDataDic description]);
}


- (void)setWochenplan:(NSArray*)derWochenplan
{
	//NSLog(@"Data_DS setWochenplan");
	int anzReports=[derWochenplan count];
	int i;
	for (i=0;i<anzReports;i++)
	{
	NSMutableDictionary* tempTagDic=[[NSMutableDictionary alloc]initWithCapacity:0];
	
	[tempTagDic setObject:[NSNumber numberWithInt:3] forKey:@"drei"];

	[WochenplanTabelle addObject:tempTagDic];
	
	
	}
	
}

- (void)addTagplan:(NSArray*)derTagplan
{
	//NSLog(@"Data_DS setWochenplan");
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
