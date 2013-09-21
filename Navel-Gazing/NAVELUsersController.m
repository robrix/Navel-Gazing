//  Copyright (c) 2013 Rob Rix. All rights reserved.

#import "NAVELUsersController.h"
#import "NAVELModelController.h"
#import "NAVELRepositoriesController.h"
#import "RXCollectionViewController.h"

#import "RXMemoization.h"
#import "RXResponse.h"

@interface NAVELUsersController () <UIAlertViewDelegate, UITextFieldDelegate, RXCollectionViewControllerDataSource, RXCollectionViewControllerDelegate>

@property (nonatomic) UIAlertView *userPrompt;
@property (nonatomic) NAVELModelController *modelController;

@property (nonatomic) IBOutlet RXCollectionViewController *viewController;

@end

@implementation NAVELUsersController

-(IBAction)createUser:(id)sender {
	self.userPrompt = [[UIAlertView alloc] initWithTitle:@"Add User" message:@"Enter the name of the user to add." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
	self.userPrompt.alertViewStyle = UIAlertViewStylePlainTextInput;
	[self.userPrompt textFieldAtIndex:0].delegate = self;
	[self.userPrompt show];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	NSString *userName = [alertView textFieldAtIndex:0].text;
	[self.modelController promiseForUserWithName:userName];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
	[self.userPrompt dismissWithClickedButtonIndex:[self.userPrompt firstOtherButtonIndex] animated:YES];
}


#pragma mark RXCollectionViewControllerDataSource

-(id<RXCollection>)collectionForCollectionViewController:(RXCollectionViewController *)collectionViewController {
	RXMemoize(self.modelController, RXResponseToMessage(@selector(respondWithModelController:), self.viewController));
	
	RXFetchedCollection *collection = nil;
	if (self.modelController) {
		collection = [[RXFetchedCollection alloc] init];
		collection.request = [[NSFetchRequest alloc] init];
		collection.request.entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:self.modelController.userInterfaceContext];
		collection.request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"insertionDate" ascending:YES]];
		collection.context = self.modelController.userInterfaceContext;
	}
	return collection;
}


#pragma mark RXCollectionViewControllerDelegate

-(void)collectionViewController:(RXCollectionViewController *)controller prepareForSegue:(UIStoryboardSegue *)segue withModelObject:(id)modelObject {
	if ([segue.identifier isEqual:@"userRepositories"]) {
		RXCollectionViewController *repositoriesViewController = segue.destinationViewController;
		
		NAVELRepositoriesController *repositoriesController = [NAVELRepositoriesController new];
		repositoriesController.modelController = self.modelController;
		repositoriesController.user = modelObject;
		
		repositoriesViewController.delegate = repositoriesController;
		repositoriesViewController.dataSource = repositoriesController;
	}
}

@end
