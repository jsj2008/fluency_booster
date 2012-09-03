//
//  KKAncestorViewController.m
//  Fluency Booster
//
//  Created by Stomp on 15/08/12.
//  Copyright (c) 2012 Arthur Rocha de Menezes. All rights reserved.
//

#import "KKAncestorViewController.h"

@interface KKAncestorViewController ()

@end

@implementation KKAncestorViewController

@synthesize helpImageView = _helpImageView;

@synthesize resourcePath = _resourcePath;
@synthesize fluencyBoosterResourcesPath = _fluencyBoosterResourcesPath;
@synthesize fluencyBoostersPath = _fluencyBoostersPath;
@synthesize helpPath = _helpPath;
@synthesize iconPath = _iconPath;
@synthesize markPath = _markPath;
@synthesize screenPath = _screenPath;
@synthesize splashPath = _splashPath;

@synthesize helpImageFileNameWithExtension = _helpImageFileNameWithExtension;
@synthesize helpImageLandscapeFileNameWithExtension = _helpImageLandscapeFileNameWithExtension;

NSString* const HELP_VIEW_CONTROLLER_IDENTIFIER = @"KKHelpViewController";

NSString* const FLUENCY_BOOSTER_RESOURCES = @"FluencyBoosterResources";
NSString* const FLUENCY_BOOSTERS = @"Fluency Boosters";
NSString* const HELP = @"Help";
NSString* const ICON = @"Icon";
NSString* const MARK = @"Mark";
NSString* const SCREEN = @"Screen";
NSString* const SPLASH = @"Splash";

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.resourcePath = [[NSBundle mainBundle] resourcePath];
        self.fluencyBoosterResourcesPath = [self.resourcePath stringByAppendingPathComponent:FLUENCY_BOOSTER_RESOURCES];
        self.fluencyBoostersPath = [self.fluencyBoosterResourcesPath stringByAppendingPathComponent:FLUENCY_BOOSTERS];
        self.helpPath = [self.fluencyBoosterResourcesPath stringByAppendingPathComponent:HELP];
        self.iconPath = [self.fluencyBoosterResourcesPath stringByAppendingPathComponent:ICON];
        self.markPath = [self.fluencyBoosterResourcesPath stringByAppendingPathComponent:MARK];
        self.screenPath = [self.fluencyBoosterResourcesPath stringByAppendingPathComponent:SCREEN];
        self.splashPath = [self.fluencyBoosterResourcesPath stringByAppendingPathComponent:SPLASH];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UISwipeGestureRecognizer* swipeUpGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(presentHelp)];
    swipeUpGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUpGestureRecognizer];
    
    UISwipeGestureRecognizer* swipeDownGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(closeHelp)];
    swipeDownGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDownGestureRecognizer];
    
    CGRect helpViewFrameOut = self.view.frame;
    helpViewFrameOut.origin.y = helpViewFrameOut.size.height;
    self.helpImageView = [[UIImageView alloc] initWithFrame:helpViewFrameOut];
    self.helpImageView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [self.view addSubview:self.helpImageView];
    [self.view bringSubviewToFront:self.helpImageView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        self.helpImageView.image = [UIImage imageWithContentsOfFile:
                                    [self.helpPath stringByAppendingPathComponent:self.helpImageFileNameWithExtension]];
        
        
        
    }
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        self.helpImageView.image = [UIImage imageWithContentsOfFile:
                                    [self.helpPath stringByAppendingPathComponent:self.helpImageLandscapeFileNameWithExtension]];
    }
    return YES;
}

-(void)presentHelp{
    CGRect helpImageFrameIn = self.view.frame;
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
                             self.helpImageView.frame = helpImageFrameIn;
                         }
                         if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
                             self.helpImageView.frame = helpImageFrameIn;
                         }
                     } completion:^(BOOL fineshed){
                         
                     }
     ];
}

-(void)closeHelp{
    CGRect helpImageFrameOut = self.view.frame;
    helpImageFrameOut.origin.y = helpImageFrameOut.size.height*2;
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
                             self.helpImageView.frame = helpImageFrameOut;
                         }
                         if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
                             self.helpImageView.frame = helpImageFrameOut;
                         }
                     } completion:^(BOOL fineshed){
                         
                     }
     ];
}

@end
