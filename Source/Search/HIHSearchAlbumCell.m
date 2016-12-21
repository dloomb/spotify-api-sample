//
//  HIHSearchAlbumCell.m
//  InterviewHomework
//
//  Created by Daniel Loomb on 12/20/16.
//  Copyright © 2016 Daniel Loomb. All rights reserved.
//

#import "HIHSearchAlbumCell.h"

@interface HIHSearchAlbumCell()



@end


@implementation HIHSearchAlbumCell

- (void)awakeFromNib {
	[super awakeFromNib];
	
	self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 2;
	self.imageView.clipsToBounds = true;
	
	self.shadowView.layer.cornerRadius = self.imageView.frame.size.width / 2;
	self.shadowView.layer.shadowColor = [UIColor whiteColor].CGColor;
	self.shadowView.layer.shadowOffset = CGSizeMake(0, 2);
	self.shadowView.layer.shadowRadius = 5.0;
	self.shadowView.layer.shadowOpacity = 0.5;
}

@end
