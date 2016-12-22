//
//  HIHRoundedImageView.m
//  InterviewHomework
//
//  Created by Daniel Loomb on 12/22/16.
//  Copyright © 2016 Daniel Loomb. All rights reserved.
//

#import "HIHRoundedImageView.h"

@implementation HIHRoundedImageView

- (void)awakeFromNib {
	[super awakeFromNib];
	self.clipsToBounds = true;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	self.layer.cornerRadius = CGRectGetWidth(self.frame) / 2.0;
}

@end
