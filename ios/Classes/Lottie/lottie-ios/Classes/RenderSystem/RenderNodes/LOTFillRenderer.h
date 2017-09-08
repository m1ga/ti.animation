//
//  LOTFillRenderer.h
//  Lottie
//
//  Created by brandon_withrow on 6/27/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import "LOTRenderNode.h"
#import "LOTShapeFill.h"

@interface LOTFillRenderer : LOTRenderNode

- (instancetype _Nonnull )initWithInputNode:(LOTAnimatorNode *_Nonnull)inputNode
                                  shapeFill:(LOTShapeFill *_Nonnull)fill;

@end
