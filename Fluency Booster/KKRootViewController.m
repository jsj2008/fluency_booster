//
//  KKRootViewController.m
//  Fluency Booster
//
//  Created by Arthur Rocha de Menezes on 06/08/12.
//  Copyright (c) 2012 Arthur Rocha de Menezes. All rights reserved.
//

#import "KKRootViewController.h"
#import "KKDataViewController.h"
#import "KKCard.h"

@interface KKRootViewController ()

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;
@property (strong, nonatomic) IBOutlet UIImageView *footerImageView;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *gotoButton;
@property (strong, nonatomic) IBOutlet UIImageView *titleImageView;
@property (strong, nonatomic) IBOutlet UIImageView *titleBalloonImageView;

@end

@implementation KKRootViewController
@synthesize headerImageView = _headerImageView;
@synthesize footerImageView = _footerImageView;
@synthesize backButton = _backButton;
@synthesize gotoButton = _gotoButton;
@synthesize titleImageView = _titleImageView;
@synthesize titleBalloonImageView = _titleBalloonImageView;

@synthesize cardsDataSource = _cardsDataSource;
@synthesize fluencyBooster = _fluencyBooster;
@synthesize managedObjectContext = _managedObjectContext;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageViewController.delegate = self;
    
    //Loading model passed through segue and passing it to the cardsDataSource.
    self.cardsDataSource = [[KKCardsDataSource alloc] initWithCards:[self.fluencyBooster sortedCardsByPosition]];
    
    //Loading the last page saw by the user of this fluency booster.
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSUInteger index = (NSUInteger)[userDefaults integerForKey:self.fluencyBooster.name];
    
    //the lines below is bring the fluency booster back to the first page when the user back to select another fluency booster from te last page.
    if (index == self.fluencyBooster.cards.count - 1) {
        index = 0;
    }
    
    KKDataViewController* startingViewController = [self.cardsDataSource viewControllerAtIndex:index storyboard:self.storyboard];
    NSArray *viewControllers = @[startingViewController];
    
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
    
    self.pageViewController.dataSource = self.cardsDataSource;
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    
    NSString* currentFluencyBoosterScreenFolderPath = [[self.fluencyBoostersPath stringByAppendingPathComponent:self.fluencyBooster.name] stringByAppendingPathComponent:@"screen"];
    self.titleBalloonImageView.image = [UIImage imageWithContentsOfFile:[currentFluencyBoosterScreenFolderPath stringByAppendingPathComponent:@"titleBalloon.png"]];
    
    [self.backButton setBackgroundImage:[UIImage imageWithContentsOfFile:[self.iconPath stringByAppendingPathComponent:@"backButton.png"]] forState:UIControlStateNormal];
    
    [self.gotoButton setBackgroundImage:[UIImage imageWithContentsOfFile:[self.iconPath stringByAppendingPathComponent:@"goto.png"]] forState:UIControlStateNormal];
    
    self.titleImageView.image = [UIImage imageWithContentsOfFile:[self.screenPath stringByAppendingPathComponent:@"title.png"]];
    
    [self.view bringSubviewToFront:self.titleBalloonImageView];
    
    self.helpImageFileNameWithExtension = @"help2.png";
    self.helpImageLandscapeFileNameWithExtension = @"help2LS.png";
    
    [self.view bringSubviewToFront:self.helpImageView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self adjustSizesAndPositionsForInterfaceOrientation:self.interfaceOrientation];
}

-(void)viewWillDisappear:(BOOL)animated{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger index = (NSInteger)[self.cardsDataSource indexOfViewController:[[self.pageViewController viewControllers] lastObject]];
    [userDefaults setInteger:index forKey:self.fluencyBooster.name];
    
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [self setHeaderImageView:nil];
    [self setFooterImageView:nil];
    [self setBackButton:nil];
    [self setGotoButton:nil];
    [self setTitleImageView:nil];
    [self setTitleBalloonImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self adjustSizesAndPositionsForInterfaceOrientation:toInterfaceOrientation];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
    [self adjustImagesToInterfaceOrientation:interfaceOrientation];
    return YES;
}


-(void)adjustSizesAndPositionsForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
    {
        self.titleImageView.frame = CGRectMake(0, 111, 594.0f, 56.0f);
        self.titleBalloonImageView.frame = CGRectMake(594.0f + 10,
                                                      98,
                                                      82.0f,
                                                      81.0f);
        
        self.pageViewController.view.frame = CGRectMake(0,
                                                        167,
                                                        768,
                                                        732);
        
    }
    if(UIInterfaceOrientationIsLandscape(interfaceOrientation))
    {
        self.titleImageView.frame = CGRectMake(0, 68, 594.0f, 56.0f);
        self.titleBalloonImageView.frame = CGRectMake(594.0f + 10,
                                                      54,
                                                      82.0f,
                                                      81.0f);
        
        self.pageViewController.view.frame = CGRectMake(0,
                                                        125,
                                                        1024,
                                                        542);
    }
}

-(void)adjustImagesToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
        self.headerImageView.image = [UIImage imageWithContentsOfFile:[self.screenPath stringByAppendingPathComponent:@"header.png"]];
        
        self.footerImageView.image = [UIImage imageWithContentsOfFile:[self.screenPath stringByAppendingPathComponent:@"footer.png"]];
    }
    
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        self.headerImageView.image = [UIImage imageWithContentsOfFile:[self.screenPath stringByAppendingPathComponent:@"headerLS.png"]];
        
        self.footerImageView.image = [UIImage imageWithContentsOfFile:[self.screenPath stringByAppendingPathComponent:@"footerLS.png"]];
    }
}

-(KKCardsDataSource*)cardsDataSource{
    if (!_cardsDataSource) {
        _cardsDataSource = [[KKCardsDataSource alloc] init];
    }
    return _cardsDataSource;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqual:@"PresentFluencyBooster"]) {
        KKFluencyBoosterViewController* destinationViewController = segue.destinationViewController;
        destinationViewController.delegate = self;
        destinationViewController.fluencyBooster = self.fluencyBooster;
        destinationViewController.cards = [self.fluencyBooster sortedCardsByPosition];
        
        NSInteger index = (NSInteger)[self.cardsDataSource indexOfViewController:[[self.pageViewController viewControllers] lastObject]];
        destinationViewController.indexOfFirstMiniCard = index;
    }
}
- (IBAction)back:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - KKFluencyBoosterViewControllerDelegate

-(void)selectedCardAtIndex:(NSUInteger)index FromFluencyBoosterViewController:(KKFluencyBoosterViewController*)fluencyBoosterViewController{
    KKDataViewController* startingViewController = [self.cardsDataSource viewControllerAtIndex:index storyboard:self.storyboard];
    NSArray *viewControllers = @[startingViewController];
    
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIPageViewController delegate methods

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    [self adjustSizesAndPositionsForInterfaceOrientation:pageViewController.interfaceOrientation];
}

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        KKDataViewController *currentViewController = [self.pageViewController.viewControllers objectAtIndex:0];
        NSArray *viewControllers = @[currentViewController];
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
        
        self.pageViewController.doubleSided = NO;
        return UIPageViewControllerSpineLocationMin;
    }
    
    return UIPageViewControllerSpineLocationMin;
}


@end
