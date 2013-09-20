//  Copyright (c) 2013 Rob Rix. All rights reserved.

@import Foundation;

#import "RXMonad.h"

@protocol RXMaybe;

typedef id<RXMaybe> (^RXMaybeBlock)(id object);

@protocol RXMaybe <RXMonad>

-(id<RXMaybe>)bind:(RXMaybeBlock)block;

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
