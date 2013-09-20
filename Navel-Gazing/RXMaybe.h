//  Copyright (c) 2013 Rob Rix. All rights reserved.

@import Foundation;

#import "RXMonad.h"

@protocol RXMaybe;

typedef id<RXMaybe> (^RXMaybeBlock)(id object);

@protocol RXMaybe <RXMonad>

-(id<RXMaybe>)then:(RXMaybeBlock)block;
-(id<RXMaybe>)else:(RXMaybeBlock)block;

@end


@interface RXJust : NSObject <RXMaybe>

+(instancetype)just:(id)object;

@property (nonatomic, readonly) id object;

@end


@interface RXNothing : NSObject <RXMaybe>

+(instancetype)nothing;
+(instancetype)nothing:(NSError *)error;

@property (nonatomic, readonly) NSError *error;

@end

typedef id (^RXMaybeObjectBlock)(NSError * __autoreleasing *error);

/**
 Convenience for NSError ** parameter-receiving idioms returning an object.
 
 @param block A block taking a parameter of type `NSError **` and returning an object.
 @return `RXJust` wrapping the object returned by the block if non-nil, or `RXNothing` wrapping the error otherwise.
 */
extern id<RXMaybe> RXMaybeObject(RXMaybeObjectBlock block);
