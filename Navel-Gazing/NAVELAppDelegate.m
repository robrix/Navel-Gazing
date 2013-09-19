//  Copyright (c) 2013 Rob Rix. All rights reserved.

#import "NAVELAppDelegate.h"

#import "RXPersistenceController.h"
#import "RXPromise.h"
#import "RXResponse.h"

#import "NAVELPerson.h"

@interface NAVELAppDelegate () <UIApplicationDelegate, UIAlertViewDelegate, UITextFieldDelegate, RXUserInterfaceContextResponder>

@property (nonatomic) UIAlertView *userPrompt;

@property (nonatomic) RXPersistenceController *persistenceController;

@end

@implementation NAVELAppDelegate

@synthesize window = _window;

-(void)applicationDidFinishLaunching:(UIApplication *)application {
	self.persistenceController = [RXPersistenceController new];
}


-(IBAction)createUser:(id)sender {
	self.userPrompt = [[UIAlertView alloc] initWithTitle:@"Add User" message:@"Enter the name of the user to add." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
	self.userPrompt.alertViewStyle = UIAlertViewStylePlainTextInput;
	[self.userPrompt textFieldAtIndex:0].delegate = self;
	[self.userPrompt show];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	NSString *userName = [alertView textFieldAtIndex:0].text;
	id<RXPromise> details = RXPromiseForContentsOfURL([[NSURL URLWithString:@"https://api.github.com/users/"] URLByAppendingPathComponent:userName]);
	
	id<RXPromise> JSON = [details then:^(RXPromiseResolver *resolver, NSData *data) {
		[resolver fulfillWithObject:[NSJSONSerialization JSONObjectWithData:data options:0 error:NULL]];
	}];
	
	[JSON then:^(RXPromiseResolver *resolver, NSDictionary *details) {
		[self.persistenceController performOperationWithBlock:^(NSManagedObjectContext *context) {
			NAVELPerson *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:context];
			person.userName = userName;
			person.name = details[@"name"];
			person.emailAddress = details[@"email"];
			
			[self.persistenceController saveContext:context withCompletionHandler:^(NSError *error) {
				[resolver fulfillWithObject:person];
			}];
		}];
	}];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
	[self.userPrompt dismissWithClickedButtonIndex:[self.userPrompt firstOtherButtonIndex] animated:YES];
}


#pragma mark RXModelClientResponder

-(void)requestUserInterfaceContext:(id<RXRequester>)requester {
	[requester acceptResponse:self.persistenceController.userInterfaceContext];
}

@end
