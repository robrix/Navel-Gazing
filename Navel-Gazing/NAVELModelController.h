//  Copyright (c) 2013 Rob Rix. All rights reserved.

#import "RXPromise.h"
#import "RXResponse.h"

@class RXPersistenceController, RXResourceController;

@interface NAVELModelController : NSObject

-(instancetype)initWithResourceController:(RXResourceController *)resourceController persistenceController:(RXPersistenceController *)persistenceController;

@property (nonatomic, readonly) NSManagedObjectContext *userInterfaceContext;

-(RXPromise *)promiseForUserWithName:(NSString *)userName;

@end


@protocol NAVELModelControllerResponder <NSObject>

-(IBAction)respondWithModelController:(id<RXRequester>)sender;

@end
