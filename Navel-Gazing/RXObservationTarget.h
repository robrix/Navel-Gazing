//  Copyright (c) 2013 Rob Rix. All rights reserved.

@import Foundation;

#import "RXMemoDependency.h"

@interface RXObservationTarget : NSObject <RXMemoDependency>

+(instancetype)targetWithObject:(id)object keyPath:(NSString *)keyPath;

@end
