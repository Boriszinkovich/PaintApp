//
//  CanvasView.m
//  PaintApp
//
//  Created by Boris on 4/8/16.
//  Copyright © 2016 Boris. All rights reserved.
//

#import "CanvasView.h"

#import "BZExtensionsManager.h"
#import "CanvasLine.h"

@interface CanvasView () <UIImagePickerControllerDelegate>

@property (nonatomic, assign) BOOL isMouseSwiped;
@property (nonatomic, assign) CGPoint theLastPoint;
@property (nonatomic, strong, nullable) UIImageView *theTemporaryDrawingImageView;
@property (nonatomic, strong, nullable) UIImageView *theMainDrawingImageView;
@property (nonatomic, strong, nonnull) NSMutableArray *theUndoLinesArray;
@property (nonatomic, strong, nonnull) NSMutableArray *theRedoLinesArray;
@property (nonatomic, strong, nullable) CanvasLine *theCurrentLine;
@property (nonatomic, assign) BOOL isDrawingForward;
@property (nonatomic, strong, nullable) UIImage *theUndoLastImage;

@end

@implementation CanvasView

#pragma mark - Class Methods (Public)

#pragma mark - Class Methods (Private)

#pragma mark - Init & Dealloc

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self methodInitCanwasView];
    }
    return self;
}

- (void)methodInitCanwasView
{
}

#pragma mark - Setters (Public)

- (void)setTheAlphaValue:(double)theAlphaValue
{
    if (_theAlphaValue == theAlphaValue)
    {
        return;
    }
    BZAssert((BOOL)((theAlphaValue >= 0) || (theAlphaValue <= 1)));
    _theAlphaValue = theAlphaValue;
    [self createAllViews];
    [self methodAdjustImageViews];
    if (self.theCanvasViewDrawType == CanvasViewDrawTypeWidth)
    {
        self.theAlphaValue = theAlphaValue;
    }
}

- (void)setTheGreenComponent:(double)theGreenComponent
{
    if (_theGreenComponent ==  theGreenComponent)
    {
        return;
    }
    BZAssert((BOOL)(theGreenComponent >= 0 && theGreenComponent <= 1));
    _theGreenComponent = theGreenComponent;
    [self createAllViews];
    [self methodAdjustImageViews];
}

- (void)setTheRedComponent:(double)theRedComponent
{
    if (_theRedComponent == theRedComponent)
    {
        return;
    }
    BZAssert((BOOL)(theRedComponent >= 0 && theRedComponent <= 1));
    _theRedComponent = theRedComponent;
    [self createAllViews];
    [self methodAdjustImageViews];
}

- (void)setTheBlueComponent:(double)theBlueComponent
{
    if (_theBlueComponent == theBlueComponent)
    {
        return;
    }
    BZAssert((BOOL)(theBlueComponent >= 0 && theBlueComponent <= 1));
    _theBlueComponent = theBlueComponent;
    [self createAllViews];
    [self methodAdjustImageViews];
}

- (void)setTheHeight:(double)theHeight
{
    theHeight = (NSInteger)theHeight;
    [super setTheHeight:theHeight];
}

- (void)setTheWidth:(double)theWidth
{
    theWidth = (NSInteger)theWidth;
    [super setTheWidth:theWidth];
}

- (void)setTheCanvasViewDrawType:(CanvasViewDrawType)theCanvasViewDrawType
{
    if (_theCanvasViewDrawType == theCanvasViewDrawType)
    {
        return;
    }
    BZAssert(theCanvasViewDrawType > 0 && theCanvasViewDrawType <= CanvasViewDrawTypeEnumCount);
    _theCanvasViewDrawType = theCanvasViewDrawType;
}

- (void)setTheBackgroundImage:(UIImage * _Nonnull)theBackgroundImage
{
    BZAssert(theBackgroundImage);
    self.image = theBackgroundImage;
}

#pragma mark - Getters (Public)

- (UIImage * _Nonnull)theBackgroundImage
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    
    [self.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self.theMainDrawingImageView.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    UIImage *theOutputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theOutputImage;
}

#pragma mark - Setters (Private)

#pragma mark - Getters (Private)

#pragma mark - Lifecycle

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    CanvasLine *theNextLine = [[CanvasLine alloc] initWithWidth:self.theBrushValue
                                                          color:[UIColor colorWithRed:self.theRedComponent green:self.theGreenComponent blue:self.theBlueComponent alpha:1]
                                                          alpha:self.theAlphaValue];
    theNextLine.theCanwasViewDrawType = self.theCanvasViewDrawType;
    self.theCurrentLine = theNextLine;

    self.isMouseSwiped = NO;
    UITouch *theTouch = [touches anyObject];
    self.theLastPoint = [theTouch locationInView:self.theTemporaryDrawingImageView];
    CGPathMoveToPoint(self.theCurrentLine.theLinePath, NULL, self.theLastPoint.x, self.theLastPoint.y);
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    self.isMouseSwiped = YES;
    UITouch *theTouch = [touches anyObject];
    CGPoint theCurrentPoint = [theTouch locationInView:self];
    
    UIGraphicsBeginImageContext(self.theTemporaryDrawingImageView.frame.size);
    if (self.theCanvasViewDrawType == CanvasViewDrawTypeErase)
    {
        [self.theMainDrawingImageView.image drawInRect:CGRectMake(0, 0, self.theMainDrawingImageView.theWidth, self.theMainDrawingImageView.theHeight)];
    }
    else
    {
        [self.theTemporaryDrawingImageView.image drawInRect:CGRectMake(0, 0, self.theTemporaryDrawingImageView.theWidth, self.theTemporaryDrawingImageView.theHeight)];
    }
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), self.theLastPoint.x, self.theLastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), theCurrentPoint.x, theCurrentPoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.theBrushValue);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), self.theRedComponent, self.theGreenComponent, self.theBlueComponent, 1.0);
    if (self.theCanvasViewDrawType == CanvasViewDrawTypeErase)
    {
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
    }
    else
    {
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeNormal);
    }
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    if (self.theCanvasViewDrawType == CanvasViewDrawTypeErase)
    {
        self.theMainDrawingImageView.image = theImage;
    }
    else
    {
        self.theTemporaryDrawingImageView.image = theImage;
        [self.theTemporaryDrawingImageView setAlpha:self.theAlphaValue];
    }
    UIGraphicsEndImageContext();
    self.theLastPoint = theCurrentPoint;
    CGPathAddLineToPoint(self.theCurrentLine.theLinePath, NULL, theCurrentPoint.x, theCurrentPoint.y);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    if(!self.isMouseSwiped)
    {
        UIGraphicsBeginImageContext(self.frame.size);
        [self.theTemporaryDrawingImageView.image drawInRect:CGRectMake(0, 0, self.theWidth, self.theHeight)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.theBrushValue);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), self.theRedComponent, self.theGreenComponent, self.theBlueComponent, self.theAlphaValue);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), self.theLastPoint.x, self.theLastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), self.theLastPoint.x, self.theLastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        if (self.theCanvasViewDrawType)
        {
            CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
        }
        CGContextFlush(UIGraphicsGetCurrentContext());
        self.theTemporaryDrawingImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        CGPathAddLineToPoint(self.theCurrentLine.theLinePath, NULL, self.theLastPoint.x, self.theLastPoint.y);
    }
    UIGraphicsBeginImageContext(self.theMainDrawingImageView.frame.size);
    [self.theMainDrawingImageView.image drawInRect:CGRectMake(0, 0, self.theWidth, self.theHeight)
                                         blendMode:kCGBlendModeNormal
                                             alpha:1.0];
    if (!self.isDrawingForward)
    {
        self.theRedoLinesArray = [NSMutableArray new];
    }
    CGBlendMode theBlendMode;
    if (self.theCanvasViewDrawType == CanvasViewDrawTypeErase)
    {
        theBlendMode = kCGBlendModeClear;
    }
    else
    {
        theBlendMode = kCGBlendModeNormal;
    }
    [self.theTemporaryDrawingImageView.image drawInRect:CGRectMake(0, 0, self.theWidth, self.theHeight)
                                              blendMode:kCGBlendModeNormal
                                                  alpha:self.theAlphaValue];
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    self.theMainDrawingImageView.image = theImage;
    self.theTemporaryDrawingImageView.image = nil;
    UIGraphicsEndImageContext();
    
    self.isDrawingForward = YES;
    [self.theUndoLinesArray addObject:self.theCurrentLine];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:keyRedoUndoChangedNotification
     object:self];
}

#pragma mark - Create Views & Variables

- (void)createAllViews
{
    if (!self.isFirstLoad)
    {
        return;
    }
    self.isFirstLoad = NO;
    _theUndoLinesArray = [NSMutableArray new];
    _theRedoLinesArray = [NSMutableArray new];
    
    UIImageView *theMainDrawingImageView= [UIImageView new];
    self.theMainDrawingImageView = theMainDrawingImageView;
    [self addSubview:theMainDrawingImageView];

    UIImageView *theTemporaryDrawingImageView = [UIImageView new];
    self.theTemporaryDrawingImageView = theTemporaryDrawingImageView;
    [self addSubview:theTemporaryDrawingImageView];
}

#pragma mark - Actions

#pragma mark - Gestures

#pragma mark - Notifications

#pragma mark - Delegates ()

#pragma mark - Methods (Public)

- (void)methodClearImage;
{
    self.theMainDrawingImageView.image = nil;
    self.theRedoLinesArray = [NSMutableArray new];
    self.theUndoLinesArray = [NSMutableArray new];
    self.theUndoLastImage = nil;
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"keyRedoUndoChangedNotification"
     object:self];
}

- (BOOL)hasRedo
{
    return self.theRedoLinesArray.count;
}

- (BOOL)hasUndo
{
    return self.theUndoLinesArray.count;
}

#pragma mark - Methods (Private)

- (void)methodUndo
{
    if (self.isDrawingForward)
    {
        self.theRedoLinesArray = [NSMutableArray new];
    }
    self.isDrawingForward = NO;
    if (self.theUndoLinesArray.count > 0)
    {
        self.theMainDrawingImageView.image = self.theUndoLastImage;
        [self.theRedoLinesArray addObject:self.theUndoLinesArray.lastObject];
        [self.theUndoLinesArray removeLastObject];
        for (int i = 0; i < self.theUndoLinesArray.count; i++)
        {
            CanvasLine *theTempLine = self.theUndoLinesArray[i];
            UIGraphicsBeginImageContext(self.frame.size);
            [self.theMainDrawingImageView.image drawInRect:CGRectMake(0, 0, self.theWidth, self.theHeight)
                                                 blendMode:kCGBlendModeNormal alpha:1];
            CGContextRef theContext = UIGraphicsGetCurrentContext();
            CGContextSetAlpha(theContext, theTempLine.theAlpha);
            CGContextSetStrokeColorWithColor(theContext, theTempLine.theLineColor.CGColor);
            CGContextSetLineWidth(theContext, theTempLine.theWidth);
            CGContextSetLineCap(theContext, kCGLineCapRound);
            CGContextAddPath(theContext, theTempLine.theLinePath);
            if (theTempLine.theCanwasViewDrawType == CanvasViewDrawTypeErase)
            {
                CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
            }
            else
            {
                CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeNormal);
            }
            CGContextStrokePath(theContext);
            CGContextFlush(UIGraphicsGetCurrentContext());
            
            UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
            self.theMainDrawingImageView.image = theImage;
            CGContextRelease(theContext);
            UIGraphicsEndImageContext();
        }
    }
}

- (void)methodRedo
{
    if (self.theRedoLinesArray.count > 0)
    {
        [self.theUndoLinesArray addObject:self.theRedoLinesArray.lastObject];
        CanvasLine *theTempLine = self.theRedoLinesArray.lastObject;
        UIGraphicsBeginImageContext(self.frame.size);
        [self.theMainDrawingImageView.image drawInRect:CGRectMake(0, 0, self.theWidth, self.theHeight) blendMode:kCGBlendModeNormal alpha:1];
        CGContextRef theContext = UIGraphicsGetCurrentContext();
        CGContextSetAlpha(theContext, theTempLine.theAlpha);
        CGContextSetStrokeColorWithColor(theContext, theTempLine.theLineColor.CGColor);
        CGContextSetLineWidth(theContext, theTempLine.theWidth);
        CGContextSetLineCap(theContext, kCGLineCapRound);
        CGContextSetLineJoin(theContext, kCGLineJoinRound);
        CGContextAddPath(theContext, theTempLine.theLinePath);
        if (theTempLine.theCanwasViewDrawType == CanvasViewDrawTypeErase)
        {
            CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
        }
        else
        {
            CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeNormal);
        }
        CGContextStrokePath(theContext);
        
        UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
        self.theMainDrawingImageView.image = theImage;
        CGContextRelease(theContext);
        UIGraphicsEndImageContext();
        [self.theRedoLinesArray removeLastObject];
    }
}

- (void)methodAdjustImageViews
{
    self.theTemporaryDrawingImageView.theWidth = (NSInteger)self.theWidth;
    self.theTemporaryDrawingImageView.theHeight = (NSInteger)self.theHeight;
    self.theMainDrawingImageView.theWidth = (NSInteger)self.theWidth;
    self.theMainDrawingImageView.theHeight = (NSInteger)self.theHeight;
}

#pragma mark - Standard Methods

@end






























