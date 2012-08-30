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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(void)presentHelp{
    NSString* helpImagePath = [self.helpPath stringByAppendingPathComponent:self.helpImageFileNameWithExtension];
    NSString* helpImageLandscapePath = [self.helpPath stringByAppendingPathComponent:self.helpImageLandscapeFileNameWithExtension];
    
    KKHelpViewController* helpViewController = [self.storyboard instantiateViewControllerWithIdentifier:HELP_VIEW_CONTROLLER_IDENTIFIER];
    helpViewController.delegate = self;
    helpViewController.helpImagePath = helpImagePath;
    helpViewController.helpImageLandscapePath = helpImageLandscapePath;
    [self presentViewController:helpViewController animated:YES completion:nil];
}

#pragma mark - KKHelpViewControllerDelegate

-(void)closeHelpOfHelpViewController:(KKHelpViewController *)helpViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
