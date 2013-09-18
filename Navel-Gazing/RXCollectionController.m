//  Copyright (c) 2013 Rob Rix. All rights reserved.

#import "RXCollectionController.h"

@interface RXCollectionController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, readonly) NSFetchedResultsController *fetchedResultsController;

@end

@implementation RXCollectionController

-(instancetype)initWithFetchRequest:(NSFetchRequest *)request context:(NSManagedObjectContext *)context {
	if ((self = [super init])) {
		_fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
	}
	return self;
}


-(id<RXPromise>)collectionPromise {
	RXPromiseResolver *resolver = [RXPromiseResolver new];
	[self.fetchedResultsController.managedObjectContext performBlock:^{
		NSError *error;
		[resolver fulfillWithObject:[self.fetchedResultsController performFetch:&error]? self.fetchedResultsController.fetchedObjects : nil];
	}];
	return resolver.promise;
}


#pragma mark NSFetchedResultsControllerDelegate

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	
}

@end
