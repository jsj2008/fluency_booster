//
//  KKContentLoader.h
//  Fluency Booster
//
//  Created by Stomp on 23/08/12.
//  Copyright (c) 2012 Arthur Rocha de Menezes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKContentLoader : NSObject

@property (strong) NSManagedObjectContext* managedObjectContext;

-(id)initWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

@end
