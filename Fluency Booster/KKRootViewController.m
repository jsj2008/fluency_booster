//
//  KKRootViewController.m
//  Fluency Booster
//
//  Created by Arthur Rocha de Menezes on 06/08/12.
//  Copyright (c) 2012 Arthur Rocha de Menezes. All rights reserved.
//

#import "KKRootViewController.h"

#import "KKDataViewController.h"

#import "KKCardsDataSource.h"

#import "KKHelpViewController.h"

#import "KKCard.h"

@interface KKRootViewController ()

@property (strong,nonatomic) KKCardsDataSource* cardsDataSource;
@end

@implementation KKRootViewController

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
    
    //For some reason the page view was lowered so a added the lines below to make things straight.
    CGRect pageViewRect = self.view.bounds;
    self.pageViewController.view.frame = pageViewRect;
    
    self.helpImageFileNameWithExtension = @"2.png";
}

-(void)viewWillDisappear:(BOOL)animated{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger index = (NSInteger)[self.cardsDataSource indexOfViewController:[[self.pageViewController viewControllers] lastObject]];
    [userDefaults setInteger:index forKey:self.fluencyBooster.name];
    
    [super viewWillDisappear:animated];
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

#pragma mark - KKFluencyBoosterViewControllerDelegate

-(void)selectedCardAtIndex:(NSUInteger)index FromFluencyBoosterViewController:(KKFluencyBoosterViewController*)fluencyBoosterViewController{
    KKDataViewController* startingViewController = [self.cardsDataSource viewControllerAtIndex:index storyboard:self.storyboard];
    NSArray *viewControllers = @[startingViewController];
    
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIPageViewController delegate methods

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
