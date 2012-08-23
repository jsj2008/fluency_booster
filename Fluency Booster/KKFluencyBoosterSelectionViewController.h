//
//  KKFluencyBoosterSelectionViewController.h
//  Fluency Booster
//
//  Created by Arthur Rocha de Menezes on 06/08/12.
//  Copyright (c) 2012 Arthur Rocha de Menezes. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

#import "KKAncestorViewController.h"

@interface KKFluencyBoosterSelectionViewController : KKAncestorViewController <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *fluencyBoosterTableView;

@property (strong) NSManagedObjectContext* managedObjectContext;

@end
