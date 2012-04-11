//
//  rDataController.m
//  WebInterface
//
//  Created by Sysadmin on 12.02.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "IOWarriorWindowController.h"


@implementation IOWarriorWindowController(rDataController)

- (IBAction)showData:(id)sender
{
	//NSLog(@"showData");
	//	[self Alert:@"showData start init"];
	if (!Data)
	  {
	  //[self Alert:@"showData vor init"];
		//NSLog(@"showData neu");
		Data=[[rData alloc]init];
		//[self Alert:@"showData nach init"];
	  }
	  //[self Alert:@"showData nach init"];
//	NSMutableArray* 
//	if ([Data window]) 
	
//	[self Alert:@"showData window da"];

	[Data showWindow:NULL];
	beendet=0;
//	 [self Alert:@"showData nach showWindow"];

}

- (void)setRaumData:(NSDictionary*) derDataDic
{
NSLog(@"DataController setRaumData: DataDic: %@",[derDataDic description]);
}


@end
