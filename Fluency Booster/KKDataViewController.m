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

#import "KKRootViewController.h"

@interface KKDataViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;
@property (strong, nonatomic) IBOutlet UIImageView *footerImageView;

@end

@implementation KKDataViewController
@synthesize headerImageView;
@synthesize footerImageView;

@synthesize cardImageView;
@synthesize checkCardButton;
@synthesize backButton;
@synthesize gotoButton;

@synthesize rootViewController;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.helpImageFileNameWithExtension = @"help2.png";
    
    [self.backButton setBackgroundImage:[UIImage imageWithContentsOfFile:[self.iconPath stringByAppendingPathComponent:@"backButton.png"]] forState:UIControlStateNormal];
    [self.gotoButton setBackgroundImage:[UIImage imageWithContentsOfFile:[self.iconPath stringByAppendingPathComponent:@"goto.png"]] forState:UIControlStateNormal];
    self.headerImageView.image = [UIImage imageWithContentsOfFile:[self.screenPath stringByAppendingPathComponent:@"header.png"]];
    
    self.footerImageView.image = [UIImage imageWithContentsOfFile:[self.screenPath stringByAppendingPathComponent:@"footer.png"]];
    
//    UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
//    [self.view addGestureRecognizer:tapGestureRecognizer];
//    tapGestureRecognizer.delegate = self;
}

- (void)viewDidUnload
{
    [self setCardImageView:nil];
    [self setCheckCardButton:nil];
    [self setBackButton:nil];
    [self setHeaderImageView:nil];
    [self setFooterImageView:nil];
    [self setGotoButton:nil];
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
    
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        self.cardImageView.image = [UIImage imageWithContentsOfFile:cardDataObject.imageLandscapePath];
    }
    
    if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        self.cardImageView.image = [UIImage imageWithContentsOfFile:cardDataObject.imagePortraitPath];
    }
    
    return YES;
}

//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
//    UIView* touchedView = touch.view;
//    NSLog(@"%@",touchedView.class);
//    if ([touchedView class] == [UIButton class]) {
//        NSLog(@"Botão");
//        return NO;
//    }else{
//        return YES;
//    }
//}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqual:@"PresentFluencyBooster"]) {
        KKFluencyBoosterViewController* destinationViewController = segue.destinationViewController;
        destinationViewController.delegate = self.rootViewController;
        destinationViewController.fluencyBooster = self.rootViewController.fluencyBooster;
        destinationViewController.cards = [self.rootViewController.fluencyBooster sortedCardsByPosition];
        
        NSInteger index = (NSInteger)[self.rootViewController.cardsDataSource indexOfViewController:[[self.rootViewController.pageViewController viewControllers] lastObject]];
        destinationViewController.indexOfFirstMiniCard = index;
    }
}

- (IBAction)checkCard:(UIButton *)sender {
    KKCard* card = (KKCard*)self.dataObject;
    [card toggleAttentionCheck];
    NSError* saveError;
    if (![card.managedObjectContext save:&saveError]) {
        NSLog(@"Saving changes of checked card failed: %@", saveError);
    }
}

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
