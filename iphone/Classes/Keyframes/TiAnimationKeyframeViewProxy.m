/**
 * Ti.Keyframes
 * Copyright (c) 2016 by Hans Knöchel, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiAnimationKeyframeViewProxy.h"
#import "TiUtils.h"
#import "TiAnimationKeyframeView.h"

@implementation TiAnimationKeyframeViewProxy

- (KFVector *)loadSampleVectorFromDisk
{
    static KFVector *_sampleVector;
    static dispatch_once_t onceToken;
    
    if (![self valueForKey:@"file"]) {
        [self throwException:@"The file was null"
                   subreason:@"The specified JSON file was null, please define it by setting the 'file' key."
                    location:CODELOCATION];
    }
    
    dispatch_once(&onceToken, ^{
        NSString *filePath = [[NSBundle mainBundle] pathForResource:[self valueForKey:@"file"] ofType:@"json" inDirectory:nil];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        
        if (!data) {
            NSLog(@"[ERROR] The specified file %@ could not be located. Please ensure to only provice the name of the JSON-file, without the extension.");
        }
        
        NSDictionary *sampleVectorDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        _sampleVector = KFVectorFromDictionary(sampleVectorDictionary);
    });
    
    return _sampleVector;
}

- (KFVectorLayer *)vectorLayer
{
    if (vectorLayer == nil) {
        KFVector *sampleVector = [self loadSampleVectorFromDisk];
        
        vectorLayer = [KFVectorLayer new];
        
        const CGFloat shortSide = MIN(CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
        const CGFloat longSide = MAX(CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
        vectorLayer.frame = CGRectMake(shortSide / 4, longSide / 2 - shortSide / 4, shortSide / 2, shortSide / 2);
        vectorLayer.faceModel = sampleVector;
        
        TiThreadPerformOnMainThread(^{
            [[(TiAnimationKeyframeView *)[self view] layer] addSublayer:vectorLayer];
        }, NO);
        
        // Handle auto-start
        if ([TiUtils boolValue:[self valueForKey:@"autoStart"] def:NO]) {
            [self start:nil];
        }
    }
}

- (void)start:(id)unused
{
    ENSURE_UI_THREAD(start, unused);
    [[self vectorLayer] startAnimation];
}

- (void)stop:(id)unused
{
    ENSURE_UI_THREAD(stop, unused);
    [[self vectorLayer] pauseAnimation];
}

- (void)resume:(id)unused
{
    ENSURE_UI_THREAD(resume, unused);
    [[self vectorLayer] resumeAnimation];
}

- (void)seekToProgress:(id)value
{
    ENSURE_SINGLE_ARG(value, NSNumber);
    ENSURE_UI_THREAD(seekToProgress, value);
    
    [[self vectorLayer] seekToProgress:[TiUtils floatValue:value]];
}

@end
