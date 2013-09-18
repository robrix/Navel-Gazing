//  Copyright (c) 2013 Rob Rix. All rights reserved.

#import "RXCollectionController.h"
#import "RXPersistenceController.h"

@interface RXCollectionController () <NSFetchedResultsControllerDelegate>

@property (nonatomic) IBOutlet RXPersistenceController *persistenceController;

@property (nonatomic, readonly) NSFetchedResultsController *fetchedResultsController;

@end

@implementation RXCollectionController

-(instancetype)initWithFetchRequest:(NSFetchRequest *)request persistenceController:(RXPersistenceController *)persistenceController {
	if ((self = [super init])) {
		_persistenceController = persistenceController;
		_fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:persistenceController.userInterfaceContext sectionNameKeyPath:nil cacheName:nil];
		_fetchedResultsController.delegate = self;
	}
	return self;
}

-(instancetype)init {
	RXPersistenceController *persistenceController = [RXPersistenceController new];
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
	request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
	return [self initWithFetchRequest:request persistenceController:persistenceController];
}


-(void)awakeFromNib {
	NSError *error;
	if (![self.fetchedResultsController performFetch:&error]) {
		NSLog(@"Error: %@", error);
	}
}


-(id<RXPromise>)collectionPromise {
	RXPromiseResolver *resolver = [RXPromiseResolver new];
	[self.fetchedResultsController.managedObjectContext performBlock:^{
		NSError *error;
		[resolver fulfillWithObject:[self.fetchedResultsController performFetch:&error]? self.fetchedResultsController.fetchedObjects : nil];
	}];
	return resolver.promise;
}


-(id<NSFetchedResultsSectionInfo>)sectionAtIndex:(NSUInteger)index {
	return self.fetchedResultsController.sections[index];
}

-(id)objectAtIndexPath:(NSIndexPath *)indexPath {
	return [self.fetchedResultsController objectAtIndexPath:indexPath];
}


-(IBAction)insertObject:(id)sender {
	NSEntityDescription *entity = self.fetchedResultsController.fetchRequest.entity;
	Class class = NSClassFromString([entity managedObjectClassName]);
	NSManagedObject *object = [[class alloc] initWithEntity:entity insertIntoManagedObjectContext:self.fetchedResultsController.managedObjectContext];
	[object setValue:@"Rob Rix" forKey:@"name"];
	[self.persistenceController saveContext:self.persistenceController.userInterfaceContext withCompletionHandler:^(NSError *error) {
		if (error) {
			NSLog(@"error: %@", error);
		}
	}];
}


-(NSString *)reuseIdentifierForObjectAtIndexPath:(NSIndexPath *)indexPath {
	return [self reuseIdentifierForObject:[self objectAtIndexPath:indexPath]];
}

-(NSString *)reuseIdentifierForObject:(id)object {
	return self.reuseIdentifierKeyPath? [object valueForKeyPath:self.reuseIdentifierKeyPath] : @"user";
}


#pragma mark NSFetchedResultsControllerDelegate

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView beginUpdates];
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	switch (type) {
		case NSFetchedResultsChangeInsert:
			[self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
			break;
			
		case NSFetchedResultsChangeUpdate:
			[self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
			break;
			
		case NSFetchedResultsChangeMove:
			[self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
			break;
			
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
			break;
	}
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView endUpdates];
}


#pragma mark UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.fetchedResultsController.sections.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self sectionAtIndex:section].numberOfObjects;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self reuseIdentifierForObjectAtIndexPath:indexPath] forIndexPath:indexPath];
	cell.textLabel.text = @"Name";
	return cell;
}


#pragma mark UITableViewDelegate

@end
