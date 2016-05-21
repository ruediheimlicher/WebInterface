//
//  rEinstellungen.h
//  WebInterface
//
//  Created by Sysadmin on 12.November.09.
//  Copyright 2009 Ruedi Heimlicher. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "defines.h"


@interface rEinstellungen : NSWindowController <NSControlTextEditingDelegate>
{
   IBOutlet id RaumPop;
   
   NSMutableArray* HomebusArray;
   NSMutableIndexSet* updateIndexSet;
}
- (void)setEinstellungen:(NSArray*)homebusarray;
- (IBAction)reportRaumPop:(id)sender;

- (IBAction)reportSave:(id)sender;
- (IBAction)reportCancel:(id)sender;
- (IBAction)reportClose:(id)sender;

- (void)setObjektnamenVonArray:(NSArray*)objektnamen;
- (void)saveObjektnamen;
@end
