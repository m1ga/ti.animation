/**
 * Ti.Lottie
 * Copyright (c) 2017-present by Hans Knöchel. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiAnimationAnimationViewProxy.h"
#import "TiAnimationAnimationView.h"
#import "TiAnimationConstants.h"
#import "TiUtils.h"

#import <Lottie/Lottie.h>

@implementation TiAnimationAnimationViewProxy

- (NSArray *)keySequence {
  return @[ @"file", @"contentMode", @"autoStart" ];
}

- (TiAnimationAnimationView *)animationView {
  return (TiAnimationAnimationView *)self.view;
}

#pragma mark Public APIs
#pragma mark - Controlling

- (void)start:(id)args {
  ENSURE_UI_THREAD(start, args);

  if ([args count] == 1) {
    KrollCallback *callback = nil;
    ENSURE_ARG_AT_INDEX(callback, args, 0, KrollCallback);

    [[self animationView] playWithCompletionHandler:callback];
  } else if ([args count] >= 2) {
    NSNumber *startFrame = @(0);
    NSNumber *endFrame = @(0);
    KrollCallback *callback;

    ENSURE_ARG_AT_INDEX(startFrame, args, 0, NSNumber);
    ENSURE_ARG_AT_INDEX(endFrame, args, 1, NSNumber);
    ENSURE_ARG_OR_NIL_AT_INDEX(callback, args, 2, KrollCallback);

    [[self animationView] playFromFrame:startFrame toFrame:endFrame completion:callback];
  } else {
    [[self animationView] playWithCompletionHandler:nil];
  }
}

- (void)resume:(id)unused {
  [self start:nil];
}

- (void)stop:(id)unused {
  ENSURE_UI_THREAD(stop, unused);
  [[self animationView] stop];
}

- (void)pause:(id)unused {
  ENSURE_UI_THREAD(pause, unused);
  [[self animationView] pause];
}

#pragma mark - Properties

- (void)setProgress:(id)progress {
  ENSURE_UI_THREAD(setProgress, progress);
  ENSURE_TYPE(progress, NSNumber);

  [[self animationView] setProgress:[TiUtils floatValue:progress]];
  [self replaceValue:progress forKey:@"progress" notification:NO];
}

- (id)progress {
  return @([[self animationView] progress]);
}

- (void)setSpeed:(id)speed {
  ENSURE_UI_THREAD(setSpeed, speed);
  ENSURE_TYPE(speed, NSNumber);

  [[self animationView] setSpeed:[TiUtils floatValue:speed]];
  [self replaceValue:speed forKey:@"speed" notification:NO];
}

- (id)speed {
  return @([[self animationView] speed]);
}

- (void)setLoop:(id)loop {
  ENSURE_UI_THREAD(setLoop, loop);
  ENSURE_TYPE(loop, NSNumber);

  [[self animationView] setLoop:[TiUtils boolValue:loop]];
  [self replaceValue:loop forKey:@"loop" notification:NO];
}

- (id)loop {
  return @([[self animationView] loop]);
}

- (void)setCache:(id)cache {
  ENSURE_UI_THREAD(setCache, cache);
  ENSURE_TYPE(cache, NSNumber);

  [[self animationView] setCacheEnabled:[TiUtils boolValue:cache]];
  [self replaceValue:cache forKey:@"cache" notification:NO];
}

- (id)cache {
  return @([[self animationView] cacheEnabled]);
}

- (id)isPlaying:(id)unused {
  return @([[self animationView] isPlaying]);
}

- (id)duration {
  return @([[self animationView] duration]);
}

#pragma mark - Layers

- (void)addViewToKeypathLayer:(id)args {
  ENSURE_UI_THREAD(addViewToKeypathLayer, args);
  ENSURE_SINGLE_ARG(args, NSDictionary);

  id viewProxy = [args objectForKey:@"view"];
  id keypathLayer = [args objectForKey:@"layer"];

  ENSURE_TYPE(viewProxy, TiViewProxy);
  ENSURE_TYPE(keypathLayer, NSString);

  [self rememberProxy:viewProxy];

  [[self animationView] addView:[viewProxy view] toKeypathLayer:keypathLayer];
}

#pragma mark - Convert

- (void)convertRectToKeypathLayer:(id)args {
  ENSURE_UI_THREAD(convertRectToKeypathLayer, args);
  ENSURE_SINGLE_ARG(args, NSArray);

  CGRect rect = [TiUtils rectValue:[args objectAtIndex:0]];
  LOTKeypath *keypathLayer = [LOTKeypath keypathWithString:[args objectAtIndex:1]];

  [[[self animationView] animationView] convertRect:rect toKeypathLayer:keypathLayer];
}

- (void)convertPointToKeypathLayer:(id)args {
  ENSURE_UI_THREAD(convertRectToKeypathLayer, args);
  ENSURE_SINGLE_ARG(args, NSArray);

  CGPoint point = [TiUtils pointValue:[args objectAtIndex:0]];
  LOTKeypath *keypathLayer = [LOTKeypath keypathWithString:[args objectAtIndex:1]];

  [[[self animationView] animationView] convertPoint:point toKeypathLayer:keypathLayer];
}

- (void)convertRectFromKeypathLayer:(id)args {
  ENSURE_UI_THREAD(convertRectToKeypathLayer, args);
  ENSURE_SINGLE_ARG(args, NSArray);

  CGRect rect = [TiUtils rectValue:[args objectAtIndex:0]];
  LOTKeypath *keypathLayer = [LOTKeypath keypathWithString:[args objectAtIndex:1]];

  [[[self animationView] animationView] convertRect:rect fromKeypathLayer:keypathLayer];
}

- (void)convertPointFromKeypathLayer:(id)args {
  ENSURE_UI_THREAD(convertRectToKeypathLayer, args);
  ENSURE_SINGLE_ARG(args, NSArray);

  CGPoint point = [TiUtils pointValue:[args objectAtIndex:0]];
  LOTKeypath *keypathLayer = [LOTKeypath keypathWithString:[args objectAtIndex:1]];

  [[[self animationView] animationView] convertPoint:point fromKeypathLayer:keypathLayer];
}

#pragma mark - Dynamic Properties

- (void)setValueDelegateForKeyPath:(id)args {
  ENSURE_UI_THREAD(setValueDelegateForKeyPath, args);
  ENSURE_SINGLE_ARG(args, NSDictionary);

  id<LOTValueDelegate> valueDelegate = nil;

  NSNumber *type = [args objectForKey:@"type"];
  id value = [args objectForKey:@"value"];
  id keypath = [args objectForKey:@"keypath"];

  ENSURE_TYPE(type, NSNumber);
  ENSURE_TYPE(valueDelegate, NSObject);
  ENSURE_TYPE(keypath, NSString);

  switch ([TiUtils intValue:@"type" properties:args]) {
  case TiLottieCallbackPathValue: {
    CGPathRef path = CGPathCreateWithRect([TiUtils rectValue:value], NULL);
    valueDelegate = [LOTPathValueCallback withCGPath:path];
    CGPathRelease(path);
    break;
  }
  case TiLottieCallbackPathBlock:
    NSLog(@"[WARN] Not implemented, yet");
    break;
  case TiLottieCallbackColorValue:
    valueDelegate = [LOTColorValueCallback withCGColor:[TiUtils colorValue:value].color.CGColor];
    break;
  case TiLottieCallbackColorBlock:
    NSLog(@"[WARN] Not implemented, yet");
    break;
  case TiLottieCallbackNumberValue:
    valueDelegate = [LOTNumberValueCallback withFloatValue:[TiUtils floatValue:value]];
    break;
  case TiLottieCallbackNumberBlock:
    NSLog(@"[WARN] Not implemented, yet");
    break;
  case TiLottieCallbackPointValue:
    valueDelegate = [LOTPointValueCallback withPointValue:[TiUtils pointValue:value]];
    break;
  case TiLottieCallbackPointBlock:
    NSLog(@"[WARN] Not implemented, yet");
    break;
  case TiLottieCallbackSizeValue:
    valueDelegate = [LOTSizeValueCallback
        withPointValue:CGSizeMake([TiUtils floatValue:[value objectForKey:@"width"]], [TiUtils floatValue:[value objectForKey:@"height"]])];
    break;
  case TiLottieCallbackSizeBlock:
    NSLog(@"[WARN] Not implemented, yet");
    break;
  }

  if (valueDelegate == nil) {
    NSLog(@"[ERROR] Cannot set value delegate for given type!");
    return;
  }

  [[[self animationView] animationView] setValueDelegate:valueDelegate forKeypath:[LOTKeypath keypathWithString:[args objectForKey:@"keypath"]]];
}

@end
