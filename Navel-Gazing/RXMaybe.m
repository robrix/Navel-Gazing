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

-(id<RXMonad>)bind:(RXMonadUnitFunction)block {
	return block(self.object);
}


#pragma mark RXMaybe

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

+(instancetype)nothing:(NSError *)error {
	return error? [[self alloc] initWithError:error] : [self nothing];
}

-(instancetype)initWithError:(NSError *)error {
	if ((self = [super init])) {
		_error = error;
	}
	return self;
}


#pragma mark RXMonad

+(instancetype)unit:(NSError *)error {
	return [self nothing:error];
}

-(id<RXMaybe>)bind:(RXMaybeBlock)block {
	return self;
}


#pragma mark RXMaybe

-(id<RXMaybe>)then:(RXMaybeBlock)block {
	return self;
}

-(id<RXMaybe>)else:(RXMaybeBlock)block {
	return block(self.error);
}

@end


id<RXMaybe> RXMaybeObject(RXMaybeObjectBlock block) {
	NSError *error;
	id object = block(&error);
	return object?
		[RXJust just:object]
	:	[RXNothing nothing:error];
}
