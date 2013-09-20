//  Copyright (c) 2013 Rob Rix. All rights reserved.

#import "RXPromise.h"

@class RXPersistenceController, RXResourceController;

@interface NAVELModelController : NSObject

-(instancetype)initWithResourceController:(RXResourceController *)resourceController persistenceController:(RXPersistenceController *)persistenceController;

-(RXPromise *)promiseForUserWithName:(NSString *)userName;

@end
