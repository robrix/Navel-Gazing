//  Copyright (c) 2013 Rob Rix. All rights reserved.

#import "RXResponse.h"

@interface RXResponse : UIResponder <RXRequester>

@property (nonatomic) UIResponder *nextResponder;
@property (nonatomic) id object;

@end

@implementation RXResponse

@synthesize nextResponder = _nextResponder;

-(void)acceptResponse:(id)object {
	self.object = object;
}

@end

#if DEBUG

@implementation UIResponder (RXFirstResponder)

-(IBAction)respondWithFirstResponder:(id<RXRequester>)requester {
	return self.isFirstResponder?
		[requester acceptResponse:self]
	:	[self.nextResponder respondWithFirstResponder:requester];
}

@end

#endif


id RXResponseToMessage(SEL selector, UIResponder *nextResponder) {
	RXResponse *response = [RXResponse new];
	response.nextResponder = nextResponder;
	[[UIApplication sharedApplication] sendAction:selector to:nil from:response forEvent:nil];
	return response.object;
}
