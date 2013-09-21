//  Copyright (c) 2013 Rob Rix. All rights reserved.

#import "RXCollectionViewController.h"
#import "RXMemoization.h"
#import "RXMemo.h"
#import "RXResponse.h"
#import "RXModelView.h"
#import "RXObservationTarget.h"
#import "RXCollectionChange.h"

@interface RXCollectionViewController () <UITableViewDataSource>

@property (nonatomic) RXMemo *collectionMemo;
@property (nonatomic) RXMemo *collectionChangesMemo;

@end

@implementation RXCollectionViewController

-(void)viewDidLoad {
	self.collectionMemo = [RXMemo memoWithTarget:self block:^id(RXCollectionViewController *self) {
		return [self.dataSource collectionForCollectionViewController:self];
	}];
	
	self.collectionChangesMemo = [RXMemo memoWithTarget:self block:^id(RXCollectionViewController *self) {
		NSSet *changes = self.collection.changes;
		if (changes) {
			[self.tableView beginUpdates];
			
			for (id<RXCollectionChange> change in changes) {
				[change applyToTableView:self.tableView];
			}
			
			[self.tableView endUpdates];
		}
		return changes;
	}];
	self.collectionChangesMemo.dependencies = @[[RXObservationTarget targetWithObject:self.collectionMemo keyPath:@"value.changes"]];
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[self.tableView reloadData];
}


-(NSSet *)collectionChanges {
	return self.collectionChangesMemo.value;
}

-(id<RXCollection>)collection {
	return self.collectionMemo.value;
}


#pragma mark Collection elements

-(id)objectAtIndexPath:(NSIndexPath *)indexPath {
	return self.collection.members[indexPath.row];
}


#pragma mark Reuse identifiers

-(NSString *)reuseIdentifierForObjectAtIndexPath:(NSIndexPath *)indexPath {
	return [self reuseIdentifierForObject:[self objectAtIndexPath:indexPath]];
}

-(NSString *)reuseIdentifierForObject:(id)object {
	return self.reuseIdentifierKeyPath? [object valueForKeyPath:self.reuseIdentifierKeyPath] : self.defaultReuseIdentifier;
}


#pragma mark UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.collection.members.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	id modelObject = [self objectAtIndexPath:indexPath];
	
	UITableViewCell<RXModelView> *cell = [tableView dequeueReusableCellWithIdentifier:[self reuseIdentifierForObject:modelObject] forIndexPath:indexPath];
	
	self.viewModel.modelObject = modelObject;
	
	[cell updateWithModelObject:self.viewModel ?: modelObject];
	
	return cell;
}

-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell<RXModelView> *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	[cell cancelUpdating];
}

@end
