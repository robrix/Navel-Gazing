//  Copyright (c) 2013 Rob Rix. All rights reserved.

#import "NAVELAppDelegate.h"

#import "NAVELModelController.h"
#import "RXPersistenceController.h"
#import "RXResourceController.h"
#import "RXPromise.h"
#import "RXResponse.h"

#import "NAVELPerson.h"

@interface NAVELAppDelegate () <UIApplicationDelegate, RXUserInterfaceContextResponder, RXUserInterfaceContextResponder, NAVELModelControllerResponder>

@property (nonatomic) UIAlertView *userPrompt;

@property (nonatomic) NAVELModelController *modelController;
@property (nonatomic) RXPersistenceController *persistenceController;

@end

@implementation NAVELAppDelegate

@synthesize window = _window;

-(void)applicationDidFinishLaunching:(UIApplication *)application {
	self.persistenceController = [RXPersistenceController new];
	
	bool online = NO;
	NSURL *URL = online?
		[NSURL URLWithString:@"https://api.github.com/"]
	:	[[NSBundle mainBundle] URLForResource:@"static-api" withExtension:nil];
	
	RXResourceController *resourceController = [[RXResourceController alloc] initWithURL:URL];
	NSMutableURLRequest *requestTemplate = [NSMutableURLRequest requestWithURL:URL];
	[requestTemplate addValue:@"application/json" forHTTPHeaderField:@"Accept"];
	resourceController.URLRequestTemplate = requestTemplate;
	
	self.modelController = [[NAVELModelController alloc] initWithResourceController:resourceController persistenceController:self.persistenceController];
}


#pragma mark RXUserInterfaceContextResponder

-(void)respondWithUserInterfaceContext:(id<RXRequester>)requester {
	[requester acceptResponse:self.persistenceController.userInterfaceContext];
}


#pragma mark NAVELModelControllerResponder

-(void)respondWithModelController:(id<RXRequester>)requester {
	[requester acceptResponse:self.modelController];
}

@end
