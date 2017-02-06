/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2017 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiAnimationLottieViewProxy.h"
#import "TiAnimationLottieView.h"
#import "Lottie.h"
#import "TiUtils.h"

@implementation TiAnimationLottieViewProxy

- (LAAnimationView *)animationView
{
    if (animationView == nil) {
        id file = [self valueForKey:@"file"];
        id autoStart = [self valueForKey:@"autoStart"];

        ENSURE_TYPE(file, NSString);
        ENSURE_TYPE_OR_NIL(autoStart, NSNumber);
        
        // Handle both "file.json" and "file"
        if ([file hasSuffix:@".json"]) {
            file = [file stringByDeletingPathExtension];
        }
        
        animationView = [LAAnimationView animationNamed:file];
        [[self view] addSubview:animationView];
        
        // Handle auto-start
        if ([TiUtils boolValue:autoStart def:NO]) {
            [self start:nil];
        }
    }
    
    return animationView;
}

#pragma mark Public APIs

- (void)start:(id)args
{
    ENSURE_UI_THREAD(start, args);
    
    if ([args count] == 1) {
        KrollCallback *callback = nil;
        ENSURE_ARG_AT_INDEX(callback, args, 0, KrollCallback);
        
        [[self animationView] playWithCompletion:^(BOOL animationFinished) {
            NSDictionary *propertiesDict = @{@"finished": NUMBOOL(animationFinished)};
            NSArray *invocationArray = [[NSArray alloc] initWithObjects:&propertiesDict count:1];
            
            [callback call:invocationArray thisObject:self];
        }];
    } else {
        [[self animationView] play];
    }
}

- (void)stop:(id)unused
{
    ENSURE_UI_THREAD(stop, unused);
    [[self animationView] pause];
}

- (void)addViewToLayer:(id)args
{
    ENSURE_UI_THREAD(addViewToLayer, args);
    ENSURE_SINGLE_ARG(args, NSDictionary);
    
    id viewProxy = [args objectForKey:@"view"];
    id layerName = [args objectForKey:@"layer"];
    
    ENSURE_TYPE(viewProxy, TiViewProxy);
    ENSURE_TYPE(layerName, NSString);
    
    [self rememberProxy:viewProxy];
    
    [[self animationView] addSubview:[viewProxy view]
                        toLayerNamed:layerName];
}

- (void)setProgress:(id)progress
{
    ENSURE_UI_THREAD(setProgress, progress);
    ENSURE_TYPE(progress, NSNumber);
    
    [[self animationView] setAnimationProgress:[TiUtils floatValue:progress]];
    [self replaceValue:progress forKey:@"progress" notification:NO];
}

- (id)progress
{
    return NUMFLOAT([[self animationView] animationProgress]);
}

- (void)setSpeed:(id)speed
{
    ENSURE_UI_THREAD(setSpeed, speed);
    ENSURE_TYPE(speed, NSNumber);

    [[self animationView] setAnimationSpeed:[TiUtils floatValue:speed]];
    [self replaceValue:speed forKey:@"speed" notification:NO];
}

- (id)speed
{
    return NUMFLOAT([[self animationView] animationSpeed]);
}

- (void)setLoop:(id)loop
{
    ENSURE_UI_THREAD(setLoop, loop);
    ENSURE_TYPE(loop, NSNumber);
    
    [[self animationView] setLoopAnimation:[TiUtils boolValue:loop]];
    [self replaceValue:loop forKey:@"loop" notification:NO];
}

- (id)loop
{
    return NUMBOOL([[self animationView] loopAnimation]);
}

- (id)isPlaying:(id)unused
{
    return NUMBOOL([[self animationView] isAnimationPlaying]);
}

- (id)duration
{
    return NUMFLOAT([[self animationView] animationDuration]);
}

@end
