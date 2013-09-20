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

-(id<RXMaybe>)bind:(RXMaybeBindBlock)block {
	return [self then:block];
}

-(id<RXMaybe>)then:(RXMaybeBindBlock)block {
	return block(self.object);
}

-(id<RXMaybe>)else:(RXMaybeBindBlock)block {
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

-(id<RXMaybe>)bind:(RXMaybeBindBlock)block {
	return self;
}

-(id<RXMaybe>)then:(RXMaybeBindBlock)block {
	return self;
}

-(id<RXMaybe>)else:(RXMaybeBindBlock)block {
	return block(self);
}

@end
