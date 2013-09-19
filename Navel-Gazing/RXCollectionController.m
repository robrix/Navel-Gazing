//  Copyright (c) 2013 Rob Rix. All rights reserved.

#import "RXCollectionController.h"
#import "RXPersistenceController.h"
#import "RXMemoization.h"
#import "RXResponse.h"
#import "RXModelView.h"

@interface RXCollectionController () <NSFetchedResultsControllerDelegate>

@property (nonatomic) IBOutlet RXPersistenceController *persistenceController;

@property (nonatomic, readonly) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic) IBOutlet UIStoryboardSegue *addModelSegue;

@property (nonatomic, readonly) NSFetchRequest *request;
@property (nonatomic) NSManagedObjectContext *context;

@property (nonatomic) id windowDidBecomeKeyObserver;

@end

@implementation RXCollectionController

-(instancetype)initWithFetchRequest:(NSFetchRequest *)request {
	if ((self = [super init])) {
		_request = request;
		
		_windowDidBecomeKeyObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UIWindowDidBecomeKeyNotification object:[UIApplication sharedApplication].delegate.window queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
			
			[self refetch];
			
			[[NSNotificationCenter defaultCenter] removeObserver:_windowDidBecomeKeyObserver];
			_windowDidBecomeKeyObserver = nil;
		}];
	}
	return self;
}

-(void)dealloc {
	if (_windowDidBecomeKeyObserver) {
		[[NSNotificationCenter defaultCenter] removeObserver:_windowDidBecomeKeyObserver];
	}
}

-(instancetype)init {
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
	request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
	return [self initWithFetchRequest:request];
}

@synthesize fetchedResultsController = _fetchedResultsController;

-(NSFetchedResultsController *)fetchedResultsController {
	return self.context?
		RXMemoize(_fetchedResultsController, ^{
		NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:self.request managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
		fetchedResultsController.delegate = self;
		return fetchedResultsController;
	}())
	:	nil;
}

-(void)refetch {
	RXMemoize(self.context, RXResponseToMessage(@selector(requestUserInterfaceContext:), self.tableView));
	
	NSError *error;
	if (![self.fetchedResultsController performFetch:&error]) {
		NSLog(@"Error: %@", error);
	}
	
	[self.tableView reloadData];
}


-(id<NSFetchedResultsSectionInfo>)sectionAtIndex:(NSUInteger)index {
	return self.fetchedResultsController.sections[index];
}

-(id)objectAtIndexPath:(NSIndexPath *)indexPath {
	return [self.fetchedResultsController objectAtIndexPath:indexPath];
}


-(NSString *)reuseIdentifierForObjectAtIndexPath:(NSIndexPath *)indexPath {
	return [self reuseIdentifierForObject:[self objectAtIndexPath:indexPath]];
}

-(NSString *)reuseIdentifierForObject:(id)object {
	return self.reuseIdentifierKeyPath? [object valueForKeyPath:self.reuseIdentifierKeyPath] : self.defaultReuseIdentifier;
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
	id modelObject = [self objectAtIndexPath:indexPath];
	
	UITableViewCell<RXModelView> *cell = [tableView dequeueReusableCellWithIdentifier:[self reuseIdentifierForObject:modelObject] forIndexPath:indexPath];
	
	[cell updateWithModelObject:modelObject];
	
	return cell;
}


#pragma mark UITableViewDelegate

@end
