//
//  HIHAlbumDisplayTransitionAnimator.h
//  InterviewHomework
//
//  Created by Daniel Loomb on 12/21/16.
//  Copyright © 2016 Daniel Loomb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HIHAlbumDisplayTransitionAnimatorDirection) {
	HIHAlbumDisplayTransitionAnimatorDirectionForward = 0,
	HIHAlbumDisplayTransitionAnimatorDirectionReverse = 1
};

@interface HIHAlbumDisplayTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic) HIHAlbumDisplayTransitionAnimatorDirection direction;

- (instancetype)initWithDirection:(HIHAlbumDisplayTransitionAnimatorDirection)direction;

@end
