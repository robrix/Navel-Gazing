//  Copyright (c) 2013 Rob Rix. All rights reserved.

#import "RXCollectionViewController.h"
#import "RXMemoization.h"
#import "RXResponse.h"
#import "RXModelView.h"

@interface RXCollectionViewController () <UITableViewDataSource>
@end

@implementation RXCollectionViewController

#pragma mark View lifecycle

-(void)viewDidLoad {
	
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
