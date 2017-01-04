//
//  WidthMenuView.m
//  PaintApp
//
//  Created by Boris on 4/12/16.
//  Copyright © 2016 Boris. All rights reserved.
//

#import "WidthMenuView.h"

#import "BZExtensionsManager.h"

@interface WidthMenuView ()

@property (nonatomic, strong, nonnull) NSMutableArray<UIImageView *> *theViewMutableArray;
@property (nonatomic, strong, nonnull) NSArray<NSNumber *> *theWidthArray;
@property (nonatomic, assign) NSInteger theSelectedIndex;

@end

NSString * const keyDrawLeftRightInset = @"40 30 20 20";
NSInteger const keyNumberOfCellViews = 5;

@implementation WidthMenuView

#pragma mark - Class Methods (Public)

#pragma mark - Class Methods (Private)

#pragma mark - Init & Dealloc

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self methodInitWidthMenuView];
    }
    return self;
}

- (void)methodInitWidthMenuView
{
    self.backgroundColor = [UIColor yellowColor];
    self.userInteractionEnabled = YES;
    self.clipsToBounds = YES;
}

#pragma mark - Setters (Public)

- (void)setThePotentialHeight:(double)thePotentialHeight
{
    if (_thePotentialHeight == thePotentialHeight)
    {
        return;
    }
    BZAssert((BOOL)(thePotentialHeight > 0));
    _thePotentialHeight = thePotentialHeight;
    [self createAllViews];
    [self methodAdjustCellViews];
}

#pragma mark - Getters (Public)

#pragma mark - Setters (Private)

#pragma mark - Getters (Private)

#pragma mark - Lifecycle

#pragma mark - Create Views & Variables

- (void)createAllViews
{
    if (!self.isFirstLoad)
    {
        return;
    }
    self.theViewMutableArray = [NSMutableArray new];
    self.theWidthArray = [NSArray arrayWithObjects:[NSNumber numberWithDouble:2], [NSNumber numberWithDouble:4], [NSNumber numberWithDouble:6],
                          [NSNumber numberWithDouble:9], [NSNumber numberWithDouble:15], nil];
    self.theSelectedIndex = 0;
    self.theBrushWidth = self.theWidthArray[self.theSelectedIndex].doubleValue;
    for (int i = 0; i < keyNumberOfCellViews; i++)
    {
        UIImageView *theCellView = [UIImageView new];
        [self addSubview:theCellView];
        theCellView.contentMode = UIViewContentModeScaleAspectFill;
        theCellView.clipsToBounds = YES;
        [self.theViewMutableArray addObject:theCellView];
    }
}

#pragma mark - Actions

#pragma mark - Gestures

- (void)handleTapGesture:(UITapGestureRecognizer *)theTapGestureRecognizer
{
    UIImageView *theImageView = (UIImageView *)[(UIGestureRecognizer *)theTapGestureRecognizer view];
    BZAssert(theImageView);
    NSInteger theIndex = [self.theViewMutableArray indexOfObject:theImageView];
    self.theSelectedIndex = theIndex;
    [self methodAdjustCellViews];
    self.theBrushWidth = self.theWidthArray[theIndex].doubleValue;
    BZAssert((BOOL)(theIndex != NSNotFound));
    if ([self.theDelegate respondsToSelector:@selector(widthMenuViewDidSelectWidth:)])
    {
        [self.theDelegate widthMenuViewDidSelectWidth:self];
    }
}

#pragma mark - Notifications

#pragma mark - Delegates ()

#pragma mark - Methods (Public)

#pragma mark - Methods (Private)

- (void)methodAdjustCellViews
{
    for (int i = 0; i < keyNumberOfCellViews; i++)
    {
        UIImageView *theCellImageView = self.theViewMutableArray[i];
        theCellImageView.theWidth = self.theWidth;
        theCellImageView.theHeight = (self.thePotentialHeight - self.theBottomHeight) / keyNumberOfCellViews;
        theCellImageView.theMinY = theCellImageView.theHeight * i;
        if (i == self.theSelectedIndex)
        {
            theCellImageView.image = [UIImage getImageFromColor:[UIColor greenColor]];
        }
        else
        {
            theCellImageView.image = [UIImage getImageFromColor:[UIColor yellowColor]];
        }
        theCellImageView.userInteractionEnabled = YES;
        
        UIGraphicsBeginImageContextWithOptions(theCellImageView.frame.size, YES, 0.0);
        [theCellImageView.image drawInRect:CGRectMake(0, 0, theCellImageView.theWidth, theCellImageView.theHeight)];
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), keyDrawLeftRightInset.theDeviceValue, theCellImageView.theHeight * 0.5);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), theCellImageView.theWidth - keyDrawLeftRightInset.theDeviceValue, theCellImageView.theHeight * 0.5);
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapSquare);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.theWidthArray[i].doubleValue);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0, 0, 0, 1.0);
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeNormal);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        
        UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
        theCellImageView.image = theImage;
        UIGraphicsEndImageContext();
        if (i != keyNumberOfCellViews - 1)
        {
            theCellImageView.theBottomSeparatorView.backgroundColor = [UIColor orangeColor];
            theCellImageView.theBottomSeparatorView.theHeight = 2;
        }
        UITapGestureRecognizer *theTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [theCellImageView addGestureRecognizer:theTapGesture];
    }
}

#pragma mark - Standard Methods

@end






























