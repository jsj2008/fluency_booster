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
//Propertys de Sub-views.
@property (strong, nonatomic) IBOutlet iCarousel *carousel;
@property (strong, nonatomic) IBOutlet UILabel*currentPageIndexLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalPagesLabel;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (strong, nonatomic) IBOutlet UIButton *cleanMarksButton;
@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;
@property (strong, nonatomic) IBOutlet UIImageView *footerImageView;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIImageView *titleImageView;
@property (strong, nonatomic) IBOutlet UIImageView *titleBalloonImageView;

@end

@implementation KKFluencyBoosterViewController

//Synthesize das Sub-Views.
@synthesize carousel = _carousel;
@synthesize currentPageIndexLabel = _currentPageIndexLabel;
@synthesize totalPagesLabel = _totalPagesLabel;
@synthesize backgroundImage = _backgroundImage;
@synthesize cleanMarksButton = _cleanMarksButton;
@synthesize headerImageView = _headerImageView;
@synthesize footerImageView = _footerImageView;
@synthesize backButton = _backButton;
@synthesize titleImageView = _titleImageView;
@synthesize titleBalloonImageView = _titleBalloonImageView;

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
    
    self.totalPagesLabel.text = [NSString stringWithFormat:@"%i",self.fluencyBooster.cards.count];
    
    self.currentPageIndexLabel.text = [NSString stringWithFormat:@"%i",self.carousel.currentItemIndex+1];
    
    [self.backButton setBackgroundImage:[UIImage imageWithContentsOfFile:[self.iconPath stringByAppendingPathComponent:@"backButton.png"]] forState:UIControlStateNormal];
    
    [self.cleanMarksButton setBackgroundImage:[UIImage imageWithContentsOfFile:[self.iconPath stringByAppendingPathComponent:@"clearMark.png"]] forState:UIControlStateNormal];
    
    self.titleImageView.image = [UIImage imageWithContentsOfFile:[self.screenPath stringByAppendingPathComponent:@"title.png"]];
    
    NSString* currentFluencyBoosterScreenFolderPath = [[self.fluencyBoostersPath stringByAppendingPathComponent:self.fluencyBooster.name] stringByAppendingPathComponent:@"screen"];
    
    self.titleBalloonImageView.image = [UIImage imageWithContentsOfFile:[currentFluencyBoosterScreenFolderPath stringByAppendingPathComponent:@"titleBalloon.png"]];
    
    self.helpImageFileNameWithExtension = @"help3.png";
    self.helpImageLandscapeFileNameWithExtension = @"help3LS.png";
    
    [self.view bringSubviewToFront:self.titleBalloonImageView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self adjustForInterfaceOrientation:self.interfaceOrientation];
}

- (void)viewDidUnload
{
    [self setCarousel:nil];
    [self setCurrentPageIndexLabel:nil];
    [self setTotalPagesLabel:nil];
    [self setBackgroundImage:nil];
    [self setCleanMarksButton:nil];
    [self setFooterImageView:nil];
    [self setHeaderImageView:nil];
    [self setBackButton:nil];
    [self setTitleImageView:nil];
    [self setTitleBalloonImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [self adjustForInterfaceOrientation:interfaceOrientation];
    return YES;
}

-(void)adjustForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
    {
        
        self.headerImageView.image = [UIImage imageWithContentsOfFile:[self.screenPath stringByAppendingPathComponent:@"header.png"]];
        
        self.footerImageView.image = [UIImage imageWithContentsOfFile:[self.screenPath stringByAppendingPathComponent:@"footer.png"]];
        
        self.backgroundImage.image = [UIImage imageWithContentsOfFile:[[self.cards objectAtIndex:self.carousel.currentItemIndex]imagePortraitPath]];
        
        self.titleImageView.frame = CGRectMake(0, 111, 594.0f, 56.0f);
        self.titleBalloonImageView.frame = CGRectMake(594.0f + 10,
                                                      98,
                                                      82.0f,
                                                      81.0f);
        
    }
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation))
    {
        self.headerImageView.image = [UIImage imageWithContentsOfFile:[self.screenPath stringByAppendingPathComponent:@"headerLS.png"]];
        
        self.footerImageView.image = [UIImage imageWithContentsOfFile:[self.screenPath stringByAppendingPathComponent:@"footerLS.png"]];
        
        self.backgroundImage.image = [UIImage imageWithContentsOfFile:[[self.cards objectAtIndex:self.carousel.currentItemIndex]imageLandscapePath]];
        
        self.titleImageView.frame = CGRectMake(0, 68, 594.0f, 56.0f);
        self.titleBalloonImageView.frame = CGRectMake(594.0f + 10,
                                                      54,
                                                      82.0f,
                                                      81.0f);
    }
    
    [self.carousel reloadData];
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
- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
    self.currentPageIndexLabel.text = [NSString stringWithFormat:@"%i",self.carousel.currentItemIndex+1];
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
        view = [[UIImageView alloc] init];
        view.backgroundColor = [UIColor lightGrayColor];
        
        miniCardImageView = [[UIImageView alloc] init];
        miniCardImageView.tag = 100;
        [view addSubview:miniCardImageView];
        
        warningImageView = [[UIImageView alloc] init];
        warningImageView.tag = 101;
        [view addSubview:warningImageView];
        
        if (self.interfaceOrientation == UIInterfaceOrientationPortrait ||
            self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            view.frame = CGRectMake(0, 0, 478.0f, 461.0f);
            warningImageView.frame = CGRectMake(410, 10, 58, 51);
            
        }else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
                  self.interfaceOrientation == UIInterfaceOrientationLandscapeRight)
        {
            view.frame = CGRectMake(0, 0, 359.0f, 346.0f);
            warningImageView.frame = CGRectMake(291, 10, 58, 51);
        }
        miniCardImageView.frame = view.bounds;
    }
    else
	{
        miniCardImageView = (UIImageView*)[view viewWithTag:100];
        warningImageView  = (UIImageView*)[view viewWithTag:101];
	}
	
    //set image.
    KKCard* miniCard = [[self.fluencyBooster sortedCardsByPosition] objectAtIndex:index];
    miniCardImageView.image = [UIImage imageWithContentsOfFile:miniCard.imagePortraitPath];
    
    //set warning
    if (miniCard.attentionCheck) {
        warningImageView.image = [UIImage imageWithContentsOfFile:[self.markPath stringByAppendingPathComponent:@"warningYellow.png"]];
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
