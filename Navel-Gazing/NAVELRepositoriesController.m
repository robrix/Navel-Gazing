//  Copyright (c) 2013 Rob Rix. All rights reserved.

#import "NAVELRepositoriesController.h"
#import "NAVELModelController.h"

@interface NAVELRepositoriesController ()
@end

@implementation NAVELRepositoriesController

#pragma mark RXCollectionViewControllerDataSource

-(id<RXCollection>)collectionForCollectionViewController:(RXCollectionViewController *)collectionViewController {
	RXFetchedCollection *collection = [[RXFetchedCollection alloc] init];
	collection.request = [[NSFetchRequest alloc] init];
	collection.request.entity = [NSEntityDescription entityForName:@"Repository" inManagedObjectContext:self.modelController.userInterfaceContext];
	collection.request.predicate = [NSPredicate predicateWithFormat:@"owner = %@", self.user];
	collection.request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
		collection.context = self.modelController.userInterfaceContext;
	return collection;
}


#pragma mark RXCollectionViewControllerDelegate

-(void)collectionViewController:(RXCollectionViewController *)controller prepareForSegue:(UIStoryboardSegue *)segue withModelObject:(id)modelObject {
	if ([segue.identifier isEqual:@"repository.branches"]) {
		
	}
}


@end
