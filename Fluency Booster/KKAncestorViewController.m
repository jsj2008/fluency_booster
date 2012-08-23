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

@synthesize helpResourcesPath = _helpResourcesPath;
@synthesize helpImageFileNameWithExtension = _helpImageFileNameWithExtension;

NSString* const helpViewControllerIdentifier = @"KKHelpViewController";

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
    NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString* fluencyBoosterResourcesPath = [resourcePath stringByAppendingPathComponent:@"FluencyBoosterResources"];
    self.helpResourcesPath = [fluencyBoosterResourcesPath stringByAppendingPathComponent:@"Help"];
    
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)presentHelp{
    NSString* helpImagePath = [self.helpResourcesPath stringByAppendingPathComponent:self.helpImageFileNameWithExtension];
    
    KKHelpViewController* helpViewController = [self.storyboard instantiateViewControllerWithIdentifier:helpViewControllerIdentifier];
    helpViewController.delegate = self;
    helpViewController.helpImagePath = helpImagePath;
    [self presentViewController:helpViewController animated:YES completion:nil];
    
}

#pragma mark - KKHelpViewControllerDelegate

-(void)closeHelpOfHelpViewController:(KKHelpViewController *)helpViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
