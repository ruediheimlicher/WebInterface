//
//  Utils.h
//  WebInterface
//
//  Created by Sysadmin on 09.03.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>



@interface Utils : NSObject {
   Utils*                  Util;

}

- (void) logRect:(NSRect)r;
- (NSDateComponents*) heute;


- (NSString*)passwortstring;
@end
