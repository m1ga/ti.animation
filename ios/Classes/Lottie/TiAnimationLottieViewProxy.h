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

#pragma mark Module Utilities

- (TiAnimationLottieView *)animationView;

#pragma mark Public API's

#pragma mark - Controlling

- (void)start:(id __nullable)args;
- (void)pause:(id __nullable)unused;
- (void)resume:(id __nullable)unused;
- (void)stop:(id __nullable)unused;

#pragma mark - Properties

- (id)progress;
- (id)speed;
- (id)loop;
- (void)setCache:(id)cache;
- (id)cache;
- (id)duration;
- (id)isPlaying:(id)unused;
- (void)setProgress:(id)progress;
- (void)setSpeed:(id)speed;
- (void)setLoop:(id)animation;

#pragma mark - Layers

- (void)addViewToLayer:(id)args;
- (void)addViewToKeypathLayer:(id)args;

#pragma mark - Convert

- (void)convertRectToKeypathLayer:(id)args;
- (void)convertPointToKeypathLayer:(id)args;
- (void)convertRectFromKeypathLayer:(id)args;
- (void)convertPointFromKeypathLayer:(id)args;

#pragma mark - Dynamic Properties

- (void)setValueDelegateForKeyPath:(id)args;

@end

NS_ASSUME_NONNULL_END
