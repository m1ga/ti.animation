/**
 * Ti.Keyframes
 * Copyright (c) 2017-present by Hans Knöchel. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiAnimationKeyframeView.h"
#import "TiAnimationKeyframeViewProxy.h"
#import "KFVectorParsingHelper.h"

@implementation TiAnimationKeyframeView

- (KFVector *)vector
{
  static KFVector *_sampleVector;
  static dispatch_once_t onceToken;
  
  if (![[self proxy] valueForKey:@"file"]) {
    [self throwException:@"The file was null"
               subreason:@"The specified JSON file was null, please define it by setting the 'file' key."
                location:CODELOCATION];
  }
  
  dispatch_once(&onceToken, ^{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[[self proxy] valueForKey:@"file"] ofType:nil inDirectory:nil];
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
  if (_vectorLayer == nil) {
    KFVector *sampleVector = [self vector];
    
    _vectorLayer = [[KFVectorLayer alloc] init];
    
    const CGFloat shortSide = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    const CGFloat longSide = MAX(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    _vectorLayer.frame = CGRectMake(shortSide / 4, longSide / 2 - shortSide / 4, shortSide / 2, shortSide / 2);
    _vectorLayer.faceModel = sampleVector;
    
    TiThreadPerformOnMainThread(^{
      [[self layer] addSublayer:_vectorLayer];
    },
                                NO);
    
    // Handle auto-start
    if ([TiUtils boolValue:[[self proxy] valueForKey:@"autoStart"] def:NO]) {
      [(TiAnimationKeyframeViewProxy *)[self proxy] start:nil];
    }
  }
  
  return _vectorLayer;
}

@end
