//
//  MainViewController.m
//  PaintApp
//
//  Created by Boris on 4/8/16.
//  Copyright © 2016 Boris. All rights reserved.
//

#import "MainViewController.h"

#import "BZExtensionsManager.h"
#import "CanvasView.h"
#import "WidthMenuView.h"

@interface MainViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, WidthMenuViewDelegate>

@property (nonatomic, strong, nonnull) CanvasView *theMainCanvasView;
@property (nonatomic, strong, nonnull) UIButton *theUndoButton;
@property (nonatomic, strong, nonnull) UIButton *theRedoButton;
@property (nonatomic, strong, nonnull) UIButton *theWidthButton;
@property (nonatomic, strong, nonnull) WidthMenuView *theWidthMenuView;

@end

NSString * const keyNavigationViewHeight = @"65 60 55 55";
NSString * const keyLeftRightControlInset = @"15 12 10 10";
NSString * const keyButtonsWidth = @"94 90 84 84";
NSString * const keyButtonsHeight = @"45 40 35 35";
NSString * const keyTopButtomScreenInset = @"18 15 12 12";
NSString * const keyClearButtonWidth_Height = @"42 40 38 38";
NSString * const keySlidersHeight = @"44 38 36 34";
NSString * const keyUndoRedoWidth_Height = @"42 40 38 38";
NSString * const keyUndoRedoXInsets = @"20 18 16 16";
double const keyAlphaNotChosedValue = 0.3;
NSInteger const keyRGBMaxValue = 255;

@implementation MainViewController

#pragma mark - Class Methods (Public)

#pragma mark - Class Methods (Private)

#pragma mark - Init & Dealloc

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Setters (Public)

#pragma mark - Getters (Public)

#pragma mark - Setters (Private)

#pragma mark - Getters (Private)

#pragma mark - Lifecycle

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isFirstLoad)
    {
        [self createAllViews];
    }
}

#pragma mark - Create Views & Variables

- (void)createAllViews
{
    if (!self.isFirstLoad)
    {
        return;
    }
    self.isFirstLoad = NO;
    self.navigationController.navigationBar.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveUndoRedoChangedNotification:)
                                                 name:keyRedoUndoChangedNotification
                                               object:nil];
    
    UIView *theNavigationView = [UIView new];
    [self.view addSubview:theNavigationView];
    theNavigationView.theHeight = keyNavigationViewHeight.theDeviceValue;
    theNavigationView.theWidth = theNavigationView.superview.theWidth;
    
    UISlider *theAlphaSlider = [UISlider new];
    [self.view addSubview:theAlphaSlider];
    theAlphaSlider.theMinX = keyLeftRightControlInset.theDeviceValue;
    theAlphaSlider.theWidth = theAlphaSlider.superview.theWidth - 2 * keyLeftRightControlInset.theDeviceValue;
    theAlphaSlider.theHeight = keySlidersHeight.theDeviceValue;
    theAlphaSlider.theMaxY = theAlphaSlider.superview.theHeight - keyTopButtomScreenInset.theDeviceValue - keyButtonsHeight.theDeviceValue - 5;
    theAlphaSlider.minimumTrackTintColor = [UIColor blackColor];
    theAlphaSlider.maximumTrackTintColor = [UIColor blackColor];
    theAlphaSlider.value = 1;
    [theAlphaSlider addTarget:self
                       action:@selector(actionTheAlphaSliderValueDidChange:)
             forControlEvents:UIControlEventValueChanged];
    
    double theCornerRadius = 10;
    
    UISlider *theBlueSlider = [UISlider new];
    [self.view addSubview:theBlueSlider];
    theBlueSlider.theMinX = keyLeftRightControlInset.theDeviceValue;
    theBlueSlider.theWidth = theBlueSlider.superview.theWidth - 2 * keyLeftRightControlInset.theDeviceValue;
    theBlueSlider.theHeight = keySlidersHeight.theDeviceValue;
    theBlueSlider.theMaxY = theAlphaSlider.theMinY;
    theBlueSlider.minimumTrackTintColor = [UIColor blueColor];
    theBlueSlider.maximumTrackTintColor = [UIColor blueColor];
    theBlueSlider.maximumValue = keyRGBMaxValue;
    theBlueSlider.value = 40;
    [theBlueSlider addTarget:self
                      action:@selector(actionTheBlueSliderValueDidChange:)
            forControlEvents:UIControlEventValueChanged];
    
    UISlider *theGreenSlider = [UISlider new];
    [self.view addSubview:theGreenSlider];
    theGreenSlider.theMinX = keyLeftRightControlInset.theDeviceValue;
    theGreenSlider.theWidth = theGreenSlider.superview.theWidth - 2 * keyLeftRightControlInset.theDeviceValue;
    theGreenSlider.theHeight = keySlidersHeight.theDeviceValue;
    theGreenSlider.theMaxY = theBlueSlider.theMinY;
    theGreenSlider.minimumTrackTintColor = [UIColor greenColor];
    theGreenSlider.maximumTrackTintColor = [UIColor greenColor];
    theGreenSlider.maximumValue = keyRGBMaxValue;
    theGreenSlider.value = 80;
    [theGreenSlider addTarget:self
                       action:@selector(actionTheGreenSliderValueDidChange:)
             forControlEvents:UIControlEventValueChanged];
    
    UISlider *theRedSlider = [UISlider new];
    [self.view addSubview:theRedSlider];
    theRedSlider.theMinX = keyLeftRightControlInset.theDeviceValue;
    theRedSlider.theWidth = theRedSlider.superview.theWidth - 2 * keyLeftRightControlInset.theDeviceValue;
    theRedSlider.theHeight = keySlidersHeight.theDeviceValue;
    theRedSlider.theMaxY = theGreenSlider.theMinY;
    theRedSlider.minimumTrackTintColor = [UIColor redColor];
    theRedSlider.maximumTrackTintColor = [UIColor redColor];
    theRedSlider.maximumValue = keyRGBMaxValue;
    theRedSlider.value = 120;
    [theRedSlider addTarget:self
                     action:@selector(actionTheRedSliderValueDidChange:)
           forControlEvents:UIControlEventValueChanged];
    
    UIButton *theChooseButton = [UIButton new];
    [self.view addSubview:theChooseButton];
    theChooseButton.theWidth = keyButtonsWidth.theDeviceValue;
    theChooseButton.theHeight = keyButtonsHeight.theDeviceValue;
    theChooseButton.theMinX = keyLeftRightControlInset.theDeviceValue;
    theChooseButton.theMinY = keyTopButtomScreenInset.theDeviceValue + [BZExtensionsManager methodGetStatusBarHeight];
    [theChooseButton setTitle:@"Choose" forState:UIControlStateNormal];
    theChooseButton.backgroundColor = [UIColor blueColor];
    [theChooseButton setTitleColor:[UIColor whiteColor]
                          forState:UIControlStateNormal];
    theChooseButton.layer.cornerRadius = theCornerRadius;
    [theChooseButton addTarget:self
                        action:@selector(actionChooseButtonDidTouchUpInside:)
              forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *theSaveButton = [UIButton new];
    [self.view addSubview:theSaveButton];
    theSaveButton.theWidth = keyButtonsWidth.theDeviceValue;
    theSaveButton.theHeight = keyButtonsHeight.theDeviceValue;
    theSaveButton.theMaxX = theSaveButton.superview.theWidth - keyLeftRightControlInset.theDeviceValue;
    theSaveButton.theMinY = keyTopButtomScreenInset.theDeviceValue + [BZExtensionsManager methodGetStatusBarHeight];
    [theSaveButton setTitle:@"Save" forState:UIControlStateNormal];
    theSaveButton.backgroundColor = [UIColor blueColor];
    [theSaveButton setTitleColor:[UIColor whiteColor]
                        forState:UIControlStateNormal];
    theSaveButton.layer.cornerRadius = theCornerRadius;
    [theSaveButton addTarget:self
                      action:@selector(actionSaveButtonDidTouchUpInside:)
            forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *theUndoButton = [UIButton new];
    self.theUndoButton = theUndoButton;
    [self.view addSubview:theUndoButton];
    [theUndoButton setImage:[[UIImage getImageNamed:@"undo_icon"]
                             getImageWithSize:CGSizeMake(keyUndoRedoWidth_Height.theDeviceValue, keyUndoRedoWidth_Height.theDeviceValue)]
                   forState:UIControlStateNormal];
    theUndoButton.theWidth = keyUndoRedoWidth_Height.theDeviceValue;
    theUndoButton.theHeight = keyUndoRedoWidth_Height.theDeviceValue;
    theUndoButton.theCenterY = theSaveButton.theCenterY;
    theUndoButton.theMinX = theChooseButton.theMaxX + keyUndoRedoXInsets.theDeviceValue;
    theUndoButton.backgroundColor = [UIColor greenColor];
    theUndoButton.layer.cornerRadius = keyUndoRedoWidth_Height.theDeviceValue / 2;
    [theUndoButton addTarget:self
                      action:@selector(actionUndoButtonDidTouchUpInside:)
            forControlEvents:UIControlEventTouchUpInside];
    theUndoButton.alpha = keyAlphaNotChosedValue;
    
    UIButton *theRedoButton = [UIButton new];
    self.theRedoButton = theRedoButton;
    [self.view addSubview:theRedoButton];
    [theRedoButton setImage:[[UIImage getImageNamed:@"redo_icon"]
                             getImageWithSize:CGSizeMake(keyUndoRedoWidth_Height.theDeviceValue, keyUndoRedoWidth_Height.theDeviceValue)]
                   forState:UIControlStateNormal];
    theRedoButton.theWidth = keyUndoRedoWidth_Height.theDeviceValue;
    theRedoButton.theHeight = keyUndoRedoWidth_Height.theDeviceValue;
    theRedoButton.theCenterY = theSaveButton.theCenterY;
    theRedoButton.theMaxX = theSaveButton.theMinX - keyUndoRedoXInsets.theDeviceValue;
    theRedoButton.backgroundColor = [UIColor greenColor];
    theRedoButton.layer.cornerRadius = keyUndoRedoWidth_Height.theDeviceValue / 2;
    [theRedoButton addTarget:self
                      action:@selector(actionRedoButtonDidTouchUpInside:)
            forControlEvents:UIControlEventTouchUpInside];
    theRedoButton.alpha = keyAlphaNotChosedValue;
    
    CanvasView *theCanvasView = [CanvasView new];
    self.theMainCanvasView = theCanvasView;
    [self.view addSubview:theCanvasView];
    theCanvasView.theMinX =  keyLeftRightControlInset.theDeviceValue;
    theCanvasView.theMinY = theSaveButton.theMaxY + 20;
    theCanvasView.theWidth = theCanvasView.superview.theWidth - 2 * keyLeftRightControlInset.theDeviceValue;
    theCanvasView.theHeight = theRedSlider.theMinY - theSaveButton.theMaxY - 40;
    theCanvasView.userInteractionEnabled = YES;
    theCanvasView.theAlphaValue = theAlphaSlider.value;
    theCanvasView.theRedComponent = theRedSlider.value / keyRGBMaxValue;
    theCanvasView.theBlueComponent = theBlueSlider.value / keyRGBMaxValue;
    theCanvasView.theGreenComponent = theGreenSlider.value / keyRGBMaxValue;
    theCanvasView.theBrushValue = 5;
    theCanvasView.theCanvasViewDrawType = CanvasViewDrawTypeWidth;
    theCanvasView.layer.borderColor = [UIColor redColor].CGColor;
    theCanvasView.layer.borderWidth = 2;
    
    WidthMenuView *theWidthMenuView = [WidthMenuView new];
    self.theWidthMenuView = theWidthMenuView;
    theWidthMenuView.theDelegate = self;
    [self.view addSubview:theWidthMenuView];
    theWidthMenuView.theWidth = keyButtonsWidth.theDeviceValue;
    theWidthMenuView.theHeight = 0;
    theWidthMenuView.theBottomHeight = keyButtonsHeight.theDeviceValue / 2;
    theWidthMenuView.thePotentialHeight = self.view.theHeight / 2;
    theWidthMenuView.theMaxY = theWidthMenuView.superview.theHeight - keyTopButtomScreenInset.theDeviceValue - keyButtonsHeight.theDeviceValue / 2;
    theWidthMenuView.theMinX = keyLeftRightControlInset.theDeviceValue;
    
    theWidthMenuView.layer.borderColor = [UIColor orangeColor].CGColor;
    theWidthMenuView.layer.borderWidth = 2;
    
    UIButton *theWidthButton = [UIButton new];
    self.theWidthButton = theWidthButton;
    [self.view addSubview:theWidthButton];
    theWidthButton.theWidth = keyButtonsWidth.theDeviceValue;
    theWidthButton.theHeight = keyButtonsHeight.theDeviceValue;
    theWidthButton.theMinX = keyLeftRightControlInset.theDeviceValue;
    theWidthButton.theMaxY = theWidthButton.superview.theHeight - keyTopButtomScreenInset.theDeviceValue;
    [theWidthButton setTitle:@"Width" forState:UIControlStateNormal];
    theWidthButton.backgroundColor = [UIColor blueColor];
    [theWidthButton setTitleColor:[UIColor whiteColor]
                         forState:UIControlStateNormal];
    theWidthButton.layer.cornerRadius = 10;
    [theWidthButton addTarget:self action:@selector(actionWidthButtonDidTouchUpInside:)
             forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *theEraseButton = [UIButton new];
    [self.view addSubview:theEraseButton];
    theEraseButton.theWidth = keyButtonsWidth.theDeviceValue;
    theEraseButton.theHeight = keyButtonsHeight.theDeviceValue;
    theEraseButton.theMaxX = theEraseButton.superview.theWidth - keyLeftRightControlInset.theDeviceValue;
    theEraseButton.theMaxY = theEraseButton.superview.theHeight - keyTopButtomScreenInset.theDeviceValue;
    [theEraseButton setTitle:@"Erase" forState:UIControlStateNormal];
    theEraseButton.backgroundColor = [UIColor blueColor];
    [theEraseButton setTitleColor:[UIColor whiteColor]
                         forState:UIControlStateNormal];
    theEraseButton.layer.cornerRadius = 10;
    [theEraseButton addTarget:self
                       action:@selector(actionEraseButtonDidTouchUpInside:)
             forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *theClearButton = [UIButton new];
    [self.view addSubview:theClearButton];
    [theClearButton setImage:[UIImage getImageNamed:@"clear_icon"]
                    forState:UIControlStateNormal];
    theClearButton.theWidth = keyClearButtonWidth_Height.theDeviceValue;
    theClearButton.theHeight = keyClearButtonWidth_Height.theDeviceValue;
    theClearButton.backgroundColor = [UIColor redColor];
    theClearButton.theMaxY = theClearButton.superview.theHeight - keyTopButtomScreenInset.theDeviceValue;
    theClearButton.theCenterX = theClearButton.superview.theWidth / 2;
    theClearButton.layer.cornerRadius = keyClearButtonWidth_Height.theDeviceValue / 2;
    [theClearButton addTarget:self
                       action:@selector(actionClearButtonDidTouchUpInside:)
             forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Actions

- (void)actionTheAlphaSliderValueDidChange:(UISlider *)theSlider
{
    self.theMainCanvasView.theAlphaValue = theSlider.value;
}

- (void)actionTheBlueSliderValueDidChange:(UISlider *)theSlider
{
    self.theMainCanvasView.theBlueComponent = theSlider.value / keyRGBMaxValue;
}

- (void)actionTheRedSliderValueDidChange:(UISlider *)theSlider
{
    self.theMainCanvasView.theRedComponent = theSlider.value / keyRGBMaxValue;
}

- (void)actionTheGreenSliderValueDidChange:(UISlider *)theSlider
{
    self.theMainCanvasView.theGreenComponent = theSlider.value / keyRGBMaxValue;
}

- (void)actionClearButtonDidTouchUpInside:(UIButton *)theButton
{
    [self.theMainCanvasView methodClearImage];
}

- (void)actionEraseButtonDidTouchUpInside:(UIButton *)theButton
{
    theButton.selected = !theButton.isSelected;
    if (theButton.isSelected)
    {
        self.theMainCanvasView.theCanvasViewDrawType = CanvasViewDrawTypeErase;
        theButton.backgroundColor = [UIColor greenColor];
    }
    else
    {
        self.theMainCanvasView.theCanvasViewDrawType = CanvasViewDrawTypeWidth;
        theButton.backgroundColor = [UIColor blueColor];
    }
}

- (void)actionUndoButtonDidTouchUpInside:(UIButton *)theButton
{
    if (self.theUndoButton.alpha != 1)
    {
        return;
    }
    [self.theMainCanvasView methodUndo];
    [self methodAdjustUndoRedoButtons];
}

- (void)actionRedoButtonDidTouchUpInside:(UIButton *)theButton
{
    if (self.theRedoButton.alpha != 1)
    {
        return;
    }
    [self.theMainCanvasView methodRedo];
    [self methodAdjustUndoRedoButtons];
}

- (void)actionChooseButtonDidTouchUpInside:(UIButton *)theButton
{
    UIImagePickerController *theImagePicker = [UIImagePickerController new];
    
    theImagePicker.delegate = self;
    
    theImagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:theImagePicker animated:YES completion:nil];
}

- (void)actionSaveButtonDidTouchUpInside:(UIButton *)theButton
{
    UIImageWriteToSavedPhotosAlbum(self.theMainCanvasView.theBackgroundImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)actionWidthButtonDidTouchUpInside:(UIButton *)theButton
{
    theButton.selected  = !theButton.isSelected;
    if (theButton.selected)
    {
        self.theWidthMenuView.theWidth = keyButtonsWidth.theDeviceValue;
        [self.theWidthMenuView methodAdjustCellViews];
        BZAnimation *theBZAnimation = [BZAnimation new];
        [theBZAnimation methodSetAnimationBlock:^
         {
             self.theWidthMenuView.theHeight = self.view.theHeight / 2;
             self.theWidthMenuView.theMaxY = theButton.theCenterY + 10;
         }];
        [theBZAnimation methodStart];
    }
    else
    {
        [self methodHideWidthMenu];
    }
}

#pragma mark - Gestures

#pragma mark - Notifications

- (void)receiveUndoRedoChangedNotification:(NSNotification *)theNotification
{
    [self methodAdjustUndoRedoButtons];
}

#pragma mark - Delegates (UIImagePickerControllerDelegate)

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *theImage = info[UIImagePickerControllerEditedImage];
    
    if (!theImage)
    {
        theImage = info[UIImagePickerControllerOriginalImage];
    }
    self.theMainCanvasView.theBackgroundImage = theImage;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error)
    {
        abort();
    }
    else
    {
        [self methodAlertWithSuccessSaving];
    }
}

#pragma mark - Delegates (WidthMenuViewDelegate)

- (void)widthMenuViewDidSelectWidth:(WidthMenuView * _Nonnull)theWidthMenuView
{
    self.theMainCanvasView.theBrushValue = self.theWidthMenuView.theBrushWidth;
    self.theWidthButton.selected = NO;
    [self methodHideWidthMenu];
}

#pragma mark - Methods (Public)

- (void)methodAdjustUndoRedoButtons
{
    if (self.theMainCanvasView.hasUndo)
    {
        self.theUndoButton.alpha = 1;
    }
    else
    {
        self.theUndoButton.alpha = keyAlphaNotChosedValue;
    }
    if (self.theMainCanvasView.hasRedo)
    {
        self.theRedoButton.alpha = 1;
    }
    else
    {
        self.theRedoButton.alpha = keyAlphaNotChosedValue;
    }
}

- (void)methodHideWidthMenu
{
    BZAnimation *theBZAnimation = [BZAnimation new];
    [theBZAnimation methodSetAnimationBlock:^
     {
         double theMaxYValue = self.theWidthMenuView.theMaxY;
         self.theWidthMenuView.theHeight = 0;
         self.theWidthMenuView.theMaxY = theMaxYValue;
     }];
    [theBZAnimation methodStart];
}

- (void)methodAlertWithSuccessSaving
{
    UIAlertController *theAlert = [UIAlertController alertControllerWithTitle:@"Success"
                                                                      message:@"Image was successfully saved"
                                                               preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *theDefaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
    
    [theAlert addAction:theDefaultAction];
    [self presentViewController:theAlert animated:YES completion:nil];
}

#pragma mark - Methods (Private)

#pragma mark - Standard Methods

@end






























