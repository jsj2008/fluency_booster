//
//  KKCard.h
//  Fluency Booster
//
//  Created by Stomp on 23/08/12.
//  Copyright (c) 2012 Arthur Rocha de Menezes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class KKFluencyBooster;

@interface KKCard : NSManagedObject

@property (nonatomic, retain) NSNumber * attentionCheck;
@property (nonatomic, retain) NSData * audioQuestion;
@property (nonatomic, retain) NSString * imageLandscapePath;
@property (nonatomic, retain) NSString * imagePortraitPath;
@property (nonatomic, retain) NSNumber * position;
@property (nonatomic, retain) KKFluencyBooster *fluencyBooster;

-(void)toggleAttentionCheck;

@end
