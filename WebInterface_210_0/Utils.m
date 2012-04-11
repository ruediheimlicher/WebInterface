//
//  Utils.m
//  WebInterface
//
//  Created by Sysadmin on 09.03.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "Utils.h"


@implementation Utils
- (void) logRect:(NSRect)r
{
NSLog(@"logRect: origin.x %2.2f origin.y %2.2f size.heigt %2.2f size.width %2.2f",r.origin.x, r.origin.y, r.size.height, r.size.width);
}

@end
