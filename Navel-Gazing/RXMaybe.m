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

-(id)then:(RXMaybeThenBlock)block {
	return [self then:block else:nil];
}

-(id)else:(RXMaybeElseBlock)block {
	return self;
}

-(id)then:(RXMaybeThenBlock)thenBlock else:(RXMaybeElseBlock)elseBlock {
	return thenBlock? thenBlock(self.object) : self;
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

-(id<RXMonad>)bind:(RXMonadUnitFunction)block {
	return self;
}


#pragma mark RXMaybe

-(id)then:(RXMaybeThenBlock)thenBlock else:(RXMaybeElseBlock)elseBlock {
	return elseBlock? elseBlock(self.error) : self;
}

-(id)then:(RXMaybeThenBlock)block {
	return self;
}

-(id)else:(RXMaybeElseBlock)block {
	return [self then:nil else:block];
}

@end


id<RXMaybe> RXMaybeObject(RXMaybeObjectBlock block) {
	NSError *error;
	id object = block(&error);
	return object?
		[RXJust just:object]
	:	[RXNothing nothing:error];
}

id<RXMaybe> RXMaybeBoolean(RXMaybeBooleanBlock block) {
	return RXMaybeObject(^id(NSError *__autoreleasing *error) {
		bool result = block(error);
		return result? @YES : nil;
	});
}
