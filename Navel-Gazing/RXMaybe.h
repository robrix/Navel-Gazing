//  Copyright (c) 2013 Rob Rix. All rights reserved.

@import Foundation;

#import "RXMonad.h"

@protocol RXMaybe;

typedef id<RXMaybe> (^RXMaybeBindBlock)(id object);

@protocol RXMaybe <RXMonad>

-(id<RXMaybe>)bind:(RXMaybeBindBlock)block;

-(id<RXMaybe>)then:(RXMaybeBindBlock)block;
-(id<RXMaybe>)else:(RXMaybeBindBlock)block;

@end


@interface RXJust : NSObject <RXMaybe>

+(instancetype)just:(id)object;

@property (nonatomic, readonly) id object;

@end


@interface RXNothing : NSObject <RXMaybe>

+(instancetype)nothing;

@end
