//
//  BZLine.m
//  PaintApp
//
//  Created by Boris on 4/8/16.
//  Copyright © 2016 Boris. All rights reserved.
//

#import "CanvasLine.h"

#import "BZExtensionsManager.h"

@implementation CanvasLine

#pragma mark - Class Methods (Public)

#pragma mark - Class Methods (Private)

#pragma mark - Init & Dealloc

- (instancetype _Nonnull)init
{
    self = [super init];
    if (self)
    {
        [self methodInitCanvasLine];
    }
    return self;
}

- (instancetype _Nonnull)initWithWidth:(double)theLineWidth color:(UIColor * _Nonnull)theLineColor alpha:(double)theAlpha;
{
    self = [super init];
    if (self)
    {
        [self
         methodInitBZLineWithWidth:theLineWidth color:theLineColor alpha:theAlpha];
    }
    return self;
}

- (void)methodInitBZLineWithWidth:(double)theLineWidth color:(UIColor * _Nonnull)theLineColor alpha:(double)theAlpha;
{
    BZAssert(theLineColor);
    BZAssert((BOOL)(theAlpha >= 0 && theAlpha <= 1 && theLineWidth >= 0));
    _theWidth = theLineWidth;
    _theLineColor = theLineColor;
    _theAlpha = theAlpha;
    _theLinePath = CGPathCreateMutable();
}

- (void)methodInitCanvasLine
{
    _theLinePath = CGPathCreateMutable();
    _theAlpha = 1;
    _theLineColor = [UIColor blackColor];
    _theWidth = 5;
}

#pragma mark - Setters (Public)

#pragma mark - Getters (Public)

#pragma mark - Setters (Private)

#pragma mark - Getters (Private)

#pragma mark - Lifecycle

#pragma mark - Create Views & Variables

#pragma mark - Actions

#pragma mark - Gestures

#pragma mark - Notifications

#pragma mark - Delegates ()

#pragma mark - Methods (Public)

#pragma mark - Methods (Private)

#pragma mark - Standard Methods

@end






























