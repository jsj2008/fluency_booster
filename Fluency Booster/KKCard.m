//
//  KKCard.m
//  Fluency Booster
//
//  Created by Stomp on 23/08/12.
//  Copyright (c) 2012 Arthur Rocha de Menezes. All rights reserved.
//

#import "KKCard.h"
#import "KKFluencyBooster.h"


@implementation KKCard

@dynamic attentionCheck;
@dynamic audioQuestion;
@dynamic imageLandscapePath;
@dynamic imagePortraitPath;
@dynamic position;
@dynamic fluencyBooster;

-(void)toggleAttentionCheck{
    if (self.attentionCheck) {
        self.attentionCheck  = nil;
    }else{
        self.attentionCheck = [NSNumber numberWithBool:YES];
    }
}

@end
