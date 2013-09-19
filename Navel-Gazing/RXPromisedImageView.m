//  Copyright (c) 2013 Rob Rix. All rights reserved.

#import "RXPromisedImageView.h"

#import "RXModelView.h"

@interface RXPromisedImageView () <RXModelView>
@end

@implementation RXPromisedImageView

-(void)setPromisedImage:(id<RXPromise>)promisedImage {
	if (_promisedImage != promisedImage) {
		[_promisedImage cancel];
		
		_promisedImage = [promisedImage then:^(RXPromiseResolver *resolver, UIImage *image) {
			[[NSOperationQueue mainQueue] addOperationWithBlock:^{
				_promisedImage = nil;
				[resolver fulfillWithObject:self.image = image];
			}];
		}];
	}
}


#pragma mark RXModelView

-(void)updateWithModelObject:(id)object {
	self.promisedImage = object;
}

-(void)cancelUpdating {
	[self.promisedImage cancel];
	self.promisedImage = nil;
}

@end
