//  Copyright (c) 2013 Rob Rix. All rights reserved.

#import "UIView+RXModelMapping.h"

@implementation UIView (RXModelMapping)

-(id)rx_objectValue {
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

-(void)setRx_objectValue:(id)objectValue {
	[self doesNotRecognizeSelector:_cmd];
}

@end

@implementation UILabel (RXModelMapping)

-(id)rx_objectValue {
	return self.text;
}

-(void)setRx_objectValue:(id)objectValue {
	self.text = objectValue;
}

@end

@implementation UIImageView (RXModelMapping)

-(id)rx_objectValue {
	return self.image;
}

-(void)setRx_objectValue:(id)objectValue {
	self.image = objectValue;
}

@end
