/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2017-present by Hans Knöchel. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiAnimationModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiLottieConstants.h"
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

MAKE_SYSTEM_PROP(CALLBACK_COLOR_BLOCK, TiLottieCallbackColorBlock); // Unused
MAKE_SYSTEM_PROP(CALLBACK_COLOR_VALUE, TiLottieCallbackColorValue);
MAKE_SYSTEM_PROP(CALLBACK_NUMBER_BLOCK, TiLottieCallbackNumberBlock); // Unused
MAKE_SYSTEM_PROP(CALLBACK_NUMBER_VALUE, TiLottieCallbackNumberValue);
MAKE_SYSTEM_PROP(CALLBACK_POINT_BLOCK, TiLottieCallbackPointBlock); // Unused
MAKE_SYSTEM_PROP(CALLBACK_POINT_VALUE, TiLottieCallbackPointValue);
MAKE_SYSTEM_PROP(CALLBACK_SIZE_BLOCK, TiLottieCallbackSizeBlock); // Unused
MAKE_SYSTEM_PROP(CALLBACK_SIZE_VALUE, TiLottieCallbackSizeValue);
MAKE_SYSTEM_PROP(CALLBACK_PATH_BLOCK, TiLottieCallbackPathBlock); // Unused
MAKE_SYSTEM_PROP(CALLBACK_PATH_VALUE, TiLottieCallbackPathValue);

@end
