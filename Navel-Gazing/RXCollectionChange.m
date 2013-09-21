//  Copyright (c) 2013 Rob Rix. All rights reserved.

#import "RXCollectionChange.h"

id<RXCollectionChange> RXCollectionChangeWithType(NSFetchedResultsChangeType type, NSIndexPath *indexPath, NSIndexPath *newIndexPath) {
	NSDictionary *changeClassesByType = @{
										  @(NSFetchedResultsChangeInsert): [RXCollectionInsertion class],
										  @(NSFetchedResultsChangeUpdate): [RXCollectionUpdate class],
										  @(NSFetchedResultsChangeMove): [RXCollectionMove class],
										  @(NSFetchedResultsChangeDelete): [RXCollectionDeletion class],
										  };
	
	return [[changeClassesByType[@(type)] alloc] initWithIndexPath:indexPath newIndexPath:newIndexPath];
}


@implementation RXCollectionInsertion

@synthesize indexPath = _indexPath;

-(instancetype)initWithIndexPath:(NSIndexPath *)indexPath newIndexPath:(NSIndexPath *)newIndexPath {
	if ((self = [super init])) {
		_indexPath = newIndexPath;
	}
	return self;
}


-(void)applyToTableView:(UITableView *)tableView {
	[tableView insertRowsAtIndexPaths:@[self.indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end


@implementation RXCollectionUpdate

@synthesize indexPath = _indexPath;

-(instancetype)initWithIndexPath:(NSIndexPath *)indexPath newIndexPath:(NSIndexPath *)newIndexPath {
	if ((self = [super init])) {
		_indexPath = indexPath;
	}
	return self;
}


-(void)applyToTableView:(UITableView *)tableView {
	[tableView reloadRowsAtIndexPaths:@[self.indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end


@implementation RXCollectionMove

@synthesize indexPath = _indexPath;

-(instancetype)initWithIndexPath:(NSIndexPath *)indexPath newIndexPath:(NSIndexPath *)newIndexPath {
	if ((self = [super init])) {
		_destinationIndexPath = newIndexPath;
		_indexPath = indexPath;
	}
	return self;
}


-(void)applyToTableView:(UITableView *)tableView {
	[tableView moveRowAtIndexPath:self.indexPath toIndexPath:self.destinationIndexPath];
}

@end


@implementation RXCollectionDeletion

@synthesize indexPath = _indexPath;

-(instancetype)initWithIndexPath:(NSIndexPath *)indexPath newIndexPath:(NSIndexPath *)newIndexPath {
	if ((self = [super init])) {
		_indexPath = indexPath;
	}
	return self;
}

-(void)applyToTableView:(UITableView *)tableView {
	[tableView deleteRowsAtIndexPaths:@[self.indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
