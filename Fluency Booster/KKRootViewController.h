//
//  KKRootViewController.h
//  Fluency Booster
//
//  Created by Arthur Rocha de Menezes on 06/08/12.
//  Copyright (c) 2012 Arthur Rocha de Menezes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKAncestorViewController.h"
#import "KKFluencyBoosterViewController.h"
#import "KKCardsDataSource.h"
#import "KKFluencyBooster.h"



@interface KKRootViewController : KKAncestorViewController <UIPageViewControllerDelegate, KKFluencyBoosterViewControllerDelegate>

@property (strong) KKFluencyBooster* fluencyBooster;
@property (strong,nonatomic) KKCardsDataSource* cardsDataSource;
@property (strong) NSManagedObjectContext* managedObjectContext;

@end
