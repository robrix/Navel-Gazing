//  Copyright (c) 2013 Rob Rix. All rights reserved.

#import "RXPromise.h"
#import "RXMaybe.h"

@interface RXPromise ()

@property (nonatomic, readonly) dispatch_queue_t queue;

@property (nonatomic) NSMutableSet *observers;

@property (nonatomic, getter = isFulfilled) bool fulfilled;

@property (nonatomic) id object;

@property (nonatomic, weak, readonly) RXPromise *parent;

@end

@implementation RXPromise

+(instancetype)promiseForContentsOfURLRequest:(NSURLRequest *)request {
	RXPromise *promise = [RXPromise new];
	NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
		[promise fulfillWithObject:response? [RXJust just:data] : [RXNothing nothing:error]];
	}];
	[task resume];
	return promise;
}

+(instancetype)promiseForContentsOfURL:(NSURL *)URL {
	RXPromise *promise = [RXPromise new];
	NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:URL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
		[promise fulfillWithObject:response? [RXJust just:data] : [RXNothing nothing:error]];
	}];
	[task resume];
	return promise;
}

+(instancetype)promiseWithObject:(id)object {
	return [[self alloc] initWithObject:object];
}

-(instancetype)initWithParent:(RXPromise *)parent {
	if ((self = [self init])) {
		_parent = parent;
	}
	return self;
}

-(instancetype)initWithObject:(id)object {
	if ((self = [self init])) {
		_object = object;
		
		_fulfilled = YES;
		_observers = nil;
	}
	return self;
}

-(instancetype)init {
	if ((self = [super init])) {
		_queue = dispatch_queue_create("com.antitypical.RXPromise", DISPATCH_QUEUE_SERIAL);
		
		_observers = [NSMutableSet new];
	}
	return self;
}


#pragma mark Closure

-(instancetype)then:(RXPromiseThenBlock)block {
	return [self bind:^RXPromise *(id object) {
		RXPromise *promise = [RXPromise new];
		block(promise, object);
		return promise;
	}];
}

-(void)onComplete:(void(^)(id object))block {
	dispatch_async(self.queue, ^{
		if (self.isFulfilled) {
			block(self.object);
		} else {
			[self.observers addObject:block];
		}
	});
}


#pragma mark Cancellation

-(void)cancel {
	dispatch_sync(self.queue, ^{
		if (!self.fulfilled) {
			self.fulfilled = NO;
			self.observers = nil;
			self.object = nil;
		}
	});
}


#pragma mark Fulfillment

-(void)fulfillWithObject:(id)object {
	dispatch_async(self.queue, ^{
		self.fulfilled = YES;
		
		self.object = object;
		
		for (RXPromiseUnitFunction observer in self.observers) {
			observer(object);
		}
		
		self.observers = nil;
	});
}


#pragma mark RXMonad

+(instancetype)unit:(id)value {
	return [[self alloc] initWithObject:value];
}

-(RXPromise *)bind:(RXPromiseUnitFunction)f {
	RXPromise *output = [RXPromise new];
	[self onComplete:^(id object) {
		[f(object) onComplete:^(id object) {
			[output fulfillWithObject:object];
		}];
	}];
	
	return output;
}

@end
