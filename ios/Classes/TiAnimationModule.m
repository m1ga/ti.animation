/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2017 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiAnimationModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

@implementation TiAnimationModule

#pragma mark Internal

- (id)moduleGUID
{
  return @"1fcfea69-bbbf-42f8-b738-9545b5dda74d";
}

- (NSString *)moduleId
{
  return @"ti.animation";
}

#pragma mark Lifecycle

- (void)startup
{
  [super startup];

  NSLog(@"[DEBUG] %@ loaded", self);
}

MAKE_SYSTEM_PROP(CONTENT_MODE_ASPECT_FIT, UIViewContentModeScaleAspectFit);
MAKE_SYSTEM_PROP(CONTENT_MODE_ASPECT_FILL, UIViewContentModeScaleAspectFill);
MAKE_SYSTEM_PROP(CONTENT_MODE_SCALE_FILL, UIViewContentModeScaleToFill);

@end
