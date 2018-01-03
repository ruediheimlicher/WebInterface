//
//  IOCode.m
//  IOWarriorProber
//
//  Created by Sysadmin on 19.02.06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "IOWarriorWindowController.h"

//extern NSString* kReportDirectionOut;

@implementation  IOWarriorWindowController(rOutput)
//static NSString* kReportDirectionIn = @"R";
extern NSString* kReportDirectionIn;
static NSString* kReportDirectionOut = @"W";



- (void)SendAktion:(NSNotification*)note
{
	NSLog(@"kReportDirectionIn: %@",kReportDirectionIn);
	//NSLog(@"Output SendAktion note: %@",[[note userInfo]description]);
	//NSMutableArray* SendArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
	NSNumber* PaketIndexNumber=[[note userInfo]objectForKey:@"paketnummer"];
	int PaketIndex=-1;
	if (PaketIndexNumber &&([PaketIndexNumber intValue]>=0))
	{
		PaketIndex=[PaketIndexNumber intValue];
		NSString* tempHexString=[[note userInfo]objectForKey:@"hexstring"];
		if (tempHexString &&[tempHexString length])
		{
			//[HexDatenArray replaceObjectAtIndex:PaketIndex withObject:tempHexString];

		}
	}//if PaketNumber
	//NSLog(@"SendTastenAktion:  HexDatenArray: %@",[HexDatenArray description]);
	//[self WriteHexStringArray:HexDatenArray];
}


- (void)SendTastenAktion:(NSNotification*)note
{
NSLog(@"Output SendTastenAktion: start");
	NSLog(@"Output SendTastenAktion note: %@",[[note userInfo]description]);
	//NSMutableArray* SendArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
	NSNumber* PaketIndexNumber=[[note userInfo]objectForKey:@"paketnummer"];
	int PaketIndex=-1;
	if (PaketIndexNumber &&([PaketIndexNumber intValue]>=0))
	{
		PaketIndex=[PaketIndexNumber intValue];
		NSString* tempHexString=[[note userInfo]objectForKey:@"hexstring"];
		if (tempHexString &&[tempHexString length])
		{
			//[HexDatenArray replaceObjectAtIndex:PaketIndex withObject:tempHexString];

		}
	}//if PaketNumber
	//NSLog(@"SendTastenAktion:  HexDatenArray: %@",[HexDatenArray description]);
	//[self WriteHexStringArray:HexDatenArray];
}
/*
 - (void)writeDigit:(id)sender
 {
	//NSString* hexString=[HexEingabe0 HexFeld];
		NSMutableArray* TastenArray=[[NSMutableArray alloc]initWithCapacity:0];
	int PaketNummer=0;

	int i;
	for (i=0;i<4;i++)
	{
		if (i==PaketNummer)
		{
			
		}
		else
		{
			[TastenArray addObject:@"00"];
		}
	}//for i
	
	[self WriteHexStringArray:TastenArray];

 }
 */
- (void)EinzelTastenAktion:(NSNotification*)note
{
	NSLog(@"EinzelTastenAktion note: %@",[[note userInfo]description]);
	NSMutableArray* TastenArray=[[NSMutableArray alloc]initWithCapacity:0];
	int PaketNummer=[[[note userInfo]objectForKey:@"paketnummer"]intValue];

	int i;
	for (i=0;i<4;i++)
	{
		if (i==PaketNummer)
		{
			NSString* hexString=[[note userInfo]objectForKey:@"hexstring"];
			if (hexString&&[hexString length]==2)
			{
				[TastenArray addObject:[self DigiStringAusChar:[hexString characterAtIndex:0]]];
			}
			else
			{
				[TastenArray addObject:@"00"];
			}
			
		}
		else
		{
			[TastenArray addObject:@"00"];
		}
	}//for i
	
	//[self WriteHexStringArray:TastenArray];
}

- (void)TastenAktion:(NSNotification*)note
{
	NSLog(@"TastenAktion note: %@",[[note userInfo]description]);
	NSMutableArray* TastenArray=[[NSMutableArray alloc]initWithCapacity:0];
	int PaketNummer=[[[note userInfo]objectForKey:@"paketnummer"]intValue];
	int i;
	for (i=0;i<4;i++)
	{
		if (i==PaketNummer)
		{
			NSString* hexString=[[note userInfo]objectForKey:@"hexstring"];
			if (hexString&&[hexString length]==2)
			{
				[TastenArray addObject:[[note userInfo]objectForKey:@"hexstring"]];
			}
			else
			{
				[TastenArray addObject:@"00"];
			}
			
		}
		else
		{
			[TastenArray addObject:@"00"];
		}
	}//for i
	
	
	
	
//	[self WriteHexStringArray:TastenArray];
	
}

- (void)writeDigiVonString:(NSString*)derString
{
	NSLog(@"writeDigit: %@",derString);
	int i;
	for(i=0;i<[derString length];i++)
	{
		NSString* charString=[self DigiStringAusChar:[derString characterAtIndex:i]];
		NSLog(@"writeDigit: charString: %@",charString);
		NSArray*charArray=[NSArray arrayWithObjects:[charString substringToIndex:1],[charString substringFromIndex:1],nil];
		NSLog(@"writeDigit: charArray: %@",[charArray description]);
		//[self WriteHexStringArray:charArray];
	}
}

- (NSString*)DigiStringAusChar:(unichar)derChar
{
NSLog(@"DigiStringAusChar: %C  als int: %d",derChar,(int)derChar);
NSString* c;
switch ((int)derChar)
{
case 48:{c=@"BF"; break;}//0
case 49:{c=@"06"; break;}//1
case 50:{c=@"5B"; break;}//2
case 51:{c=@"4f"; break;}//3
case 52:{c=@"66"; break;}//4
case 53:{c=@"6d"; break;}//5
case 54:{c=@"7d"; break;}//6
case 55:{c=@"07"; break;}//7
case 56:{c=@"7f"; break;}//8
case 57:{c=@"6f"; break;}//9
case 65:{c=@"77"; break;}//A
case 66:{c=@"7c"; break;}//B
case 67:{c=@"39"; break;}//C
case 68:{c=@"5e"; break;}//D
case 69:{c=@"79"; break;}//E
case 70:{c=@"71"; break;}//F
default:{return @"00";}
}//switch
NSLog(@"DigiStringAusChar result: %@",c);
return [c uppercaseString];
}

- (NSNumber*)NumberAusHex: (NSString*)derHexString
{
NSScanner *scanner;
uint tempInt;
scanner = [NSScanner scannerWithString:derHexString];
[scanner scanHexInt:&tempInt];
NSNumber* number = [NSNumber numberWithInt:tempInt];
return number;
}

/*
- (void)WriteHexStringArray:(NSArray*)derHexStringArray
{
    char*                           buffer;
    int                             i;
    int                             result = 0;
    int                             reportID = -1;
    IOWarriorListNode*              listNode;
    int                             reportSize;


    if (NO == IOWarriorIsPresent ())
    {
        NSRunAlertPanel (@"Kein IOWarrior gefunden", @"Es ist kein Interface eingesteckt.", @"OK", nil, nil);
        [NSApp terminate:self];
		return;
    }
    reportSize = [self reportSizeForInterfaceType:[self currentInterfaceType]];
	//NSLog(@"doWrite: reportSize: %d",reportSize);
    buffer = malloc (reportSize);
    for (i = 0 ; i < reportSize ; i++)
    {
        NSControl *theSubview;
        NSScanner *theScanner;
        UInt	  value;
        
        //theSubview = (NSControl*) [[window contentView] viewWithTag:i + 100];

        theScanner = [NSScanner scannerWithString:[derHexStringArray objectAtIndex:i]];
		
        if ([theScanner scanHexInt:&value])
        {
			//NSLog(@"doWrite: index: %d	string: %@		value: %d	",i,[derHexStringArray objectAtIndex:i],value);
            buffer[i] = (char) value;
        }
        else
        {
            NSRunAlertPanel (@"Invalid data format", @"Please only use hex values between 00 and FF.", @"OK", nil, nil);
            free (buffer);
            return;
        }
    }
    
    listNode = IOWarriorInterfaceListNodeAtIndex ([interfacePopup indexOfSelectedItem]);
    if (listNode)
    {
        if (![self reportIdRequiredForWritingToInterfaceOfType:listNode->interfaceType])
        {
            result = IOWarriorWriteToInterface (listNode->ioWarriorHIDInterface, reportSize, buffer);
        }
        else
        {
            if ([[NSScanner scannerWithString:[reportIDField stringValue]] scanHexInt:&reportID])
            {
                char tempBuffer[reportSize + 1];
    
                tempBuffer[0] = reportID;
    
                memcpy (&tempBuffer[1], buffer, reportSize);
                
                result = IOWarriorWriteToInterface (listNode->ioWarriorHIDInterface, reportSize + 1, tempBuffer);
            }
            else
            {
                NSRunAlertPanel (@"Invalid report id number format", @"Please only use hex values between 00 and FF.", @"OK", nil, nil);
            }
        }
        
        if (0 != result)
            NSRunAlertPanel (@"IOWarrior Error", @"An error occured while trying to write to the selected IOWarrior device.", @"OK", nil, nil);
        else
        {
			//NSLog(@"WriteHexStringArray: %@  %@ %x",[NSString stringWithUTF8String:buffer],[NSString stringWithCString:buffer],buffer);
            [self addLogEntryWithDirection:kReportDirectionOut
                                reportID:reportID
                                reportSize:reportSize
                                reportData:buffer];
        }
    }
    free (buffer);
}
*/
/*
- (void)WriteHexArray:(NSArray*)derHexArray
{
    char*                           buffer;
    int                             i;
    int                             result = 0;
    IOWarriorListNode*              listNode;
    int                             reportSize;
	int								reportID;
	//NSLog(@"WriteHexArray derHexArray: %@",[derHexArray description]);
     reportSize = [self reportSizeForInterfaceType:[self currentInterfaceType]];
	reportID=[[derHexArray objectAtIndex:0]intValue];
	//NSLog(@"WriteHexArray: reportSize: %d",reportSize);
    buffer = malloc (reportSize+1);
    for (i = 0 ; i < reportSize+1 ; i++)
    {
		int wert=0x00;
		if (i<[derHexArray count])
		{
            buffer[i] = (char) [[derHexArray objectAtIndex:i]intValue];
			
			}
			else
			{
			//buffer[i] = (char) 0x00;
			}
			//NSLog(@"buffer: i: %d wert: %02X buffer: %02X",i,wert,buffer[i]);
		}
    //NSLog(@"WriteHexArray: nach buffer\n");
    listNode = IOWarriorInterfaceListNodeAtIndex ([interfacePopup indexOfSelectedItem]);
    if (listNode)
    {
		result = IOWarriorWriteToInterface (listNode->ioWarriorHIDInterface, reportSize + 1, buffer);
		
        if (0 != result)
		{
            NSRunAlertPanel (@"IOWarrior Error", @"An error occured while trying to write to the selected IOWarrior device.", @"OK", nil, nil);
			
		}
		else
        {
			//NSLog(@"WriteHexArray: UTF8 %@ \nC %@ \nchar: %x",[NSString stringWithUTF8String:buffer],[NSString stringWithCString:buffer],buffer);
			for (i=1;i<reportSize+1;i++)
			{
				buffer[i-1]=buffer[i];
				
			} 
			[self addLogEntryWithDirection:kReportDirectionOut
								  reportID:reportID
                                reportSize:reportSize
                                reportData:buffer];
			
        }
    }//if listNode
    free (buffer);
}
*/
@end
