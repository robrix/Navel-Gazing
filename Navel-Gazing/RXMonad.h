//  Copyright (c) 2013 Rob Rix. All rights reserved.

@import Foundation;

#pragma mark Types

@protocol RXMonad;

typedef id<RXMonad> (^RXMonadBlock)(id value);
typedef id<RXMonad> (^RXUnaryMonadBlock)(id<RXMonad> monad);
typedef id (^RXFunctionBlock)(id object);
typedef RXFunctionBlock RXUnaryFunctionBlock;;
typedef id (^RXBinaryFunctionBlock)(id a, id b);
typedef id<RXMonad> (^RXBinaryMonadBlock)(id<RXMonad> a, id<RXMonad> b);

extern RXFunctionBlock RXIdentityBlock;


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
extern RXUnaryMonadBlock RXMonadFunctionMap(Class<RXMonad> type, RXFunctionBlock block);

extern id<RXMonad> RXMonadPipeline(id<RXMonad> monad, NSArray *functions);

extern RXBinaryMonadBlock RXMonadLiftBinary(Class<RXMonad> type, RXBinaryFunctionBlock block);
