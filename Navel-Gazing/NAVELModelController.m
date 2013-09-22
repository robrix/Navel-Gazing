//  Copyright (c) 2013 Rob Rix. All rights reserved.

#import "NAVELModelController.h"
#import "RXPersistenceController.h"
#import "RXResourceController.h"
#import "RXMaybe.h"

#import "NAVELPerson.h"
#import "NAVELRepository.h"

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


RXPromiseUnitFunction NAVELPromiseToDecodeJSONFunction = ^(id<RXMaybe> maybeData) {
	return [RXPromise promiseWithObject:[maybeData bind:^id<RXMonad>(NSData *data) {
		NSError *error;
		id JSONObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
		return JSONObject? [RXJust just:JSONObject] : [RXNothing nothing:error];
	}]];
};

-(RXPromise *)promiseForUserWithName:(NSString *)userName {
	return [self loadResource:[[self.resourceController subresourceWithPath:@"users"] subresourceWithPath:userName] andProcessWithBlock:^(NSDictionary *details, NSManagedObjectContext *context) {
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
	}];
}

-(RXPromise *)promiseForRepositoriesForUser:(NAVELPerson *)user {
	NSManagedObjectID *userID = [user objectID];
	return [self loadResource:[[[self.resourceController subresourceWithPath:@"users"] subresourceWithPath:user.userName] subresourceWithPath:@"repos"] andProcessWithBlock:^(NSArray *repositoriesJSON, NSManagedObjectContext *context) {
		NAVELPerson *user = (NAVELPerson *)[context existingObjectWithID:userID error:NULL];
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"Repository" inManagedObjectContext:context];
		
		NSEnumerator *localRepositories = [[user.repositories sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]] objectEnumerator];
		NSEnumerator *remoteRepositories = [[repositoriesJSON sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]] objectEnumerator];
		
		NAVELRepository *local = [localRepositories nextObject];
		NSDictionary *remote = [remoteRepositories nextObject];
		while (local ?: remote) {
			NSComparisonResult order = NSOrderedSame;
			order = !local? NSOrderedAscending : order;
			order = !remote? NSOrderedDescending : order;
			order = order ?: [(NSString *)remote[@"name"] compare:local.name];
			switch (order) {
				case NSOrderedAscending:
					local = [[NAVELRepository alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
					local.owner = user;
					local.name = remote[@"name"];
					local.URLString = remote[@"url"];
					local = nil;
					
				case NSOrderedSame:
					remote = [remoteRepositories nextObject];
					break;
					
				case NSOrderedDescending:
					[context deleteObject:local];
					break;
			}
			
			if (order != NSOrderedAscending) {
				local = [localRepositories nextObject];
			}
		}
	}];
}

-(RXPromise *)loadResource:(RXResourceController *)resource andProcessWithBlock:(void(^)(id JSON, NSManagedObjectContext *context))block {
	return RXMonadPipeline([resource promiseForContents], @[NAVELPromiseToDecodeJSONFunction,
															^(id<RXMaybe> maybeJSON){
		RXPromise *saved = [RXPromise new];
		
		[maybeJSON then:^id(id JSON) {
			[[self.persistenceController performBackgroundOperationWithBlock:^RXPromise *(NSManagedObjectContext *context) {
				block(JSON, context);
				
				return [self.persistenceController persistChangesInContext:context];
			}] bind:^RXPromise *(id x) {
				[saved fulfillWithObject:x];
				return nil;
			}];
			return nil;
		}];
		
		return saved;
	}]);
}

@end
