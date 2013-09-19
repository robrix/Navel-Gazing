//  Copyright (c) 2013 Rob Rix. All rights reserved.

@import Foundation;

@protocol RXModelClient <NSObject>

@property (nonatomic) NSManagedObjectContext *context;

@end

@protocol RXModelClientResponder <NSObject>

-(IBAction)modelClientDidLoad:(id<RXModelClient>)modelClient;

@end
