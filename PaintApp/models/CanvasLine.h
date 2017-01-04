//
//  BZLine.h
//  PaintApp
//
//  Created by Boris on 4/8/16.
//  Copyright © 2016 Boris. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CanvasView.h"

@interface CanvasLine : NSObject

@property (nonatomic, assign) double theWidth;
@property (nonatomic, strong, nonnull) UIColor *theLineColor;
@property (nonatomic, assign) float theAlpha;
@property (nonatomic, assign) CanvasViewDrawType theCanwasViewDrawType;
@property (nonatomic, assign, nonnull) CGMutablePathRef theLinePath;

- (instancetype _Nonnull)initWithWidth:(double)theLineWidth color:(UIColor * _Nonnull)theLineColor alpha:(double)theAlpha;

@end






























