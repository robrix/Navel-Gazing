//  Copyright (c) 2013 Rob Rix. All rights reserved.

#import "RXPromise.h"
#import "RXResponse.h"

@class NAVELPerson;

@class RXPersistenceController, RXResourceController;

@interface NAVELModelController : NSObject

-(instancetype)initWithResourceController:(RXResourceController *)resourceController persistenceController:(RXPersistenceController *)persistenceController;

@property (nonatomic, readonly) NSManagedObjectContext *userInterfaceContext;

-(RXPromise *)promiseForUserWithName:(NSString *)userName;

-(RXPromise *)promiseForRepositoriesForUser:(NAVELPerson *)user;

@end


@protocol NAVELModelControllerResponder <NSObject>

-(IBAction)respondWithModelController:(id<RXRequester>)sender;

@end
