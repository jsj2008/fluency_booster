//
//  KKAppDelegate.m
//  Fluency Booster
//
//  Created by Arthur Rocha de Menezes on 06/08/12.
//  Copyright (c) 2012 Arthur Rocha de Menezes. All rights reserved.
//

#import "KKAppDelegate.h"

#import "KKFluencyBooster.h"
#import "KKCard.h"

#import <AVFoundation/AVFoundation.h>

@interface KKAppDelegate()

@property (strong) NSString* fluencyBoosterResourcesPath;
@property (strong) NSString* fluencyBoostersPath;

@end

@implementation KKAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

@synthesize fluencyBoosterResourcesPath = _fluencyBoosterResourcesPath;
@synthesize fluencyBoostersPath = _fluencyBoostersPath;

NSString* const fluencyBoosterResources = @"FluencyBoosterResources";
NSString* const fluencyBoosters = @"Fluency Boosters";
NSString* const portrait = @"portrait";
NSString* const landscape = @"landscape";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self loadPaths];
    if ([self countOfFluencyBoosterOnCoreData] == 0) {
        [self loadCoreData];
    }
    return YES;
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

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FluencyBooster" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"FluencyBooster.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
