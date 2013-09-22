//  Copyright (c) 2013 Rob Rix. All rights reserved.

@import Foundation;

@protocol RXMemoDependency <NSObject>

-(void)addObserver:(id)observer context:(void *)context;
-(void)removeObserver:(id)observer context:(void *)context;

@end
