//
//  KKFluencyBooster.m
//  Fluency Booster
//
//  Created by Arthur Rocha de Menezes on 07/08/12.
//  Copyright (c) 2012 Arthur Rocha de Menezes. All rights reserved.
//

#import "KKFluencyBooster.h"
#import "KKCard.h"


@implementation KKFluencyBooster

@dynamic name;
@dynamic cards;

-(NSArray*)sortedCardsByPosition{
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"position" ascending:YES];
    NSArray* sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    return [[self.cards allObjects] sortedArrayUsingDescriptors:sortDescriptors];
}

@end
