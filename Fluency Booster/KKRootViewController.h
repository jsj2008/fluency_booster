//
//  KKRootViewController.h
//  Fluency Booster
//
//  Created by Arthur Rocha de Menezes on 06/08/12.
//  Copyright (c) 2012 Arthur Rocha de Menezes. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KKFluencyBoosterViewController.h"

#import "KKFluencyBooster.h"
#import "KKCardsDataSource.h"

@interface KKRootViewController : UIViewController <UIPageViewControllerDelegate, KKFluencyBoosterViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong) KKFluencyBooster* fluencyBooster;
@property (strong,nonatomic) KKCardsDataSource* cardsDataSource;
@property (strong) NSManagedObjectContext* managedObjectContext;

@end
