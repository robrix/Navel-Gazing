//  Copyright (c) 2013 Rob Rix. All rights reserved.

#import "RXResourceController.h"

@interface RXResourceController ()

@property (nonatomic, readonly) NSURL *baseURL;

@end

@implementation RXResourceController

-(instancetype)initWithBaseURL:(NSURL *)URL {
	if ((self = [super init])) {
		_baseURL = URL;
	}
	return self;
}

-(instancetype)resourceAtRelativePath:(NSString *)resource {
	return [[self.class alloc] initWithBaseURL:[NSURL URLWithString:resource relativeToURL:self.baseURL]];
}

-(RXPromise *)promiseForContents {
	return [RXPromise promiseForContentsOfURL:self.baseURL];
}

@end
