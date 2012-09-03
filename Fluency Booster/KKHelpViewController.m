//
//  KKHelpViewController.m
//  Fluency Booster
//
//  Created by Arthur Rocha de Menezes on 06/08/12.
//  Copyright (c) 2012 Arthur Rocha de Menezes. All rights reserved.
//

#import "KKHelpViewController.h"

@interface KKHelpViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *helpImageView;

@end

@implementation KKHelpViewController

@synthesize delegate = _delegate;

@synthesize helpImageView = _helpImageView;
@synthesize helpImagePath = _helpImagePath;
@synthesize helpImageLandscapePath = _helpImageLandscapePath;

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
    
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
        if (self.helpImagePath) {
            self.helpImageView.image = [UIImage imageWithContentsOfFile:self.helpImagePath];
        }
    }
    if(UIInterfaceOrientationIsLandscape(interfaceOrientation)){
        if (self.helpImageLandscapePath) {
            self.helpImageView.image = [UIImage imageWithContentsOfFile:self.helpImageLandscapePath];
        }
    }
    [self.delegate shouldAutorotateToInterfaceOrientation:self.interfaceOrientation];
    return YES;
}
- (void)closeHelp {
    [self.delegate closeHelpOfHelpViewController:self];
}

@end
