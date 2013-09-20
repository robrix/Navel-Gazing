//  Copyright (c) 2013 Rob Rix. All rights reserved.

@import Foundation;

#pragma mark Types

@protocol RXMonad;

typedef id<RXMonad> (^RXMonadUnitFunction)(id x);
typedef id<RXMonad> (^RXMonadBindFunction)(id<RXMonad> m, RXMonadUnitFunction f);

typedef id<RXMonad> (^RXUnaryMonadBlock)(id<RXMonad> monad);
typedef id (^RXFunctionBlock)(id object);
typedef RXFunctionBlock RXUnaryFunctionBlock;;
typedef id (^RXBinaryFunctionBlock)(id a, id b);
typedef id<RXMonad> (^RXBinaryMonadBlock)(id<RXMonad> a, id<RXMonad> b);


typedef struct RXMonadicType {
	__unsafe_unretained RXMonadUnitFunction unit;
	__unsafe_unretained RXMonadBindFunction bind;
} RXMonadicType;


@protocol RXMonad <NSObject>

+(instancetype)unit:(id)object;

-(id<RXMonad>)bind:(RXMonadUnitFunction)block;

@end


extern RXFunctionBlock RXIdentityBlock;


#pragma mark Identity

extern const RXMonadicType RXIdentity;


#pragma mark Generic functions

extern id<RXMonad> RXMonadJoin(id<RXMonad> monad);
extern RXUnaryMonadBlock RXMonadFunctionMap(Class<RXMonad> type, RXFunctionBlock block);

extern id<RXMonad> RXMonadPipeline(id<RXMonad> monad, NSArray *functions);
extern id<RXMonad> RXMonadRecurse(id<RXMonad> m, RXMonadUnitFunction f);
extern id<RXMonad> RXMonadRecurseWhile(id<RXMonad> m, bool(^predicate)(id x), RXMonadUnitFunction f);

extern RXBinaryMonadBlock RXMonadLiftBinary(Class<RXMonad> type, RXBinaryFunctionBlock block);
