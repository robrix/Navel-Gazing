//  Copyright (c) 2013 Rob Rix. All rights reserved.

@import UIKit;

@protocol RXRequester <NSObject>

-(void)acceptResponse:(id)object;

@end

@protocol RXUserInterfaceContextResponder <NSObject>

-(IBAction)requestUserInterfaceContext:(id<RXRequester>)requester;

@end


#if DEBUG

@protocol RXFirstResponder <NSObject>

-(IBAction)requestFirstResponder:(id<RXRequester>)sender;

@end

#endif


extern id RXResponseToMessage(SEL selector, UIResponder *nextResponder);
