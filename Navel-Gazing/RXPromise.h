//  Copyright (c) 2013 Rob Rix. All rights reserved.

@import Foundation;

#import "RXMonad.h"

@class RXPromise;
typedef void(^RXPromiseThenBlock)(RXPromise *promise, id object);

@interface RXPromise : NSObject <RXMonad>

+(instancetype)promiseForContentsOfURL:(NSURL *)URL;

-(instancetype)then:(RXPromiseThenBlock)block;

/**
 Cancels the observation of this promise. Its block (if any) will not be called.
 */
-(void)cancel;

-(void)fulfillWithObject:(id)object;

@end
