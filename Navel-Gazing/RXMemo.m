//  Copyright (c) 2013 Rob Rix. All rights reserved.

#import "RXMemo.h"

@interface RXMemo ()

@property (nonatomic) bool needsEvaluation;

@property (nonatomic, readonly) id(^block)();

@end

@implementation RXMemo

+(instancetype)memoWithBlock:(id (^)(void))block {
	return [[self alloc] initWithBlock:block];
}

-(instancetype)initWithBlock:(id(^)(void))block {
	if ((self = [super init])) {
		_block = [block copy];
		_needsEvaluation = YES;
	}
	return self;
}

-(void)invalidate {
	self.needsEvaluation = YES;
}


@synthesize value = _value;

-(id)value {
	if (self.needsEvaluation) {
		_value = self.block();
		self.needsEvaluation = NO;
	}
	return _value;
}

@end
