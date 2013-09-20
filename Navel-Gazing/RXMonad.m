//  Copyright (c) 2013 Rob Rix. All rights reserved.

#import "RXMonad.h"

RXFunctionBlock RXIdentityBlock = ^(id x){return x;};


//RXMonadBlock RXMonadBlockWithAction(id target, SEL selector) {
//	return ^id<RXMonad>(id object){
//		return [target performSelector:selector withObject:object];
//	};
//}

RXMonadBlock RXMonadUnit(Class<RXMonad> monad) {
	return ^(id object){
		return [monad unit:object];
	};
}

id<RXMonad> RXMonadBind(id<RXMonad> monad, RXMonadBlock block) {
	return [monad bind:block];
}


id<RXMonad> RXMonadJoin(id<RXMonad> monad) {
	return [monad bind:RXIdentityBlock];
}

RXUnaryMonadBlock RXMonadFunctionMap(Class<RXMonad> type, RXFunctionBlock block) {
	return ^(id<RXMonad> monad) {
		return [monad bind:^id<RXMonad>(id value) {
			return [type unit:block(value)];
		}];
	};
}


id<RXMonad> RXMonadPipeline(id<RXMonad> monad, NSArray *functions) {
	for (RXMonadBlock block in functions) {
		monad = [monad bind:block];
	}
	return monad;
}


RXBinaryMonadBlock RXMonadLiftBinary(Class<RXMonad> type, RXBinaryFunctionBlock block) {
	return ^id<RXMonad>(id<RXMonad> ma, id<RXMonad> mb){
		return [ma bind:^id<RXMonad>(id a) {
			return [mb bind:^id<RXMonad>(id b) {
				return [type unit:block(a, b)];
			}];
		}];
	};
}
