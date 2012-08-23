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

@implementation KKAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //Creating test objects on the database
    NSManagedObjectContext* context = self.managedObjectContext;
    
    NSFetchRequest* countFetchRequest = [[NSFetchRequest alloc] init];
    countFetchRequest.entity = [NSEntityDescription entityForName:@"KKFluencyBooster" inManagedObjectContext:context];
    NSError* error;
    NSUInteger count = [context countForFetchRequest:countFetchRequest error:&error];
    if (count == 0) {
        //Getting the resource folder where are the fluency boosters.
        NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
        NSString* fluencyBoosterResourcesPath = [resourcePath stringByAppendingPathComponent:@"FluencyBoosterResources"];
        NSString* fluencyBoostersPath = [fluencyBoosterResourcesPath stringByAppendingPathComponent:@"Fluency Boosters"];
        //Getting the fluency booster folder content.
        NSArray* fluencyBoosterNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:fluencyBoostersPath error:&error];
        
        if (fluencyBoosterNames != nil) {
            for (NSString* fluencyBoosterName in fluencyBoosterNames) {
                KKFluencyBooster* fluencyBooster = [NSEntityDescription insertNewObjectForEntityForName:@"KKFluencyBooster" inManagedObjectContext:context];
                fluencyBooster.name = fluencyBoosterName;
                
                NSString* cardsPath = [fluencyBoostersPath stringByAppendingPathComponent:fluencyBoosterName];
                
                NSArray* contentsName = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:cardsPath error:&error];
                
                NSMutableSet* cards = [NSMutableSet set];
                if (contentsName != nil) {
                    for (NSString* contentName in contentsName) {
                        NSArray* componentsOfContentName = [contentName componentsSeparatedByString:@"."];
                        
                        KKCard* card = [NSEntityDescription insertNewObjectForEntityForName:@"KKCard" inManagedObjectContext:context];
                        
                        if ([componentsOfContentName count] == 2 && [[componentsOfContentName objectAtIndex:1] isEqual:@"png"]) {
                            card.imagePortrait = UIImagePNGRepresentation([UIImage imageWithContentsOfFile:[cardsPath stringByAppendingPathComponent:contentName]]);
                            
                            NSNumber* position = [NSNumber numberWithInt:[[componentsOfContentName objectAtIndex:0] intValue]];
                            card.position = position;
                            
                            NSString* landscapeCardsPath = [cardsPath stringByAppendingPathComponent:@"landscape"];
                            card.imageLandscape = UIImagePNGRepresentation([UIImage imageWithContentsOfFile:[landscapeCardsPath stringByAppendingPathComponent:contentName]]);
                            
                            NSString* audioPath = [cardsPath stringByAppendingPathComponent:@"audio"];
                            
                            NSString* audioQuestionsPath = [audioPath stringByAppendingPathComponent:@"question"];
                            NSString* audioName = [NSString stringWithFormat:@"%@.mp3",[componentsOfContentName objectAtIndex:0]];
                            
                            NSData* audioQuestionData = [NSData dataWithContentsOfFile:[audioQuestionsPath stringByAppendingPathComponent:audioName]];
                            if (audioQuestionData != nil) {
                                card.audioQuestion = audioQuestionData;
                            }
                            
                            [cards addObject:card];
                        }
                    }
                }
                fluencyBooster.cards = cards;
            }
        }
    
        if (![context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }
    return YES;
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
