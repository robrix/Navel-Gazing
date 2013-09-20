//  Copyright (c) 2013 Rob Rix. All rights reserved.

@import Foundation;

#pragma mark Types

@protocol RXMonad;

typedef id<RXMonad> (^RXMonadBlock)(id value);
typedef id<RXMonad> (^RXMonadMapBlock)(id<RXMonad> monad);
typedef id (^RXMonadFunctionBlock)(id object);

extern RXMonadFunctionBlock RXIdentityBlock;


@protocol RXMonad <NSObject>

+(instancetype)unit:(id)object;

-(id<RXMonad>)bind:(RXMonadBlock)block;

@end


#pragma mark Generic functions

//extern RXMonadBlock RXMonadBlockWithAction(id target, SEL selector);

/**
 Produces an `RXMonadBlock` encompassing the constructor for the passed type.
 */
extern RXMonadBlock RXMonadUnit(Class<RXMonad> monad);
extern id<RXMonad> RXMonadBind(id<RXMonad> monad, RXMonadBlock block);
extern id<RXMonad> RXMonadJoin(id<RXMonad> monad);

extern RXMonadMapBlock RXMonadFunctionMap(Class<RXMonad> type, RXMonadFunctionBlock block);
