//  Copyright (c) 2013 Rob Rix. All rights reserved.

#import "UIView+RXModelMapping.h"

@implementation UIView (RXModelMapping)

-(void)updateWithModelObject:(id)object {
	[self doesNotRecognizeSelector:_cmd];
}

-(void)cancelUpdating {}

@end

@implementation UILabel (RXModelMapping)

-(void)updateWithModelObject:(id)object {
	self.text = object;
}

@end

@implementation UIImageView (RXModelMapping)

-(void)updateWithModelObject:(id)object {
	self.image = object;
}

@end
