/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2017-present by Hans Knöchel. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiAnimationLottieViewProxy.h"
#import "Lottie.h"
#import "TiAnimationLottieView.h"
#import "TiUtils.h"

@implementation TiAnimationLottieViewProxy

- (NSArray *)keySequence
{
  return @[ @"file", @"contentMode", @"autoStart" ];
}

- (TiAnimationLottieView *)animationView
{
  return (TiAnimationLottieView *)self.view;
}

#pragma mark Public APIs

- (void)start:(id)args
{
  ENSURE_UI_THREAD(start, args);

  if ([args count] == 1) {
    KrollCallback *callback = nil;

    ENSURE_ARG_AT_INDEX(callback, args, 0, KrollCallback);

    [[self animationView] playWithCompletionHandler:callback];
  } else {
    [[self animationView] play];
  }
}

- (void)resume:(id)unused
{
  [self start:nil];
}

- (void)pause:(id)unused
{
  ENSURE_UI_THREAD(pause, unused);
  [[self animationView] pause];
}

- (void)setProgress:(id)progress
{
  ENSURE_UI_THREAD(setProgress, progress);
  ENSURE_TYPE(progress, NSNumber);

  [[self animationView] setProgress:[TiUtils floatValue:progress]];
  [self replaceValue:progress forKey:@"progress" notification:NO];
}

- (id)progress
{
  return NUMFLOAT([[self animationView] getProgress]);
}

- (void)setSpeed:(id)speed
{
  ENSURE_UI_THREAD(setSpeed, speed);
  ENSURE_TYPE(speed, NSNumber);

  [[self animationView] setSpeed:[TiUtils floatValue:speed]];
  [self replaceValue:speed forKey:@"speed" notification:NO];
}

- (id)speed
{
  return NUMFLOAT([[self animationView] getSpeed]);
}

- (void)setLoop:(id)loop
{
  ENSURE_UI_THREAD(setLoop, loop);
  ENSURE_TYPE(loop, NSNumber);

  [[self animationView] setLoop:[TiUtils boolValue:loop]];
  [self replaceValue:loop forKey:@"loop" notification:NO];
}

- (id)loop
{
  return NUMBOOL([[self animationView] getLoop]);
}

- (id)isPlaying:(id)unused
{
  return NUMBOOL([[self animationView] isPlaying]);
}

- (id)duration
{
  return NUMFLOAT([[self animationView] getDuration]);
}

- (void)addViewToLayer:(id)args
{
  ENSURE_UI_THREAD(addViewToLayer, args);
  ENSURE_SINGLE_ARG(args, NSDictionary);

  id viewProxy = [args objectForKey:@"view"];
  id layerName = [args objectForKey:@"layer"];
  id applyTransform = [args objectForKey:@"applyTransform"];

  ENSURE_TYPE(viewProxy, TiViewProxy);
  ENSURE_TYPE(layerName, NSString);
  ENSURE_TYPE_OR_NIL(applyTransform, NSNumber);

  [self rememberProxy:viewProxy];

  [[self animationView] addView:[viewProxy view] toLayer:layerName applyTransform:[TiUtils boolValue:applyTransform def:NO]];
}

@end
