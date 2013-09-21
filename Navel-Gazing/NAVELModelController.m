//  Copyright (c) 2013 Rob Rix. All rights reserved.

#import "NAVELModelController.h"
#import "RXPersistenceController.h"
#import "RXResourceController.h"
#import "RXMaybe.h"

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


-(NSManagedObjectContext *)userInterfaceContext {
	return self.persistenceController.userInterfaceContext;
}


-(RXPromise *)promiseForUserWithName:(NSString *)userName {
	RXPromise *details = [[[self.resourceController subresourceWithPath:@"users"] subresourceWithPath:userName] promiseForContents];
	
	RXPromise *JSON = [details bind:^RXPromise *(id<RXMaybe> maybeData) {
		return [RXPromise promiseWithObject:[maybeData bind:^id<RXMonad>(NSData *data) {
			NSError *error;
			id JSONObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
			return JSONObject? [RXJust just:JSONObject] : [RXNothing nothing:error];
		}]];
	}];
	
	return [JSON bind:^RXPromise *(id<RXMaybe> maybeDetails) {
		RXPromise *finishedSaving;
		[maybeDetails bind:^id<RXMonad>(NSDictionary *details) {
			[[self.persistenceController performBackgroundOperationWithBlock:^RXPromise *(NSManagedObjectContext *context) {
				RXPromise *save = [RXPromise new];
				NSEntityDescription *entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:context];
				
				NSFetchRequest *extantRequest = [NSFetchRequest new];
				extantRequest.entity = entity;
				extantRequest.predicate = [NSPredicate predicateWithFormat:@"userName = %@", userName];
				extantRequest.fetchLimit = 1;
				
				NAVELPerson *person =
					[context executeFetchRequest:extantRequest error:NULL].firstObject
				?:	[[NAVELPerson alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
				person.userName = userName;
				person.name = details[@"name"];
				person.emailAddress = details[@"email"];
				person.avatarURLString = details[@"avatar_url"];
				
				[[self.persistenceController persistChangesInContext:context] bind:^RXPromise *(id x) {
					[save fulfillWithObject:x];
					return nil;
				}];
				return save;
			}] bind:^RXPromise *(id x) {
				[finishedSaving fulfillWithObject:x];
				return nil;
			}];
			return nil;
		}];
		return  finishedSaving;
	}];
}

@end
