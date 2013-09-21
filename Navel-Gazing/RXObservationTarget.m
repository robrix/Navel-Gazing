//  Copyright (c) 2013 Rob Rix. All rights reserved.

#import "RXObservationTarget.h"

@interface RXObservationTarget ()

@property (nonatomic, readonly) id object;
@property (nonatomic, readonly) NSString *keyPath;

@end

@implementation RXObservationTarget

+(instancetype)targetWithObject:(id)object keyPath:(NSString *)keyPath {
	return [[self alloc] initWithObject:object keyPath:keyPath];
}

-(instancetype)initWithObject:(id)object keyPath:(NSString *)keyPath {
	if ((self = [super init])) {
		_object = object;
		_keyPath = [keyPath copy];
	}
	return self;
}


#pragma mark RXMemoDependency

-(void)addObserver:(id)observer context:(void *)context {
	[self.object addObserver:observer forKeyPath:self.keyPath options:0 context:context];
}

-(void)removeObserver:(id)observer context:(void *)context {
	[self.object removeObserver:observer forKeyPath:self.keyPath context:context];
}


#pragma mark NSObject

-(bool)isEqualToObservationTarget:(RXObservationTarget *)other {
	return
		[other isKindOfClass:[RXObservationTarget class]]
	&&	(other.object == self.object)
	&&	[other.keyPath isEqualToString:self.keyPath];
}

-(BOOL)isEqual:(id)object {
	return [self isEqualToObservationTarget:object];
}

-(NSUInteger)hash {
	return self.keyPath.hash;
}

@end
