//  Copyright (c) 2013 Rob Rix. All rights reserved.

#import "RXMemo.h"

@interface RXMemo ()

@property (nonatomic) bool needsEvaluation;

@property (nonatomic, readonly) id(^block)(id target);

@end

@implementation RXMemo

+(instancetype)memoWithTarget:(id)target block:(id(^)(id target))block; {
	return [[self alloc] initWithTarget:target block:block];
}

-(instancetype)initWithTarget:(id)target block:(id(^)(id target))block {
	if ((self = [super init])) {
		_target = target;
		_block = [block copy];
		_needsEvaluation = YES;
	}
	return self;
}


-(void)invalidate {
	self.needsEvaluation = YES;
}


-(void)evaluate {
	if (self.needsEvaluation) {
		_value = self.block(self.target);
		self.needsEvaluation = NO;
	}
}


@synthesize value = _value;

-(id)value {
	[self evaluate];
	return _value;
}

@end
