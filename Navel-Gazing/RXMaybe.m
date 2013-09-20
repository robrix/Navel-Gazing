//  Copyright (c) 2013 Rob Rix. All rights reserved.

#import "RXMaybe.h"

@implementation RXJust

+(instancetype)just:(id)object {
	return [[self alloc] initWithObject:object];
}

-(instancetype)initWithObject:(id)object {
	if ((self = [super init])) {
		_object = object;
	}
	return self;
}

#pragma mark RXMonad

+(instancetype)unit:(id)value {
	return [self just:value];
}

-(id<RXMaybe>)bind:(RXMaybeBlock)block {
	return [self then:block];
}

-(id<RXMaybe>)then:(RXMaybeBlock)block {
	return block(self.object);
}

-(id<RXMaybe>)else:(RXMaybeBlock)block {
	return self;
}

@end


@implementation RXNothing

+(instancetype)nothing {
	static RXNothing *nothing;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		nothing = [self new];
	});
	return nothing;
}

#pragma mark RXMonad

+(instancetype)unit:(id)value {
	return [self nothing];
}

-(id<RXMaybe>)bind:(RXMaybeBlock)block {
	return self;
}

-(id<RXMaybe>)then:(RXMaybeBlock)block {
	return self;
}

-(id<RXMaybe>)else:(RXMaybeBlock)block {
	return block(self);
}

@end
