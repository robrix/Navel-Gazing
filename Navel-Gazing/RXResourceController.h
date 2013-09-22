//  Copyright (c) 2013 Rob Rix. All rights reserved.

@import Foundation;

#import "RXPromise.h"

@interface RXResourceController : NSObject

-(instancetype)initWithURL:(NSURL *)URL;

-(instancetype)subresourceWithPath:(NSString *)resource;

-(RXPromise *)promiseForContents;

@property (nonatomic) NSURLRequest *URLRequestTemplate;

@end
