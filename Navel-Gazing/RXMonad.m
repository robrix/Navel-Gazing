//  Copyright (c) 2013 Rob Rix. All rights reserved.

#import "RXMonad.h"

RXFunctionBlock RXIdentityBlock = ^(id x){return x;};


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
	for (RXMonadUnitFunction block in functions) {
		monad = [monad bind:block];
	}
	return monad;
}


id<RXMonad> RXMonadRecurse(id<RXMonad> m, RXMonadUnitFunction f) {
	return RXMonadRecurseWhile(m, ^bool(id x) { return x != nil; }, f);
}

id<RXMonad> RXMonadRecurseWhile(id<RXMonad> m, bool(^predicate)(id x), RXMonadUnitFunction f) {
	return [m bind:^id<RXMonad>(id x) {
		return predicate(x)?
			RXMonadRecurseWhile(f(x), predicate, f)
		:	nil;
	}];
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


const RXMonadicType RXIdentity = {
	.unit = ^(id x){ return x; },
	.bind = ^(id<RXMonad> m, RXMonadUnitFunction f) {
		return f(m);
	}
};
