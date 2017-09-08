/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2017 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiUIView.h"

@class LOTAnimationView;

@interface TiAnimationLottieView : TiUIView {
}

@property (nonatomic, retain) LOTAnimationView *animationView;

- (void)play;
- (void)playWithCompletionHandler:(KrollCallback *)callback;
- (void)pause;
- (void)addView:(UIView *)view toLayer:(NSString *)layer;

- (void)setProgress:(CGFloat)progress;
- (void)setSpeed:(CGFloat)speed;
- (void)setLoop:(BOOL)loop;
- (CGFloat)getProgress;
- (CGFloat)getSpeed;
- (CGFloat)getDuration;
- (BOOL)getLoop;
- (BOOL)isPlaying;

@end
