//  Copyright (c) 2013 Rob Rix. All rights reserved.

#import "RXMemo.h"

@interface RXMemo ()

@property (nonatomic) bool needsEvaluation;
@property (nonatomic, getter = isEvaluating) bool evaluating;

@property (nonatomic, readonly) id(^block)(id target);

@end

@implementation RXMemo

+(instancetype)memoWithTarget:(id)target ignoreNilValues:(bool)ignoresNilValues block:(id(^)(id target))block {
	return [[self alloc] initWithTarget:target ignoreNilValues:ignoresNilValues block:block];
}

+(instancetype)memoWithTarget:(id)target block:(id(^)(id target))block; {
	return [self memoWithTarget:target ignoreNilValues:YES block:block];
}

-(instancetype)initWithTarget:(id)target ignoreNilValues:(bool)ignoresNilValues block:(id(^)(id target))block {
	if ((self = [super init])) {
		_target = target;
		_ignoresNilValues = ignoresNilValues;
		_block = [block copy];
		_needsEvaluation = YES;
	}
	return self;
}

-(void)dealloc {
	self.dependencies = nil;
}


#pragma mark Dependencies

static void *RXMemoObservationContext = &RXMemoObservationContext;

-(void)setDependencies:(NSArray *)dependencies {
	if (![_dependencies isEqual:dependencies]) {
		for (id<RXMemoDependency> dependency in _dependencies) {
			[dependency removeObserver:self context:RXMemoObservationContext];
		}
		
		_dependencies = [dependencies copy];
		
		for (id<RXMemoDependency> dependency in _dependencies) {
			[dependency addObserver:self context:RXMemoObservationContext];
		}
	}
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if (context == RXMemoObservationContext)
		[self invalidate];
	else
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}


#pragma mark Invalidation

-(void)invalidate {
	self.needsEvaluation = YES;
	if (self.isGreedy) {
		[self evaluate];
	}
}


#pragma mark Evaluation

-(void)evaluate {
	if (!self.isEvaluating && self.needsEvaluation) {
		self.evaluating = YES;
		[self willChangeValueForKey:@"value"];
		_value = self.block(self.target);
		[self didChangeValueForKey:@"value"];
		
		self.needsEvaluation = (!self.ignoresNilValues) || (_value == nil);
		self.evaluating = NO;
	}
}


@synthesize value = _value;

-(id)value {
	[self evaluate];
	return _value;
}


#pragma mark RXMemoDependency

-(void)addObserver:(id)observer context:(void *)context {
	[self addObserver:observer forKeyPath:@"value" options:0 context:context];
}

-(void)removeObserver:(id)observer context:(void *)context {
	[self removeObserver:observer forKeyPath:@"value" context:context];
}

@end
