//  Copyright (c) 2013 Rob Rix. All rights reserved.

@import CoreData;

@interface RXPersistenceController : NSObject

@property (nonatomic, readonly) NSManagedObjectContext *savingContext;
@property (nonatomic, readonly) NSManagedObjectContext *userInterfaceContext;

@property (nonatomic, readonly) NSManagedObjectModel *model;

@property (nonatomic, readonly) NSPersistentStoreCoordinator *coordinator;

-(void)performOperationWithBlock:(void(^)(NSManagedObjectContext *context))block;

-(void)saveContext:(NSManagedObjectContext *)context withCompletionHandler:(void(^)(NSError *error))completionHandler;

@end
