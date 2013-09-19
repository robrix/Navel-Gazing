//  Copyright (c) 2013 Rob Rix. All rights reserved.

#import "NAVELPerson.h"
#import "NAVELCommit.h"
#import "NAVELRepository.h"

@implementation NAVELPerson

@dynamic emailAddress;
@dynamic name;
@dynamic userName;
@dynamic commits;
@dynamic repositories;
@dynamic insertionDate;

-(void)awakeFromInsert {
	[super awakeFromInsert];
	
	self.insertionDate = [NSDate date];
}

@end
