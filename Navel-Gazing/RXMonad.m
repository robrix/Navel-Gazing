//  Copyright (c) 2013 Rob Rix. All rights reserved.

#import "RXMonad.h"

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

RXMonadFunctionBlock RXIdentityBlock = ^(id x){return x;};

id<RXMonad> RXMonadJoin(id<RXMonad> monad) {
	return [monad bind:RXIdentityBlock];
}

RXMonadMapBlock RXMonadFunctionMap(Class<RXMonad> type, RXMonadFunctionBlock block) {
	return ^(id<RXMonad> monad) {
		return [monad bind:^id<RXMonad>(id value) {
			return [type unit:block(value)];
		}];
	};
}
