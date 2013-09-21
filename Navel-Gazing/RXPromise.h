//  Copyright (c) 2013 Rob Rix. All rights reserved.

@import Foundation;

#import "RXMonad.h"

@class RXPromise;
typedef void(^RXPromiseThenBlock)(RXPromise *promise, id object);
typedef RXPromise *(^RXPromiseUnitFunction)(id x);

@interface RXPromise : NSObject <RXMonad>

+(instancetype)promiseForContentsOfURLRequest:(NSURLRequest *)request;
+(instancetype)promiseForContentsOfURL:(NSURL *)URL;

+(instancetype)promiseWithObject:(id)object;

-(instancetype)then:(RXPromiseThenBlock)block;
-(RXPromise *)bind:(RXPromiseUnitFunction)block;

/**
 Cancels the observation of this promise. Its block (if any) will not be called.
 */
-(void)cancel;

-(void)fulfillWithObject:(id)object;

@end
