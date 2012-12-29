//
//  rEinstellungen.h
//  WebInterface
//
//  Created by Sysadmin on 12.November.09.
//  Copyright 2009 Ruedi Heimlicher. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface rEinstellungen : NSWindowController
{
   IBOutlet id RaumPop;
   
   NSMutableArray* HomebusArray;
}
- (void)setEinstellungen:(NSArray*)homebusarray;
- (IBAction)reportRaumPop:(id)sender;


- (IBAction)reportSave:(id)sender;
- (IBAction)reportCancel:(id)sender;
- (IBAction)reportClose:(id)sender;

- (void)setObjektnamenVonArray:(NSArray*)objektnamen;
@end
