//  Copyright (c) 2013 Rob Rix. All rights reserved.

#import "NAVELViewPerson.h"
#import "NAVELPerson.h"

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

@end
