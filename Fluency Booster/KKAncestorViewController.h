//
//  KKAncestorViewController.h
//  Fluency Booster
//
//  Created by Stomp on 15/08/12.
//  Copyright (c) 2012 Arthur Rocha de Menezes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKAncestorViewController : UIViewController

@property (strong) UIImageView* helpImageView;

@property (strong) NSString* resourcePath;
@property (strong) NSString* fluencyBoosterResourcesPath;
@property (strong) NSString* fluencyBoostersPath;
@property (strong) NSString* helpPath;
@property (strong) NSString* iconPath;
@property (strong) NSString* markPath;
@property (strong) NSString* screenPath;
@property (strong) NSString* splashPath;

@property (strong) NSString* helpImageFileNameWithExtension;
@property (strong) NSString* helpImageLandscapeFileNameWithExtension;

-(void)presentHelp;

@end
