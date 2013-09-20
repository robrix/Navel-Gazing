//  Copyright (c) 2013 Rob Rix. All rights reserved.

#import "NAVELModelController.h"
#import "RXPersistenceController.h"
#import "RXResourceController.h"

#import "NAVELPerson.h"

@interface NAVELModelController ()

@property (nonatomic, readonly) RXResourceController *resourceController;
@property (nonatomic, readonly) RXPersistenceController *persistenceController;

@end

@implementation NAVELModelController

-(instancetype)initWithResourceController:(RXResourceController *)resourceController persistenceController:(RXPersistenceController *)persistenceController {
	if ((self = [super init])) {
		_resourceController = resourceController;
		_persistenceController = persistenceController;
	}
	return self;
}

-(RXPromise *)promiseForUserWithName:(NSString *)userName {
	RXPromise *details = [[[self.resourceController resourceAtRelativePath:@"users"] resourceAtRelativePath:userName] promiseForContents];
	
	RXMonadPipeline([[[self.resourceController resourceAtRelativePath:@"users"] resourceAtRelativePath:userName] promiseForContents], @[]);
	
	RXPromise *JSON = [details then:^(RXPromise *resolver, NSData *data) {
		[resolver fulfillWithObject:[NSJSONSerialization JSONObjectWithData:data options:0 error:NULL]];
	}];
	
	return [JSON then:^(RXPromise *resolver, NSDictionary *details) {
		[self.persistenceController performBackgroundOperationWithBlock:^(NSManagedObjectContext *context) {
			NAVELPerson *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:context];
			person.userName = userName;
			person.name = details[@"name"];
			person.emailAddress = details[@"email"];
			person.avatarURLString = details[@"avatar_url"];
			
			[[self.persistenceController persistChangesInContext:context] then:^(RXPromise *resolver, id object) {
				[resolver fulfillWithObject:person];
			}];
		}];
	}];
}

@end
