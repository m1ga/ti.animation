/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2017 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiAnimationLottieView.h"
#import "TiAnimationLottieViewProxy.h"
#import "Lottie.h"

@implementation TiAnimationLottieView

#pragma mark Internals

- (LOTAnimationView* )animationView
{
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
        
        // Handle content mode
        NSArray *validContentModes = @[NUMINT(UIViewContentModeScaleAspectFit), NUMINT(UIViewContentModeScaleAspectFill), NUMINT(UIViewContentModeScaleToFill)];
        
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
        [self log:@"AnimationView initialized." forLevel:@"trace"];
        
        if ([TiUtils boolValue:autoStart def:NO]) {
            [self log:@"Autoplaying animation.." forLevel:@"trace"];
            
            [[self animationView] play];
        }
    }
    
    return _animationView;
}

- (NSDictionary*)loadAnimationFromJSON:(NSString*)file
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[[self proxy] valueForKey:@"file"] ofType:nil inDirectory:nil];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *jsonAnimation = [[NSDictionary alloc] init];
    
    if (!data) {
        [self log:[NSString stringWithFormat:@"The specified file %@ could not be loaded.", file] forLevel:@"error"];
    } else
        jsonAnimation = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    return jsonAnimation;
}

- (void)log:(NSString*)string forLevel:(NSString*)level
{
    NSLog(@"[%@] %@: %@", [level uppercaseString], NSStringFromClass([self class]), string);
}

#pragma mark Public APIs

- (void)play
{
    [[self animationView] play];
}

- (void)playWithCompletionHandler:(KrollCallback*)callback
{
    [[self animationView] playWithCompletion:^(BOOL animationFinished) {
        NSDictionary *propertiesDict = @{@"finished": NUMBOOL(animationFinished)};
        NSArray *invocationArray = [[NSArray alloc] initWithObjects:&propertiesDict count:1];
        
        [callback call:invocationArray thisObject:[self proxy]];
    }];

}

- (void)pause
{
    [[self animationView] pause];
}

- (void)addView:(TiUIView *)view toLayer:(NSString *)layer {
    [[self animationView] addSubview:view
                        toLayerNamed:layer];
}

- (BOOL)isPlaying
{
    return [[self animationView] isAnimationPlaying];
}

- (CGFloat)getDuration
{
    return [[self animationView] animationDuration];
}

- (CGFloat)getProgress
{
    return [[self animationView] animationProgress];
}

- (CGFloat)getSpeed
{
    return [[self animationView] animationSpeed];
}

- (BOOL)getLoop
{
    return [[self animationView] loopAnimation];
}

- (void)setProgress:(CGFloat)progress
{
    [[self animationView] setAnimationProgress:progress];
}

- (void)setSpeed:(CGFloat)speed
{
    [[self animationView] setAnimationSpeed:speed];
}

- (void)setLoop:(BOOL)loop
{
    [[self animationView] setLoopAnimation:loop];
}

#pragma mark Layout utilities

#ifdef TI_USE_AUTOLAYOUT
- (void)initializeTiLayoutView
{
    [super initializeTiLayoutView];
    [self setDefaultHeight:TiDimensionAutoFill];
    [self setDefaultWidth:TiDimensionAutoFill];
}
#endif

#pragma mark Layout helper

- (void)frameSizeChanged:(CGRect)frame bounds:(CGRect)bounds
{
    for (UIView *child in [self subviews]) {
        [TiUtils setView:child positionRect:bounds];
    }
    
    [super frameSizeChanged:frame bounds:bounds];
}

@end
