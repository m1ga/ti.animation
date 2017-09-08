/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2017 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiAnimationLottieView.h"
#import "TiViewProxy.h"

@interface TiAnimationLottieViewProxy : TiViewProxy {
}

#pragma mark Methods

- (TiAnimationLottieView *)animationView;

- (void)start:(id)args;
- (void)pause:(id)unused;
- (void)resume:(id)unused;
- (void)addViewToLayer:(id)args;

#pragma mark Properties

- (id)progress;
- (id)speed;
- (id)loop;
- (id)duration;
- (id)isPlaying:(id)unused;
- (void)setProgress:(id)progress;
- (void)setSpeed:(id)speed;
- (void)setLoop:(id)animation;

@end
