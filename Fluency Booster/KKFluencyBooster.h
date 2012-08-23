//
//  KKFluencyBooster.h
//  Fluency Booster
//
//  Created by Arthur Rocha de Menezes on 07/08/12.
//  Copyright (c) 2012 Arthur Rocha de Menezes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class KKCard;

@interface KKFluencyBooster : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *cards;
@end

@interface KKFluencyBooster (CoreDataGeneratedAccessors)

- (void)addCardsObject:(KKCard *)value;
- (void)removeCardsObject:(KKCard *)value;
- (void)addCards:(NSSet *)values;
- (void)removeCards:(NSSet *)values;

-(NSArray*)sortedCardsByPosition;

@end
