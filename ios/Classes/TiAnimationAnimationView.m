/**
 * Ti.Lottie
 * Copyright (c) 2017-present by Hans Knöchel. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiAnimationAnimationView.h"
#import "TiAnimationAnimationViewProxy.h"

#import <Lottie/Lottie.h>

@implementation TiAnimationAnimationView

#pragma mark Internals

- (LOTAnimationView *)animationView {
  if (_animationView == nil) {
    id file = [[self proxy] valueForKey:@"file"];
    id autoStart = [[self proxy] valueForKey:@"autoStart"];
    id contentMode = [[self proxy] valueForKey:@"contentMode"];

    ENSURE_TYPE(file, NSString);
    ENSURE_TYPE_OR_NIL(autoStart, NSNumber);
    ENSURE_TYPE_OR_NIL(contentMode, NSNumber);

    // Handle both "file.json" and "file"
    if ([file hasSuffix:@".json"]) {
      file = [file stringByDeletingPathExtension];
    }

    _animationView = [LOTAnimationView animationFromJSON:[self loadAnimationFromJSON:file]];

    // Enable click-events
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickView:)];
    [_animationView addGestureRecognizer:tapGestureRecognizer];

    // Handle content mode
    NSArray<NSNumber *> *validContentModes = @[ @(UIViewContentModeScaleAspectFit), @(UIViewContentModeScaleAspectFill), @(UIViewContentModeScaleToFill) ];

    if (contentMode && [validContentModes containsObject:contentMode]) {
      [_animationView setContentMode:[TiUtils intValue:contentMode]];
    } else {
      [_animationView setContentMode:UIViewContentModeScaleAspectFit];

      if (contentMode) {
        NSLog(@"[ERROR] The \"contentMode\" property is not valid (CONTENT_MODE_ASPECT_FIT, CONTENT_MODE_ASPECT_FILL or CONTENT_MODE_SCALE_FILL), defaulting to CONTENT_MODE_ASPECT_FIT");
      }
    }

    [_animationView setFrame:[self bounds]];

    [self addSubview:_animationView];

    if ([TiUtils boolValue:autoStart def:NO]) {
      [[self animationView] play];
    }
  }

  return _animationView;
}

- (void)didClickView:(UIGestureRecognizer *)sender {
  if ([[self proxy] _hasListeners:@"click"]) {
    [[self proxy] fireEvent:@"click"];
  }
}

- (NSDictionary *)loadAnimationFromJSON:(NSString *)file {
  NSString *filePath = [[NSBundle mainBundle] pathForResource:[[self proxy] valueForKey:@"file"] ofType:nil inDirectory:nil];
  NSData *data = [NSData dataWithContentsOfFile:filePath];

  if (!data) {
    [self log:[NSString stringWithFormat:@"The specified file %@ could not be loaded.", file] forLevel:@"error"];
    return nil;
  }

  return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

- (void)log:(NSString *)string forLevel:(NSString *)level {
  DebugLog(@"[%@] %@: %@", [level uppercaseString], NSStringFromClass([self class]), string);
}

#pragma mark Public APIs

- (void)playWithCompletionHandler:(KrollCallback *)callback {
  [[self animationView] playWithCompletion:^(BOOL animationFinished) {
    [self processCompleteEventWith:callback animationFinished:animationFinished];
  }];
}

- (void)playFromFrame:(NSNumber *)fromFrame toFrame:(NSNumber *)toFrame completion:(KrollCallback *)callback {
  [[self animationView] playFromFrame:fromFrame
                              toFrame:toFrame
                       withCompletion:^(BOOL animationFinished) {
                         [self processCompleteEventWith:callback animationFinished:animationFinished];
                       }];
}

// TODO: Expose to module in next major, because we need to break the 3 parameters into a dictionary to be more flexible
- (void)playFromProgress:(NSNumber *)fromProgress toProgress:(NSNumber *)toProgress completion:(KrollCallback *)callback {
  [[self animationView] playFromProgress:fromProgress.floatValue
                              toProgress:toProgress.floatValue
                          withCompletion:^(BOOL animationFinished) {
                            [self processCompleteEventWith:callback animationFinished:animationFinished];
                          }];
}

- (void)pause {
  [[self animationView] pause];
}

- (void)stop {
  [[self animationView] stop];
}

- (void)addView:(UIView *)view toKeypathLayer:(NSString *)layer {
  [[self animationView] addSubview:view toKeypathLayer:[LOTKeypath keypathWithString:layer]];
}

- (BOOL)isPlaying {
  return [[self animationView] isAnimationPlaying];
}

- (CGFloat)duration {
  return [[self animationView] animationDuration];
}

- (CGFloat)progress {
  return [[self animationView] animationProgress];
}

- (CGFloat)speed {
  return [[self animationView] animationSpeed];
}

- (BOOL)loop {
  return [[self animationView] loopAnimation];
}

- (void)setProgress:(CGFloat)progress {
  [[self animationView] setAnimationProgress:progress];
}

- (void)setSpeed:(CGFloat)speed {
  [[self animationView] setAnimationSpeed:speed];
}

- (void)setLoop:(BOOL)loop {
  [[self animationView] setLoopAnimation:loop];
}

- (void)setCacheEnabled:(BOOL)cacheEnabled {
  [[self animationView] setCacheEnable:cacheEnabled];
}

- (BOOL)cacheEnabled {
  return [[self animationView] cacheEnable];
}

- (void)processCompleteEventWith:(KrollCallback *)callback animationFinished:(BOOL)animationFinished {
  if ([[self proxy] _hasListeners:@"complete"]) {
    [[self proxy] fireEvent:@"complete" withObject:@{ @"animationFinished" : @(YES) }];
  }

  if (callback == nil) {
    return;
  }

  NSDictionary *propertiesDict = @{ @"finished" : @(animationFinished) };
  NSArray *invocationArray = [[NSArray alloc] initWithObjects:&propertiesDict count:1];

  [callback call:invocationArray thisObject:[self proxy]];
}

#pragma mark Layout utilities

#ifdef TI_USE_AUTOLAYOUT
- (void)initializeTiLayoutView {
  [super initializeTiLayoutView];
  [self setDefaultHeight:TiDimensionAutoFill];
  [self setDefaultWidth:TiDimensionAutoFill];
}
#endif

#pragma mark Layout helper

- (void)frameSizeChanged:(CGRect)frame bounds:(CGRect)bounds {
  for (UIView *child in [self subviews]) {
    [TiUtils setView:child positionRect:bounds];
  }

  [super frameSizeChanged:frame bounds:bounds];
}

@end
