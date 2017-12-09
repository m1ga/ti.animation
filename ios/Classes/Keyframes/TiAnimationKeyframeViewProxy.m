/**
 * Ti.Keyframes
 * Copyright (c) 2017-present by Hans Knöchel. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiAnimationKeyframeViewProxy.h"
#import "TiAnimationKeyframeView.h"
#import "TiUtils.h"
#import "KFVectorLayer.h"

@implementation TiAnimationKeyframeViewProxy

- (KFVectorLayer *)vectorLayer
{
  return [(TiAnimationKeyframeView *)[self view] vectorLayer];
}

- (void)start:(id)unused
{
  ENSURE_UI_THREAD(start, unused);
  [[self vectorLayer] startAnimation];
}

- (void)pause:(id)unused
{
  ENSURE_UI_THREAD(pause, unused);
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
