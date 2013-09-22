//  Copyright (c) 2013 Rob Rix. All rights reserved.

@import UIKit;

@protocol RXRequester <NSObject>

-(void)acceptResponse:(id)object;

@end

@protocol RXUserInterfaceContextResponder <NSObject>

-(IBAction)respondWithUserInterfaceContext:(id<RXRequester>)requester;

@end


#if DEBUG

@protocol RXFirstResponder <NSObject>

-(IBAction)respondWithFirstResponder:(id<RXRequester>)sender;

@end

#endif


extern id RXResponseToMessage(SEL selector, UIResponder *nextResponder);
