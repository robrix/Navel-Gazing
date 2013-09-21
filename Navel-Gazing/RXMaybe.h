//  Copyright (c) 2013 Rob Rix. All rights reserved.

@import Foundation;

#import "RXMonad.h"

@protocol RXMaybe;

typedef id(^RXMaybeThenBlock)(id object);
typedef id(^RXMaybeElseBlock)(id object);

@protocol RXMaybe <RXMonad>

-(id)then:(RXMaybeThenBlock)block;
-(id)else:(RXMaybeElseBlock)block;

-(id)then:(RXMaybeThenBlock)thenBlock else:(RXMaybeElseBlock)elseBlock;

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

typedef bool (^RXMaybeBooleanBlock)(NSError * __autoreleasing *error);

/**
 Convenience for NSError ** parameter-receiving idioms returning a boolean value.
 
 @param block A block taking a parameter of type `NSError **` and returning a boolean value.
 @return `RXJust` wrapping `@YES` if the block returned YES, or `RXNothing` wrapping the error otherwise.
 */
extern id<RXMaybe> RXMaybeBoolean(RXMaybeBooleanBlock block);
