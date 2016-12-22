//
//  HIHSearchInputView.h
//  InterviewHomework
//
//  Created by Daniel Loomb on 12/20/16.
//  Copyright © 2016 Daniel Loomb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HIHSearchInputView : UIView

@property (nonatomic) BOOL isCentered;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *queryTextField;
@property (weak, nonatomic) IBOutlet UIView *bottomBorderView;

- (void)updateScreenPosition:(BOOL)animated;

@end
