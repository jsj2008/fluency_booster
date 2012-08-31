//
//  KKHelpViewController.h
//  Fluency Booster
//
//  Created by Arthur Rocha de Menezes on 06/08/12.
//  Copyright (c) 2012 Arthur Rocha de Menezes. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KKHelpViewController;

@protocol KKHelpViewControllerDelegate <NSObject>

-(void)closeHelpOfHelpViewController:(KKHelpViewController*) helpViewController;

@end

@interface KKHelpViewController : UIViewController

@property (weak) id<KKHelpViewControllerDelegate> delegate;
@property (strong) NSString* helpImagePath;
@property (strong) NSString* helpImageLandscapePath;

@end
