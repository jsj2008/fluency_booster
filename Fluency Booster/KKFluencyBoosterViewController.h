//
//  KKFluencyBoosterViewController.h
//  Fluency Booster
//
//  Created by Arthur Rocha de Menezes on 09/08/12.
//  Copyright (c) 2012 Arthur Rocha de Menezes. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "iCarousel.h"
#import "KKFluencyBooster.h"

#import "KKAncestorViewController.h"

@class KKFluencyBoosterViewController;

@protocol KKFluencyBoosterViewControllerDelegate <NSObject>

-(void)selectedCardAtIndex:(NSUInteger)index FromFluencyBoosterViewController:(KKFluencyBoosterViewController*)fluencyBoosterViewController;

@end

@interface KKFluencyBoosterViewController : KKAncestorViewController <iCarouselDelegate,iCarouselDataSource,UITextFieldDelegate>

//Propertys de Sub-views.
@property (strong, nonatomic) IBOutlet iCarousel *carousel;
@property (strong, nonatomic) IBOutlet UITextField *currentPageIndexTextField;
@property (strong, nonatomic) IBOutlet UILabel *totalPagesLabel;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;


//Delegate
@property (weak) id<KKFluencyBoosterViewControllerDelegate> delegate;

//Cards
@property (strong) KKFluencyBooster* fluencyBooster;
@property (strong) NSArray* cards;
//Index do primeiro mini-card
@property NSInteger indexOfFirstMiniCard;
- (IBAction)clearMarks:(UIButton *)sender;

@end
