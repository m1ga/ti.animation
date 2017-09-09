/**
 * Ti.Lottie
 * Copyright (c) 2017-present by Hans Knöchel. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiAnimationLottieView.h"
#import "TiViewProxy.h"

NS_ASSUME_NONNULL_BEGIN

@interface TiAnimationLottieViewProxy : TiViewProxy

#pragma mark Methods

- (TiAnimationLottieView *)animationView;

- (void)start:(id __nullable)args;
- (void)pause:(id __nullable)unused;
- (void)resume:(id __nullable)unused;
- (void)stop:(id __nullable)unused;
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

NS_ASSUME_NONNULL_END
