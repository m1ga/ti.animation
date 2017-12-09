/**
 * Ti.Lottie
 * Copyright (c) 2017-present by Hans Knöchel. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiUIView.h"

NS_ASSUME_NONNULL_BEGIN

@class LOTAnimationView;

@interface TiAnimationLottieView : TiUIView

@property (nonatomic, retain) LOTAnimationView *animationView;

- (void)playWithCompletionHandler:(KrollCallback * __nullable)callback;
- (void)playFromFrame:(NSNumber *)fromFrame toFrame:(NSNumber *)toFrame completion:(KrollCallback * __nullable)callback;
- (void)pause;
- (void)stop;
- (void)addView:(UIView *)view toLayer:(NSString *)layer applyTransform:(BOOL)applyTransform;

- (void)setProgress:(CGFloat)progress;
- (void)setSpeed:(CGFloat)speed;
- (void)setLoop:(BOOL)loop;
- (CGFloat)progress;
- (CGFloat)speed;
- (CGFloat)duration;
- (BOOL)loop;
- (BOOL)isPlaying;

@end

NS_ASSUME_NONNULL_END
