//
//  KKFluencyBoosterViewController.m
//  Fluency Booster
//
//  Created by Arthur Rocha de Menezes on 09/08/12.
//  Copyright (c) 2012 Arthur Rocha de Menezes. All rights reserved.
//

#import "KKFluencyBoosterViewController.h"

#import "KKCard.h"

#import "KKHelpViewController.h"

@interface KKFluencyBoosterViewController ()

@property BOOL wrap;

-(void)changeBackgroundImageToImageOfCard:(KKCard*)card;

@end

@implementation KKFluencyBoosterViewController

//Synthesize das Sub-Views.
@synthesize carousel = _carousel;
@synthesize currentPageIndexTextField = _currentPageIndexTextField;
@synthesize totalPagesLabel = _totalPagesLabel;
@synthesize backgroundImage = _backgroundImage;

//Delegate
@synthesize delegate = _delegate;

//Cards
@synthesize fluencyBooster = _fluencyBooster;
@synthesize cards = _cards;

//Index do primeiro mini-card
@synthesize indexOfFirstMiniCard = _indexOfFirstMiniCard;

@synthesize wrap = _wrap;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.carousel.currentItemIndex = self.indexOfFirstMiniCard;
    
//    self.totalPagesLabel.text = [NSString stringWithFormat:@"%i",self.cards.count];
    self.totalPagesLabel.text = [NSString stringWithFormat:@"%i",self.fluencyBooster.cards.count];
    
    self.currentPageIndexTextField.text = [NSString stringWithFormat:@"%i",self.carousel.currentItemIndex+1];
    self.currentPageIndexTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    self.title = self.fluencyBooster.name;
    
    UISwipeGestureRecognizer* swipeUpGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(presentHelp)];
    swipeUpGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUpGestureRecognizer];
    
    [self changeBackgroundImageToImageOfCard:[self.cards objectAtIndex:self.carousel.currentItemIndex]];
    
    self.helpImageFileNameWithExtension = @"3.png";
    
}

- (void)viewDidUnload
{
    [self setCarousel:nil];
    [self setCurrentPageIndexTextField:nil];
    [self setTotalPagesLabel:nil];
    [self setBackgroundImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [self changeBackgroundImageToImageOfCard:[self.cards objectAtIndex:self.carousel.currentItemIndex]];
    return YES;
}

-(void)changeBackgroundImageToImageOfCard:(KKCard *)card{
    UIInterfaceOrientation interfaceOrientation = self.interfaceOrientation;
    if (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        self.backgroundImage.image = [UIImage imageWithData:card.imageLandscape];
    }
    if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        self.backgroundImage.image = [UIImage imageWithData:card.imagePortrait];
    }
}

- (IBAction)clearMarks:(UIButton *)sender {
    for (KKCard* card in self.fluencyBooster.cards) {
        card.attentionCheck = nil;
    }
    NSError* saveError;
    if (![self.fluencyBooster.managedObjectContext save:&saveError]) {
        NSLog(@"something went wrong when you cleared the marks of the cards %@",saveError);
    }
    
    [self.carousel reloadData];
}

#pragma mark - UITextFieldDelegate

-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSInteger index = [textField.text integerValue];
    if (index > 0 || index < [self.fluencyBooster.cards count]) {
        [self.carousel scrollToItemAtIndex:index - 1 animated:YES];
    }else{
        if (index <= 0) {
            [self.carousel scrollToItemAtIndex:0 animated:YES];
        }
        if (index >= [self.fluencyBooster.cards count]) {
            [self.carousel scrollToItemAtIndex:[self.cards count] - 1 animated:YES];
        }
    }
}

#pragma mark - iCarousel Methods

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
//    NSLog(@"selected!Index : %i",index);
    [self.delegate selectedCardAtIndex:index FromFluencyBoosterViewController:self];
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel{
    self.currentPageIndexTextField.text = [NSString stringWithFormat:@"%i",self.carousel.currentItemIndex+1];
    [self changeBackgroundImageToImageOfCard:[self.cards objectAtIndex:self.carousel.currentItemIndex]];
}

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [self.fluencyBooster.cards count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    UIImageView* miniCardImageView = nil;
    UIImageView* warningImageView = nil;
    
	//create new view if no view is available for recycling
	if (view == nil)
	{
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 400.0f, 500.0f)];
        view.backgroundColor = [UIColor lightGrayColor];
        
        miniCardImageView = [[UIImageView alloc] init];
        miniCardImageView.frame = view.bounds;
        miniCardImageView.tag = 100;
        [view addSubview:miniCardImageView];
        
        warningImageView = [[UIImageView alloc] init];
        warningImageView.frame = CGRectMake(350, 0, 50, 50);
        warningImageView.tag = 101;
        [view addSubview:warningImageView];
    }
    else
	{
        miniCardImageView = (UIImageView*)[view viewWithTag:100];
        warningImageView  = (UIImageView*)[view viewWithTag:101];
	}
	
    //set image.
    KKCard* miniCard = [[self.fluencyBooster sortedCardsByPosition] objectAtIndex:index];
    miniCardImageView.image = [UIImage imageWithData:miniCard.imagePortrait];
    
    //set warning
    if (miniCard.attentionCheck) {
        NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
        NSString* fluencyBoosterResourcesPath = [resourcePath stringByAppendingPathComponent:@"FluencyBoosterResources"];
        NSString* checkPath = [fluencyBoosterResourcesPath stringByAppendingPathComponent:@"Check"];
        NSString* warningPath = [checkPath stringByAppendingPathComponent:@"warning.png"];
        warningImageView.image = [UIImage imageWithContentsOfFile:warningPath];
    }
	
	return view;
}

- (CATransform3D)carousel:(iCarousel *)_carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * self.carousel.itemWidth);
}

- (CGFloat)carousel:(iCarousel *)_carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return self.wrap;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.05f;
        }
        case iCarouselOptionFadeMax:
        {
            if (self.carousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0f;
            }
            return value;
        }
        default:
        {
            return value;
        }
    }
}


@end
