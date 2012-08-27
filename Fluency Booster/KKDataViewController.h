//
//  KKDataViewController.h
//  Fluency Booster
//
//  Created by Arthur Rocha de Menezes on 06/08/12.
//  Copyright (c) 2012 Arthur Rocha de Menezes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKFluencyBoosterViewController.h"
@class KKRootViewController;

@interface KKDataViewController : UIViewController

@property (strong, nonatomic) id dataObject;
@property (strong, nonatomic) IBOutlet UIImageView *cardImageView;

@property (strong) KKRootViewController* rootViewController;


@end
