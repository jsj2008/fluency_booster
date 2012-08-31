//
//  KKDataViewController.m
//  Fluency Booster
//
//  Created by Arthur Rocha de Menezes on 06/08/12.
//  Copyright (c) 2012 Arthur Rocha de Menezes. All rights reserved.*
//
#import <AVFoundation/AVFoundation.h>
#import "KKRootViewController.h"
#import "KKDataViewController.h"
#import "KKCard.h"

@interface KKDataViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *cardImageView;

@end

@implementation KKDataViewController


@synthesize cardImageView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UITapGestureRecognizer* doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkCard)];
    doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTapGestureRecognizer];
}

- (void)viewDidUnload
{
    [self setCardImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self shouldAutorotateToInterfaceOrientation:self.interfaceOrientation];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    KKCard* cardDataObject = self.dataObject;
    
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
        self.cardImageView.image = [UIImage imageWithContentsOfFile:cardDataObject.imagePortraitPath];
    }
    
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        self.cardImageView.image = [UIImage imageWithContentsOfFile:cardDataObject.imageLandscapePath];
    }
    
    return YES;
}

-(void)checkCard{
    KKCard* card = (KKCard*)self.dataObject;
    [card toggleAttentionCheck];
    NSError* saveError;
    if (![card.managedObjectContext save:&saveError]) {
        NSLog(@"Saving changes of checked card failed: %@", saveError);
    }
}

@end
