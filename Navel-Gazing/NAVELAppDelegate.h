//
//  NAVELAppDelegate.h
//  Navel-Gazing
//
//  Created by Rob Rix on 9/17/2013.
//  Copyright (c) 2013 Rob Rix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NAVELAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
