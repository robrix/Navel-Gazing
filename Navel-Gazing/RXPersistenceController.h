//  Copyright (c) 2013 Rob Rix. All rights reserved.

@import CoreData;

#import "RXPromise.h"

@interface RXPersistenceController : NSObject

@property (nonatomic, readonly) NSManagedObjectContext *savingContext;
@property (nonatomic, readonly) NSManagedObjectContext *userInterfaceContext;

@property (nonatomic, readonly) NSManagedObjectModel *model;

@property (nonatomic, readonly) NSPersistentStoreCoordinator *coordinator;

-(RXPromise *)performBackgroundOperationWithBlock:(RXPromise *(^)(NSManagedObjectContext *context))block;

-(RXPromise *)persistChangesInContext:(NSManagedObjectContext *)context;

@end
