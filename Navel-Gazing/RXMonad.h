//  Copyright (c) 2013 Rob Rix. All rights reserved.

@import Foundation;

@protocol RXMonad;

typedef id<RXMonad> (^RXMonadBindBlock)(id value);

@protocol RXMonad <NSObject>

+(instancetype)unit:(id)value;

-(id<RXMonad>)bind:(RXMonadBindBlock)block;

@end
