//
//  KKDataViewController.h
//  Fluency Booster
//
//  Created by Arthur Rocha de Menezes on 06/08/12.
//  Copyright (c) 2012 Arthur Rocha de Menezes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKAncestorViewController.h"
#import "KKFluencyBoosterViewController.h"
@class KKRootViewController;

@interface KKDataViewController : KKAncestorViewController <UIGestureRecognizerDelegate>

@property (strong, nonatomic) id dataObject;
@property (strong, nonatomic) IBOutlet UIImageView *cardImageView;
@property (strong, nonatomic) IBOutlet UIButton *checkCardButton;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *gotoButton;

@property (strong) KKRootViewController* rootViewController;


- (IBAction)checkCard:(UIButton *)sender;
- (IBAction)back:(UIButton *)sender;


@end
