//  Copyright (c) 2013 Rob Rix. All rights reserved.

@import CoreData;

@interface RXPersistenceController : NSObject

-(void)performOperationWithBlock:(void(^)(NSManagedObjectContext *context))block;

-(void)saveContext:(NSManagedObjectContext *)context withCompletionHandler:(void(^)(NSError *error))completionHandler;

@end
