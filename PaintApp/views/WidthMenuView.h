//
//  WidthMenuView.h
//  PaintApp
//
//  Created by Boris on 4/12/16.
//  Copyright © 2016 Boris. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WidthMenuViewDelegate;

@interface WidthMenuView : UIImageView

@property (nonatomic, assign) double thePotentialHeight;
@property (nonatomic, assign) double theBottomHeight;
@property (nonatomic, assign) double theBrushWidth;
@property (nonatomic, weak, nullable) id<WidthMenuViewDelegate> theDelegate;

- (void)methodAdjustCellViews;

@end

@protocol WidthMenuViewDelegate<NSObject>

@required

- (void)widthMenuViewDidSelectWidth:(WidthMenuView * _Nonnull)theWidthMenuView;

@end





























