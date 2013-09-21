//  Copyright (c) 2013 Rob Rix. All rights reserved.

#import "RXCollection.h"
#import "RXCollectionChange.h"
#import "RXMemo.h"
#import "RXMemoization.h"

@interface RXFetchedCollection () <NSFetchedResultsControllerDelegate>

@property (nonatomic, readonly) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, readonly) RXMemo *refetch;

@property (nonatomic, readonly) NSMutableSet *mutableChanges;

@end

@implementation RXFetchedCollection

@synthesize fetchedResultsController = _fetchedResultsController;

-(NSFetchedResultsController *)fetchedResultsController {
	return RXMemoize(_fetchedResultsController, ^id{
		NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:self.request managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
		controller.delegate = self;
		return controller;
	}());
}


@synthesize refetch = _refetch;

-(RXMemo *)refetch {
	return RXMemoize(_refetch, [RXMemo memoWithTarget:self block:^id(RXFetchedCollection *self) {
		NSError *error;
		return [self.fetchedResultsController performFetch:&error]? nil : error;
	}]);
}


-(NSArray *)members {
	[self.refetch evaluate];
	return self.fetchedResultsController.fetchedObjects;
}


-(NSError *)fetchError {
	return self.refetch.value;
}


@synthesize mutableChanges = _mutableChanges;

-(NSMutableSet *)mutableChanges {
	return RXMemoize(_mutableChanges, [NSMutableSet new]);
}

-(NSSet *)changes {
	return self.mutableChanges;
}


#pragma mark NSFetchedResultsControllerDelegate

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	[self willChangeValueForKey:@"changes"];
	[self.mutableChanges removeAllObjects];
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	
	[self.mutableChanges addObject:RXCollectionChangeWithType(type, indexPath, newIndexPath)];
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[self didChangeValueForKey:@"changes"];
}

@end
