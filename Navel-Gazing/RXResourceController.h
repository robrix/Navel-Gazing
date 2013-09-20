//  Copyright (c) 2013 Rob Rix. All rights reserved.

@import Foundation;

#import "RXPromise.h"

@interface RXResourceController : NSObject

-(instancetype)initWithBaseURL:(NSURL *)URL;

-(instancetype)resourceAtRelativePath:(NSString *)resource;

-(RXPromise *)promiseForContents;

@end
