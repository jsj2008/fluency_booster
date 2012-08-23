//
//  KKContentLoader.m
//  Fluency Booster
//
//  Created by Stomp on 23/08/12.
//  Copyright (c) 2012 Arthur Rocha de Menezes. All rights reserved.
//

#import "KKContentLoader.h"
#import "KKFluencyBooster.h"
#import "KKCard.h"

@interface KKContentLoader()

@property (strong) NSString* fluencyBoosterResourcesPath;
@property (strong) NSString* fluencyBoostersPath;


@end

@implementation KKContentLoader

@synthesize managedObjectContext = _managedObjectContext;
@synthesize fluencyBoosterResourcesPath = _fluencyBoosterResourcesPath;
@synthesize fluencyBoostersPath = _fluencyBoostersPath;

NSString* const fluencyBoosterResources = @"FluencyBoosterResources";
NSString* const fluencyBoosters = @"Fluency Boosters";
NSString* const portrait = @"portrait";
NSString* const landscape = @"landscape";

-(id)initWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext{
    if (self = [super init]) {
        self.managedObjectContext = managedObjectContext;
        
        [self loadPaths];
        if ([self countOfFluencyBoosterOnCoreData] == 0) {
            [self loadCoreData];
        }
    }
    return self;
}

-(void)loadPaths{
    NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
    self.fluencyBoosterResourcesPath = [resourcePath stringByAppendingPathComponent:fluencyBoosterResources];
    self.fluencyBoostersPath = [self.fluencyBoosterResourcesPath stringByAppendingPathComponent:fluencyBoosters];
}

-(void)loadCoreData{
    NSError* error;
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSArray* fluencyBoostersFoldersName = [fileManager contentsOfDirectoryAtPath:self.fluencyBoostersPath error:&error];
    for (NSString* fluencyBoosterFolderName in fluencyBoostersFoldersName) {
        if (![fluencyBoosterFolderName hasSuffix:@"."]) {
            KKFluencyBooster* fluencyBooster = [NSEntityDescription insertNewObjectForEntityForName:@"KKFluencyBooster" inManagedObjectContext:self.managedObjectContext];
            
            fluencyBooster.name = fluencyBoosterFolderName;
            
            NSString* fluencyBoosterFolderPath = [self.fluencyBoostersPath stringByAppendingPathComponent:fluencyBoosterFolderName];
            NSString* portraitCardsPath = [fluencyBoosterFolderPath stringByAppendingPathComponent:portrait];
            NSString* landscapeCardsPath = [fluencyBoosterFolderPath stringByAppendingPathComponent:landscape];
            
            NSArray* portraitCardsFolderContentNames = [fileManager contentsOfDirectoryAtPath:portraitCardsPath error:&error];
            NSArray* landscapeCardsFolderContentNames = [fileManager contentsOfDirectoryAtPath:landscapeCardsPath error:&error];
            
            NSMutableArray* cards = [NSMutableArray array];
            
            if (portraitCardsFolderContentNames.count == landscapeCardsFolderContentNames.count) {
                int countOfCards = portraitCardsFolderContentNames.count;
                for (int i = 0; i <= countOfCards - 1; i++) {
                    KKCard* card = [NSEntityDescription insertNewObjectForEntityForName:@"KKCard" inManagedObjectContext:self.managedObjectContext];
                    
                    NSString* portraitCardName = [portraitCardsFolderContentNames objectAtIndex:i];
                    NSString* landscapeCardName = [landscapeCardsFolderContentNames objectAtIndex:i];
                    
                    NSString* portraitCardPath = [portraitCardsPath stringByAppendingPathComponent:portraitCardName];
                    card.imagePortraitPath = portraitCardPath;
                    NSString* landscapeCardPath = [landscapeCardsPath stringByAppendingPathComponent:landscapeCardName];
                    card.imageLandscapePath = landscapeCardPath;
                    
                    int position = [[[portraitCardName componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
                    card.position = [NSNumber numberWithInt:position];
                    
                    [cards addObject:card];
                }
            }else{
                NSLog(@"Erro");
            }
            
            fluencyBooster.cards = [NSSet setWithArray:cards];
        }
    }
    [self.managedObjectContext save:&error];
}

-(NSUInteger)countOfFluencyBoosterOnCoreData{
    NSFetchRequest* countFetchRequest = [[NSFetchRequest alloc] init];
    countFetchRequest.entity = [NSEntityDescription entityForName:@"KKFluencyBooster" inManagedObjectContext:self.managedObjectContext];
    NSError* error;
    NSUInteger count = [self.managedObjectContext countForFetchRequest:countFetchRequest error:&error];
    return count;
}

@end
    