//  Copyright (c) 2013 Rob Rix. All rights reserved.

#import "RXPromise.h"

@class RXPersistenceController;

@interface NAVELModelController : NSObject

-(instancetype)initWithPersistenceController:(RXPersistenceController *)persistenceController;

-(id<RXPromise>)promiseForUserWithName:(NSString *)userName;

@end
