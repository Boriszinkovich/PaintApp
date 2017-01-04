//
//  CanvasView.h
//  PaintApp
//
//  Created by Boris on 4/8/16.
//  Copyright © 2016 Boris. All rights reserved.
//

#import <UIKit/UIKit.h>

#define keyRedoUndoChangedNotification @"keyRedoUndoChangedNotification"

typedef enum : NSUInteger
{
    CanvasViewDrawTypeWidth = 1,
    CanvasViewDrawTypeErase,
    CanvasViewDrawTypeEnumCount = CanvasViewDrawTypeErase
} CanvasViewDrawType;

@interface CanvasView : UIImageView

@property (nonatomic, assign) double theRedComponent;
@property (nonatomic, assign) double theGreenComponent;
@property (nonatomic, assign) double theBlueComponent;
@property (nonatomic, assign) double theAlphaValue;
@property (nonatomic, assign) double theBrushValue;
@property (nonatomic, assign) CanvasViewDrawType theCanvasViewDrawType;
@property (nonatomic, strong, nonnull) UIImage *theBackgroundImage;

- (void)methodClearImage;
- (void)methodUndo;
- (void)methodRedo;
- (BOOL)hasRedo;
- (BOOL)hasUndo;

@end






























