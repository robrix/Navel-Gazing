//  Copyright (c) 2013 Rob Rix. All rights reserved.

#import "RXViewModel.h"
#import "RXPromise.h"

@interface NAVELViewPerson : NSObject <RXViewModel>

@property (nonatomic, readonly) NSString *name;

@property (nonatomic, readonly) id<RXPromise> promisedAvatar;

@end
