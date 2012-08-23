//
//  KKCardsDataSource.h
//  Fluency Booster
//
//  Created by Arthur Rocha de Menezes on 06/08/12.
//  Copyright (c) 2012 Arthur Rocha de Menezes. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KKDataViewController.h"

@interface KKCardsDataSource : NSObject <UIPageViewControllerDataSource>

@property (strong) NSArray* cards;

-(id)initWithCards:(NSArray*)cards;

- (KKDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(KKDataViewController *)viewController;

@end
