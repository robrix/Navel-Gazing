//  Copyright (c) 2013 Rob Rix. All rights reserved.

#import "NAVELModelController.h"
#import "RXPersistenceController.h"

#import "NAVELPerson.h"

@interface NAVELModelController ()

@property (nonatomic) RXPersistenceController *persistenceController;

@end

@implementation NAVELModelController

-(instancetype)initWithPersistenceController:(RXPersistenceController *)persistenceController {
	if ((self = [super init])) {
		_persistenceController = persistenceController;
	}
	return self;
}

-(id<RXPromise>)promiseForUserWithName:(NSString *)userName {
	id<RXPromise> details = RXPromiseForContentsOfURL([[NSURL URLWithString:@"https://api.github.com/users/"] URLByAppendingPathComponent:userName]);
	
	id<RXPromise> JSON = [details then:^(RXPromiseResolver *resolver, NSData *data) {
		[resolver fulfillWithObject:[NSJSONSerialization JSONObjectWithData:data options:0 error:NULL]];
	}];
	
	return [JSON then:^(RXPromiseResolver *resolver, NSDictionary *details) {
		[self.persistenceController performBackgroundOperationWithBlock:^(NSManagedObjectContext *context) {
			NAVELPerson *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:context];
			person.userName = userName;
			person.name = details[@"name"];
			person.emailAddress = details[@"email"];
			person.avatarURLString = details[@"avatar_url"];
			
			[[self.persistenceController persistChangesInContext:context] then:^(RXPromiseResolver *resolver, id object) {
				[resolver fulfillWithObject:person];
			}];
		}];
	}];
}

@end
