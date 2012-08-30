//
//  KKHelpViewController.m
//  Fluency Booster
//
//  Created by Arthur Rocha de Menezes on 06/08/12.
//  Copyright (c) 2012 Arthur Rocha de Menezes. All rights reserved.
//

#import "KKHelpViewController.h"

@interface KKHelpViewController ()

@end

@implementation KKHelpViewController

@synthesize delegate = _delegate;
@synthesize helpImageView = _helpImageView;
@synthesize helpImagePath = _helpImagePath;
@synthesize helpImageLandscapePath = _helpImageLandscapePath;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UISwipeGestureRecognizer* swipeDownGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(closeHelp)];
    swipeDownGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDownGestureRecognizer];
}

- (void)viewDidUnload
{
    [self setHelpImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        if (self.helpImagePath) {
            self.helpImageView.image = [UIImage imageWithContentsOfFile:self.helpImagePath];
        }
    }else if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight){
        if (self.helpImageLandscapePath) {
            self.helpImageView.image = [UIImage imageWithContentsOfFile:self.helpImageLandscapePath];
        }
    }
    
    return YES;
}
- (void)closeHelp {
    [self.delegate closeHelpOfHelpViewController:self];
}

@end
