//  Copyright (c) 2013 Rob Rix. All rights reserved.

@import Foundation;

@interface RXMemo : NSObject

+(instancetype)memoWithBlock:(id(^)(void))block;

-(void)invalidate;

@property (nonatomic, readonly) id value;

@end
