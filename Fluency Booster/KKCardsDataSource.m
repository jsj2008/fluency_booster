//
//  KKCardsDataSource.m
//  Fluency Booster
//
//  Created by Arthur Rocha de Menezes on 06/08/12.
//  Copyright (c) 2012 Arthur Rocha de Menezes. All rights reserved.
//

#import "KKCardsDataSource.h"

#import "KKCard.h"

@implementation KKCardsDataSource

@synthesize cards = _cards;

-(id)init{
    return [self initWithCards:[NSArray array]];
}

-(id)initWithCards:(NSArray*)cards{
    if (self = [super init]) {
        self.cards = cards;
    }
    return self;
}

- (KKDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard
{
    // Return the data view controller for the given index.
    if (([self.cards count] == 0) || (index >= [self.cards count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    KKDataViewController *dataViewController = [storyboard instantiateViewControllerWithIdentifier:@"KKDataViewController"];
    dataViewController.dataObject = [self.cards objectAtIndex:index];
    return dataViewController;
}

- (NSUInteger)indexOfViewController:(KKDataViewController *)viewController
{
    // Return the index of the given data view controller.
    // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
    return [self.cards indexOfObject:viewController.dataObject];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(KKDataViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(KKDataViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.cards count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

@end
