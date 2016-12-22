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
@property (nonatomic) CGFloat keyboardHeight;

@end

@implementation HIHSearchInputView

- (void)awakeFromNib {
	[super awakeFromNib];
	self.isCentered = true;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Screen Position

- (void)setCentered:(BOOL)centered animated:(BOOL)animated {
	_isCentered = centered;
	
	[self updateScreenPosition:animated];
}

- (void)setIsCentered:(BOOL)isCentered {
	[self setCentered:isCentered animated:false];
}

- (void)updateScreenPosition:(BOOL)animated {
	BOOL centered = self.isCentered;
	CGFloat yPos = (CGRectGetHeight(self.superview.frame) - self.keyboardHeight) / 2.0 - (CGRectGetHeight(self.frame) / 2.0);
	self.topConstraint.constant = centered ? yPos : 0;
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



- (void)keyboardWillShow:(NSNotification *)notification {
	CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
	self.keyboardHeight = CGRectGetHeight(keyboardFrame);
	
	[self updateScreenPosition:true];
}


#pragma mark - Actions

- (IBAction)onQueryTextFieldEditingChanged:(UITextField *)sender {
	[self setCentered:sender.text.length <= 3 animated:true];
}


@end
