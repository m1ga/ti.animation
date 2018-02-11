/**
 * Ti.Lottie
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
#pragma mark - Controlling

- (void)start:(id)args
{
  ENSURE_UI_THREAD(start, args);

  if ([args count] == 1) {
    KrollCallback *callback = nil;
    ENSURE_ARG_AT_INDEX(callback, args, 0, KrollCallback);

    [[self animationView] playWithCompletionHandler:callback];
  } else if ([args count] >= 2) {
    NSNumber *startFrame;
    NSNumber *endFrame;
    KrollCallback *callback;
    
    ENSURE_ARG_AT_INDEX(startFrame, args, 0, NSNumber);
    ENSURE_ARG_AT_INDEX(endFrame, args, 1, NSNumber);
    ENSURE_ARG_OR_NIL_AT_INDEX(callback, args, 2, KrollCallback);
    
    [[self animationView] playFromFrame:startFrame toFrame:endFrame completion:callback];
  } else {
    [[self animationView] playWithCompletionHandler:nil];
  }
}

- (void)resume:(id)unused
{
  [self start:nil];
}

- (void)stop:(id)unused
{
  ENSURE_UI_THREAD(stop, unused);
  [[self animationView] stop];
}

- (void)pause:(id)unused
{
  ENSURE_UI_THREAD(pause, unused);
  [[self animationView] pause];
}

#pragma mark - Properties

- (void)setProgress:(id)progress
{
  ENSURE_UI_THREAD(setProgress, progress);
  ENSURE_TYPE(progress, NSNumber);
  
  [[self animationView] setProgress:[TiUtils floatValue:progress]];
  [self replaceValue:progress forKey:@"progress" notification:NO];
}

- (id)progress
{
  return NUMFLOAT([[self animationView] progress]);
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
  return NUMFLOAT([[self animationView] speed]);
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
  return NUMBOOL([[self animationView] loop]);
}

- (void)setCache:(id)cache
{
  ENSURE_UI_THREAD(setCache, cache);
  ENSURE_TYPE(cache, NSNumber);
  
  [[self animationView] setCacheEnabled:[TiUtils boolValue:cache]];
  [self replaceValue:cache forKey:@"cache" notification:NO];
}

- (id)cache
{
  return NUMBOOL([[self animationView] cacheEnabled]);
}

- (id)isPlaying:(id)unused
{
  return NUMBOOL([[self animationView] isPlaying]);
}

- (id)duration
{
  return NUMFLOAT([[self animationView] duration]);
}

#pragma mark - Layers

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

- (void)addViewToKeypathLayer:(id)args
{
  ENSURE_UI_THREAD(addViewToLayer, args);
  ENSURE_SINGLE_ARG(args, NSDictionary);
  
  id viewProxy = [args objectForKey:@"view"];
  id keypathLayer = [args objectForKey:@"layer"];
  
  ENSURE_TYPE(viewProxy, TiViewProxy);
  ENSURE_TYPE(keypathLayer, NSString);
  
  [self rememberProxy:viewProxy];
  
  [[self animationView] addView:[viewProxy view] toKeypathLayer:keypathLayer];
}

#pragma mark - Convert

- (void)convertRectToKeyPathLayer:(id)args
{
  ENSURE_UI_THREAD(convertRectToKeyPathLayer, args);
  ENSURE_SINGLE_ARG(args, NSArray);
  
  CGRect rect = [TiUtils rectValue:[args objectAtIndex:0]];
  LOTKeypath *keypathLayer = [LOTKeypath keypathWithString:[args objectAtIndex:0]];
  
  [[[self animationView] animationView] convertRect:rect toKeypathLayer:keypathLayer];
}

- (void)convertPointToKeyPathLayer:(id)args
{
  ENSURE_UI_THREAD(convertRectToKeyPathLayer, args);
  ENSURE_SINGLE_ARG(args, NSArray);
  
  CGPoint point = [TiUtils pointValue:[args objectAtIndex:0]];
  LOTKeypath *keypathLayer = [LOTKeypath keypathWithString:[args objectAtIndex:0]];
  
  [[[self animationView] animationView] convertPoint:point toKeypathLayer:keypathLayer];
}

- (void)convertRectFromKeyPathLayer:(id)args
{
  ENSURE_UI_THREAD(convertRectToKeyPathLayer, args);
  ENSURE_SINGLE_ARG(args, NSArray);
  
  CGRect rect = [TiUtils rectValue:[args objectAtIndex:0]];
  LOTKeypath *keypathLayer = [LOTKeypath keypathWithString:[args objectAtIndex:0]];
  
  [[[self animationView] animationView] convertRect:rect fromKeypathLayer:keypathLayer];
}

- (void)convertPointFromKeyPathLayer:(id)args
{
  ENSURE_UI_THREAD(convertRectToKeyPathLayer, args);
  ENSURE_SINGLE_ARG(args, NSArray);
  
  CGPoint point = [TiUtils pointValue:[args objectAtIndex:0]];
  LOTKeypath *keypathLayer = [LOTKeypath keypathWithString:[args objectAtIndex:0]];
  
  [[[self animationView] animationView] convertPoint:point fromKeypathLayer:keypathLayer];
}

@end
