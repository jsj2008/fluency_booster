//
//  KKAncestorViewController.h
//  Fluency Booster
//
//  Created by Stomp on 15/08/12.
//  Copyright (c) 2012 Arthur Rocha de Menezes. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KKHelpViewController.h"

@interface KKAncestorViewController : UIViewController<KKHelpViewControllerDelegate>

@property (strong) NSString* helpResourcesPath;
@property (strong) NSString* helpImageFileNameWithExtension;

-(void)presentHelp;

@end
