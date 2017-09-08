//
//  LOTGradientFillRender.h
//  Lottie
//
//  Created by brandon_withrow on 7/27/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import "LOTRenderNode.h"
#import "LOTShapeGradientFill.h"

@interface LOTGradientFillRender : LOTRenderNode

- (instancetype _Nonnull )initWithInputNode:(LOTAnimatorNode *_Nonnull)inputNode
                          shapeGradientFill:(LOTShapeGradientFill *_Nonnull)fill;

@end
