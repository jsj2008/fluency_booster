//
//  KKDataViewController.m
//  Fluency Booster
//
//  Created by Arthur Rocha de Menezes on 06/08/12.
//  Copyright (c) 2012 Arthur Rocha de Menezes. All rights reserved.*
//
#import <AVFoundation/AVFoundation.h>

#import "KKDataViewController.h"

#import "KKCard.h"

@interface KKDataViewController ()

@end

@implementation KKDataViewController

@synthesize cardImageView;
@synthesize checkCardButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setCardImageView:nil];
    [self setCheckCardButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    KKCard* cardDataObject = self.dataObject;
    
    if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        self.cardImageView.image = [UIImage imageWithData:cardDataObject.imageLandscape];
    }
    
    if (self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        self.cardImageView.image = [UIImage imageWithData:cardDataObject.imagePortrait];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    KKCard* cardDataObject = self.dataObject;
    
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        self.cardImageView.image = [UIImage imageWithData:cardDataObject.imageLandscape];
    }
    
    if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        self.cardImageView.image = [UIImage imageWithData:cardDataObject.imagePortrait];
    }
    
    return YES;
}

- (IBAction)checkCard:(UIButton *)sender {
    KKCard* card = (KKCard*)self.dataObject;
    [card toggleAttentionCheck];
    NSError* saveError;
    if (![card.managedObjectContext save:&saveError]) {
        NSLog(@"Saving changes of checked card failed: %@", saveError);
    }
}

- (IBAction)playSong:(UIButton *)sender {
    NSError* error;
    KKCard* card = (KKCard*)self.dataObject;
    AVAudioPlayer* player = [[AVAudioPlayer alloc] initWithData:card.audioQuestion error:&error];
    [player prepareToPlay];
//    [player play];
}
@end
