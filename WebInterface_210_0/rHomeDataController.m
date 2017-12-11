//
//  rHomeDataController.m
//  WebInterface
//
//  Created by Sysadmin on 12.02.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "IOWarriorWindowController.h"


@implementation IOWarriorWindowController(rHomeDataController)

- (void)startHomeData
{
	if (!HomeData)
	{
		//[self Alert:@"showHomeData vor init"];
		//NSLog(@"showHomeData");
		HomeData=[[rHomeData alloc]init];
		//[self Alert:@"showHomeData nach init"];
	}

}

- (IBAction)showHomeData:(id)sender
{
	//	[self Alert:@"showHomeData start init"];
	if (!HomeData)
	{
		//[self Alert:@"showHomeData vor init"];
		//NSLog(@"showHomeData");
		HomeData=[[rHomeData alloc]init];
		//[self Alert:@"showHomeData nach init"];
	}
	//[self Alert:@"showHomeData nach init"];
	//	NSMutableArray* 
	if ([HomeData window]) 
	{
		//	[self Alert:@"showHomeData window da"];
		
		//[HomeData showWindow:NULL];
	}
	//	 [self Alert:@"showHomeData nach showWindow"];
	
}

-(void)HomeDataKalenderAktion:(NSNotification*)note
{
	NSLog(@"HomeDataKalenderAktion: %@",[[note userInfo]description]);
	if([[note userInfo]objectForKey:@"datum"])
	{
		NSDate* Datum=[[note userInfo]objectForKey:@"datum"];
		NSLog(@"HomeDataKalenderAktion Datum: %@",Datum);
		//[HomeData DataVonHeute];
		NSString* DataString;
		if (Datum == [NSDate date])
		{
		DataString = [HomeData DataVonHeute];
		
		}
		else 
		{
			DataString = [HomeData DataVon:Datum];
		}
		
		[self openWithString: DataString];
	}
	
	
}


-(void)HomeDataSolarKalenderAktion:(NSNotification*)note
{
	//NSLog(@"HomeDataSolarKalenderAktion: %@",[[note userInfo]description]);
	if([[note userInfo]objectForKey:@"datum"])
	{
		NSDate* Datum=[[note userInfo]objectForKey:@"datum"];
		//NSLog(@"HomeDataSolarKalenderAktion Datum: %@",Datum);
		//[HomeData DataVonHeute];
		
		NSString* SolarDataString;
		if (Datum == [NSDate date])
		{
		SolarDataString = [HomeData SolarDataVonHeute];
		
		}
		else 
		{
			SolarDataString = [HomeData SolarDataVon:Datum];
		}
		//NSLog(@"HomeDataSolarKalenderAktion: vor open");
		[self openWithSolarString: SolarDataString];
		
	}
	
	
}


-(void)HomeDataSolarStatistikKalenderAktion:(NSNotification*)note
{
	NSLog(@"HomeDataSolarStatistikKalenderAktion: %@",[[note userInfo]description]);
	if([[note userInfo]objectForKey:@"datum"])
	{
		NSDate* Datum=[[note userInfo]objectForKey:@"datum"];
	}
	int jahr=0;
	if([[note userInfo]objectForKey:@"kalenderjahr"])
	{
		jahr=[[[note userInfo]objectForKey:@"kalenderjahr"]intValue];
	}
	int monat=0;
	if([[note userInfo]objectForKey:@"kalendermonat"])
	{
		monat=[[[note userInfo]objectForKey:@"kalendermonat"]intValue];
	}
	int tag=0;
	if([[note userInfo]objectForKey:@"kalendertag"])
	{
		tag=[[[note userInfo]objectForKey:@"kalendertag"]intValue];
	}
	NSLog(@"HomeDataSolarStatistikKalenderAktion jahr: %d monat: %d tag: %d",jahr, monat, tag);

}



@end
