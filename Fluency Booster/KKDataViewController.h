//
//  KKDataViewController.h
//  Fluency Booster
//
//  Created by Arthur Rocha de Menezes on 06/08/12.
//  Copyright (c) 2012 Arthur Rocha de Menezes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKDataViewController : UIViewController

@property (strong, nonatomic) id dataObject;
@property (strong, nonatomic) IBOutlet UIImageView *cardImageView;
@property (strong, nonatomic) IBOutlet UIButton *checkCardButton;


- (IBAction)checkCard:(UIButton *)sender;
- (IBAction)playSong:(UIButton *)sender;



@end
