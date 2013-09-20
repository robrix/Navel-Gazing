//  Copyright (c) 2013 Rob Rix. All rights reserved.

@import Foundation;

#import "RXMonad.h"

@class RXPromiseResolver;
typedef void(^RXPromiseThenBlock)(RXPromiseResolver *resolver, id object);

@protocol RXPromise <RXMonad>

-(instancetype)then:(RXPromiseThenBlock)block;

/**
 Cancels the observation of this promise. Its block (if any) will not be called.
 */
-(void)cancel;

@end


@interface RXPromiseResolver : NSObject

-(void)fulfillWithObject:(id)object;

@property (nonatomic, readonly) id<RXPromise> promise;

@end


id<RXPromise> RXPromiseForContentsOfURL(NSURL *URL);
