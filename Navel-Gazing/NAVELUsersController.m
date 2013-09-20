//  Copyright (c) 2013 Rob Rix. All rights reserved.

#import "NAVELUsersController.h"
#import "NAVELModelController.h"

#import "RXMemoization.h"
#import "RXResponse.h"

@interface NAVELUsersController () <UIAlertViewDelegate, UITextFieldDelegate>

@property (nonatomic) UIAlertView *userPrompt;
@property (nonatomic) NAVELModelController *modelController;

@property (nonatomic) IBOutlet UIViewController *viewController;

@end

@implementation NAVELUsersController

-(IBAction)createUser:(id)sender {
	RXMemoize(self.modelController, RXResponseToMessage(@selector(respondWithModelController:), self.viewController));
	
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

@end
