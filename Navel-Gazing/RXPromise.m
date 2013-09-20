//  Copyright (c) 2013 Rob Rix. All rights reserved.

#import "RXPromise.h"

@interface RXDependentPromise : RXPromiseResolver

-(instancetype)initWithDependency:(id<RXPromise>)parent block:(RXPromiseThenBlock)block;

-(void)observeFulfillmentOfDependencyWithObject:(id)object;

@end


@interface RXPromiseResolver () <RXPromise>

@property (nonatomic, readonly) dispatch_queue_t queue;

@property (nonatomic) NSMutableSet *dependants;

-(void)cancelSerialized;

@property (nonatomic, getter = isFulfilled) bool fulfilled;

@property (nonatomic) id object;

@end

@implementation RXPromiseResolver

-(instancetype)init {
	if ((self = [super init])) {
		_queue = dispatch_queue_create("com.antitypical.RXPromise", DISPATCH_QUEUE_SERIAL);
		
		_dependants = [NSMutableSet new];
	}
	return self;
}


-(id<RXPromise>)promise {
	return self;
}


#pragma mark Closure

-(instancetype)then:(RXPromiseThenBlock)block {
	RXDependentPromise *dependant = [[RXDependentPromise alloc] initWithDependency:self block:block];
	dispatch_async(self.queue, ^{
		[self.dependants addObject:dependant];
		
		if (self.isFulfilled) {
			[dependant observeFulfillmentOfDependencyWithObject:self.object];
		}
	});
	return dependant;
}


#pragma mark Cancellation

-(void)cancelSerialized {
	self.fulfilled = NO;
	self.dependants = nil;
	self.object = nil;
}

-(void)cancel {
	dispatch_sync(self.queue, ^{
		[self cancelSerialized];
	});
}


#pragma mark Fulfillment

-(void)fulfillWithObject:(id)object {
	dispatch_async(self.queue, ^{
		self.fulfilled = YES;
		
		self.object = object;
		
		for (RXDependentPromise *dependant in self.dependants) {
			[dependant observeFulfillmentOfDependencyWithObject:object];
		}
		
		self.dependants = nil;
	});
}


#pragma mark RXMonad

+(instancetype)unit:(id)value {
	return nil;
}

-(id<RXMonad>)bind:(RXMonadUnitFunction)block {
	return [self then:^(RXPromiseResolver *resolver, id object) {
		[block(object) bind:^id<RXMonad>(id value) {
			[resolver fulfillWithObject:value];
			return resolver.promise;
		}];
	}];
}

@end


@interface RXDependentPromise ()

@property (nonatomic, weak) id<RXPromise> dependency;
@property (nonatomic, copy) RXPromiseThenBlock block;

@end

@implementation RXDependentPromise

-(instancetype)initWithDependency:(id<RXPromise>)dependency block:(RXPromiseThenBlock)block {
	if ((self = [super init])) {
		_dependency = dependency;
		
		_block = [block copy];
	}
	return self;
}


-(void)cancelSerialized {
	[super cancelSerialized];
	
	self.block = nil;
}

-(void)observeFulfillmentOfDependencyWithObject:(id)object {
	dispatch_async(self.queue, ^{
		if (self.block) {
			self.block(self, object);
		}
		self.block = nil;
	});
}

@end


id<RXPromise> RXPromiseForContentsOfURL(NSURL *URL) {
	RXPromiseResolver *resolver = [RXPromiseResolver new];
	NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:URL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
		[resolver fulfillWithObject:data];
	}];
	[task resume];
	return resolver.promise;
}
