//  Copyright (c) 2013 Rob Rix. All rights reserved.

#import "NAVELAppDelegate.h"

#import "NAVELModelController.h"
#import "RXPersistenceController.h"
#import "RXResourceController.h"
#import "RXPromise.h"
#import "RXResponse.h"

#import "NAVELPerson.h"

@interface NAVELAppDelegate () <UIApplicationDelegate, UIAlertViewDelegate, UITextFieldDelegate, RXUserInterfaceContextResponder>

@property (nonatomic) UIAlertView *userPrompt;

@property (nonatomic) NAVELModelController *modelController;
@property (nonatomic) RXPersistenceController *persistenceController;

@end

@implementation NAVELAppDelegate

@synthesize window = _window;

-(void)applicationDidFinishLaunching:(UIApplication *)application {
	self.persistenceController = [RXPersistenceController new];
	
	bool online = NO;
	NSURL *baseURL = online?
		[NSURL URLWithString:@"https://api.github.com/"]
	:	[[NSBundle mainBundle] URLForResource:@"static-api" withExtension:nil];
	
	RXResourceController *resourceController = [[RXResourceController alloc] initWithBaseURL:baseURL];
	
	self.modelController = [[NAVELModelController alloc] initWithResourceController:resourceController persistenceController:self.persistenceController];
}


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


#pragma mark RXModelClientResponder

-(void)requestUserInterfaceContext:(id<RXRequester>)requester {
	[requester acceptResponse:self.persistenceController.userInterfaceContext];
}

@end
