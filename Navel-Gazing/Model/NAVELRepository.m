//  Copyright (c) 2013 Rob Rix. All rights reserved.

#import "NAVELRepository.h"
#import "NAVELBranch.h"
#import "NAVELPerson.h"

@interface NAVELRepository ()

@property (nonatomic) NSString *urlString;

@end

@implementation NAVELRepository

@dynamic name;
@dynamic urlString;
@dynamic branches;
@dynamic owner;

-(NSURL *)URL {
	return self.urlString? [NSURL URLWithString:self.urlString] : nil;
}

-(void)setURL:(NSURL *)URL {
	self.urlString = [URL description];
}

@end
