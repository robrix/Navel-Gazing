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
@dynamic avatarURLString;

-(void)awakeFromInsert {
	[super awakeFromInsert];
	
	self.insertionDate = [NSDate date];
}


-(NSURL *)avatarURL {
	return self.avatarURLString? [NSURL URLWithString:self.avatarURLString] : nil;
}

-(void)setAvatarURL:(NSURL *)avatarURL {
	self.avatarURLString = avatarURL.description;
}

@end
