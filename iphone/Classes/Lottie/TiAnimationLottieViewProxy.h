/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2017 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiViewProxy.h"

@class LOTAnimationView;

@interface TiAnimationLottieViewProxy : TiViewProxy {
    LOTAnimationView *animationView;
}

- (LOTAnimationView *)animationView;

#pragma mark Methods

- (void)start:(id)args;

- (void)pause:(id)unused;

- (void)addViewToLayer:(id)args;

- (id)isPlaying:(id)unused;

#pragma mark Properties

- (void)setProgress:(id)progress;

- (id)progress;

- (void)setSpeed:(id)speed;

- (id)speed;

- (void)setLoop:(id)animation;

- (id)loop;

- (id)duration;

@end
