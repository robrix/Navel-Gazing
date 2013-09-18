//  Copyright (c) 2013 Rob Rix. All rights reserved.

#import "RXPersistenceController.h"

#import "RXMemoization.h"

@interface RXPersistenceController ()
@end

@implementation RXPersistenceController

#pragma mark Core data stack

@synthesize savingContext = _savingContext;

-(NSManagedObjectContext *)savingContext {
	return RXMemoize(_savingContext, ^{
		NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
		context.persistentStoreCoordinator = self.coordinator;
		return context;
	});
}


@synthesize userInterfaceContext = _userInterfaceContext;

-(NSManagedObjectContext *)userInterfaceContext {
	return RXMemoize(_userInterfaceContext, ^{
		NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
		context.parentContext = self.savingContext;
		return context;
	});
}


@synthesize model = _model;

-(NSManagedObjectModel *)model {
	return RXMemoize(_model, ^{
		return [NSManagedObjectModel mergedModelFromBundles:@[[NSBundle mainBundle]]];
	});
}


@synthesize coordinator = _coordinator;

-(NSPersistentStoreCoordinator *)coordinator {
	return RXMemoize(_coordinator, ^{
		NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.model];
		NSURL *storeURL = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"Declarative.sqlite"];
		NSError *error;
		[coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
		return coordinator;
	});
}


-(NSManagedObjectContext *)makeTemporaryContext {
	NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
	context.parentContext = self.userInterfaceContext;
	return context;
}

-(void)performOperationWithBlock:(void(^)(NSManagedObjectContext *context))block {
	NSManagedObjectContext *context = [self makeTemporaryContext];
	[context performBlock:^{
		block(context);
	}];
}


#pragma mark Saving

-(void)saveContext:(NSManagedObjectContext *)context withCompletionHandler:(void(^)(NSError *error))completionHandler {
	[context performBlock:^{
		NSError *error;
		bool didSave = [context save:&error];
		NSManagedObjectContext *parentContext = context.parentContext;
		if (didSave && parentContext != nil) {
			[self saveContext:parentContext withCompletionHandler:completionHandler];
		} else if (completionHandler) {
			completionHandler(didSave? nil : error);
		}
	}];
}

@end
