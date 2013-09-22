//  Copyright (c) 2013 Rob Rix. All rights reserved.

#import "NAVELViewPerson.h"
#import "NAVELPerson.h"

#import "RXMaybe.h"

@interface NAVELViewPerson ()

@property (nonatomic, readonly) NAVELPerson *person;

@end

@implementation NAVELViewPerson

@synthesize modelObject = _modelObject;

-(NAVELPerson *)person {
	return self.modelObject;
}


-(NSString *)name {
	return self.person.name ?: self.person.userName;
}

-(RXPromise *)promisedAvatar {
	return self.person.avatarURL?
		[[RXPromise promiseForContentsOfURL:self.person.avatarURL] then:^(RXPromise *avatar, id<RXMaybe> maybeData) {
			[maybeData then:^id(NSData *data) {
				[avatar fulfillWithObject:[[UIImage alloc] initWithData:data]];
				return nil;
			}];
		}]
	:	nil;
}

@end
