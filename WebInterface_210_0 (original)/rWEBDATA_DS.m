//
//  EEPROM_DS.m
//  WebInterface
//
//  Created by Sysadmin on 28.August.09.
//  Copyright 2009 Ruedi Heimlicher. All rights reserved.
//

#import "rWEBDATA_DS.h"


@implementation rWEBDATA_DS
- (id)init
{

	ValueKeyTabelle=[[NSMutableArray alloc]initWithCapacity:0];
	return self;
}


- (void)setValueKeyArray:(NSArray*)derWochenplan
{
	//NSLog(@"WEBDATA_DS setValueKeyArray: %@",[derWochenplan description]);
	//NSMutableDictionary* tempTagDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	
//	[tempTagDic setObject:[NSNumber numberWithInt:3] forKey:@"drei"];
//	[ValueKeyTabelle addObject:tempTagDic];
	[ValueKeyTabelle setArray:derWochenplan]; 
	//NSLog(@"ValueKeyTabelle: %@",[ValueKeyTabelle description]);
	
	
	
}

- (void)addValueKeyArray:(NSArray*)derTagplan
{
	NSLog(@"WEBDATA_DS addValueKeyArray: %@",[derTagplan description]);
	//NSMutableDictionary* tempTagDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	
//	[tempTagDic setObject:[NSNumber numberWithInt:3] forKey:@"drei"];
//	[ValueKeyTabelle addObject:tempTagDic];
	[ValueKeyTabelle addObjectsFromArray:derTagplan]; 
	//NSLog(@"ValueKeyTabelle: %@",[ValueKeyTabelle description]);
	
	
	
}

- (void)addValueKeyZeile:(NSDictionary*)dieZeile
{
	NSLog(@"WEBDATA_DS addValueKeyZeile: %@",[dieZeile description]);
	//NSMutableDictionary* tempTagDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	
	//[dieZeile release];
	[ValueKeyTabelle addObject:dieZeile]; 
	//NSLog(@"ValueKeyTabelle: %@",[ValueKeyTabelle description]);
}


- (void)clearTabelle
{
[ValueKeyTabelle  removeAllObjects];

}

/*
- (void)addTagplan:(NSArray*)derTagplan
{
	//NSLog(@"AVR_DS setWochenplan");
	int anz=[derTagplan count];
	int i,k;
	k=0;
	for (i=0;i<anz;i++)
	{

	NSMutableDictionary* tempTagDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[tempTagDic setObject:[NSNumber numberWithInt:i] forKey:@"stunde"];

	[ValueKeyTabelle addObject:tempTagDic];
	
	
	}
	
}
*/



- (int)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return [ValueKeyTabelle count];
}


- (id)tableView:(NSTableView *)aTableView
    objectValueForTableColumn:(NSTableColumn *)aTableColumn 
			row:(int)rowIndex
{
	//NSLog(@"objectValueForTableColumn");
    NSDictionary *einTestDic = [NSDictionary dictionary];
	if (rowIndex<[ValueKeyTabelle count])
	{
			einTestDic = [ValueKeyTabelle objectAtIndex: rowIndex];
			
	}
	//NSLog(@"einTestDic  art: %@ wert: %@",[einTestDic objectForKey:@"art"],[einTestDic objectForKey:@"wert"]);

	return [einTestDic objectForKey:[aTableColumn identifier]];
	
}

- (void)tableView:(NSTableView *)aTableView 
   setObjectValue:(id)anObject 
   forTableColumn:(NSTableColumn *)aTableColumn 
			  row:(int)rowIndex
{
		//NSLog(@"setObjectValue ForTableColumn");

    NSMutableDictionary* einTestDic;
    if (rowIndex<[ValueKeyTabelle count])
	{
		einTestDic=[ValueKeyTabelle objectAtIndex:rowIndex];
		[einTestDic setObject:anObject forKey:[aTableColumn identifier]];
	}
}

@end
