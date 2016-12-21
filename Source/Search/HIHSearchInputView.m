//
//  HIHSearchInputView.m
//  InterviewHomework
//
//  Created by Daniel Loomb on 12/20/16.
//  Copyright © 2016 Daniel Loomb. All rights reserved.
//

#import "HIHSearchIndex.h"

@interface HIHSearchInputView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *queryTextFieldtopConstraint;

@end

@implementation HIHSearchInputView

- (void)awakeFromNib {
	[super awakeFromNib];
	self.isCentered = true;
}

- (void)setCentered:(BOOL)centered animated:(BOOL)animated {
	_isCentered = centered;
	
	self.topConstraint.constant = centered ? 150 : 0;
	self.queryTextFieldtopConstraint.constant = centered ? 40 : 8;
	[self setNeedsLayout];
	
	[UIView animateWithDuration:animated ? 0.4 : 0.0
						  delay:0
						options:UIViewAnimationOptionCurveEaseInOut
					 animations:^{
						 
						 [self.superview layoutIfNeeded];
						 [self layoutIfNeeded];
						 
						 self.titleLabel.alpha = centered;
						 self.bottomBorderView.alpha = centered;
						 self.backgroundColor = centered ? [UIColor clearColor] : [UIColor colorWithWhite:0 alpha:0.5];
						 
					 } completion:nil];
}

- (void)setIsCentered:(BOOL)isCentered {
	[self setCentered:isCentered animated:false];
}

- (IBAction)onQueryTextFieldEditingChanged:(UITextField *)sender {
	[self setCentered:sender.text.length <= 3 animated:true];
}

@end
