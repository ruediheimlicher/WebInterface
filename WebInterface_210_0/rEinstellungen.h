//
//  rEinstellungen.h
//  WebInterface
//
//  Created by Sysadmin on 12.November.09.
//  Copyright 2009 Ruedi Heimlicher. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface rEinstellungen : NSWindowController {

}
- (void)setEinstellungen:(NSDictionary*)settings;
- (IBAction)reportSave:(id)sender;
- (IBAction)reportCancel:(id)sender;
- (IBAction)reportClose:(id)sender;
@end
