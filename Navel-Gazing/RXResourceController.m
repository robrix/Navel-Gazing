//  Copyright (c) 2013 Rob Rix. All rights reserved.

#import "RXResourceController.h"

@interface RXResourceController ()

@property (nonatomic, readonly) NSURL *URL;
@property (nonatomic, weak, readonly) RXResourceController *parentResourceController;

@end

@implementation RXResourceController

-(instancetype)initWithURL:(NSURL *)URL parentResourceController:(RXResourceController *)parentResourceController {
	if ((self = [super init])) {
		_URL = URL.absoluteURL.standardizedURL;
		_parentResourceController = parentResourceController;
	}
	return self;
}

-(instancetype)initWithURL:(NSURL *)URL {
	return  [self initWithURL:URL parentResourceController:nil];
}

-(instancetype)subresourceWithPath:(NSString *)resource {
	return [[self.class alloc] initWithURL:[self.URL URLByAppendingPathComponent:resource] parentResourceController:self];
}

-(RXPromise *)promiseForContents {
	NSURLRequest *request = [self URLRequestWithURL:self.URL];
	return request?
		[RXPromise promiseForContentsOfURLRequest:request]
	:	[RXPromise promiseForContentsOfURL:self.URL];
}


-(NSURLRequest *)URLRequestWithURL:(NSURL *)URL {
	NSMutableURLRequest *request = [self.URLRequestTemplate mutableCopy];
	request.URL = URL;
	NSString *accept = [request valueForHTTPHeaderField:@"Accept"];
	if (self.URL.isFileURL && [accept rangeOfString:@"application/json"].length > 0)
		request.URL = [request.URL URLByAppendingPathExtension:@"json"];

	return request;
}

-(NSURLRequest *)URLRequestTemplate {
	return _URLRequestTemplate ?: self.parentResourceController.URLRequestTemplate;
}

@end
