//  Copyright (c) 2013 Rob Rix. All rights reserved.

#import "RXPersistenceController.h"

#import "RXMaybe.h"
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
	}());
}


@synthesize userInterfaceContext = _userInterfaceContext;

-(NSManagedObjectContext *)userInterfaceContext {
	return RXMemoize(_userInterfaceContext, ^{
		NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
		context.parentContext = self.savingContext;
		return context;
	}());
}


@synthesize model = _model;

-(NSManagedObjectModel *)model {
	return RXMemoize(_model, ^{
		return [NSManagedObjectModel mergedModelFromBundles:@[[NSBundle mainBundle]]];
	}());
}


@synthesize coordinator = _coordinator;

-(NSPersistentStoreCoordinator *)coordinator {
	return RXMemoize(_coordinator, ^{
		NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.model];
		NSURL *storeURL = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:[[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"] stringByAppendingPathExtension:@"sqlite"]];
		NSError *error;
		if (![coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
			NSLog(@"error for URL %@: %@", storeURL, error);
#if DEBUG
			[[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error];
			[coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:NULL];
#endif
		}
		return coordinator;
	}());
}


-(NSManagedObjectContext *)makeTemporaryContext {
	NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
	context.parentContext = self.userInterfaceContext;
	return context;
}

-(RXPromise *)performBackgroundOperationWithBlock:(RXPromise *(^)(NSManagedObjectContext *context))block {
	RXPromise *completion = [RXPromise new];
	NSManagedObjectContext *context = [self makeTemporaryContext];
	[context performBlock:^{
		[completion fulfillWithObject:[block(context) bind:^RXPromise *(id x) {
			return [RXPromise promiseWithObject:x];
		}]];
	}];
	return completion;
}


#pragma mark Persisting

-(RXPromise *)persistChangesInContext:(NSManagedObjectContext *)rootContext {
	return (RXPromise *)RXMonadRecurseWhile([RXJust just:[RXJust just:rootContext]], ^bool(id<RXMaybe> maybeContext){
		return [maybeContext bind:^id<RXMaybe>(id object) {
			return object;
		}];
	}, ^RXPromise *(id<RXMaybe> maybeContext) {
		RXPromise *promise = [RXPromise new];
		return [maybeContext then:^id(NSManagedObjectContext *context) {
			[context performBlock:^{
				NSError *error;
				[promise fulfillWithObject:[context save:&error]?
					[RXJust just:context.parentContext]
				:	[RXNothing nothing:error]];
			}];
			return promise;
		} else:^id(NSError *error) {
			NSLog(@"error saving: %@", error);
			[promise fulfillWithObject:maybeContext];
			return promise;
		}];
	});
}

@end
