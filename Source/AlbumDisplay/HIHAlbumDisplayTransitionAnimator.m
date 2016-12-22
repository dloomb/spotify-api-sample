//
//  HIHAlbumDisplayTransitionAnimator.m
//  InterviewHomework
//
//  Created by Daniel Loomb on 12/21/16.
//  Copyright © 2016 Daniel Loomb. All rights reserved.
//
//  Found Tutorial Here:
//  http://dativestudios.com/blog/2013/09/29/interactive-transitions/
//

#import "HIHSearchIndex.h"
#import "HIHAlbumDisplayIndex.h"

@implementation HIHAlbumDisplayTransitionAnimator

- (instancetype)initWithDirection:(HIHAlbumDisplayTransitionAnimatorDirection)direction {
	self = [super init];
	if (self) {
		self.direction = direction;
	}
	return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
	return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
	
	if (self.direction == HIHAlbumDisplayTransitionAnimatorDirectionReverse) {
		[self runReverseWithTransition:transitionContext];
	} else {
		[self runForwardWithTransition:transitionContext];
	}
}

- (void)runForwardWithTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
	HIHSearchViewController *fromController = (id)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
	HIHAlbumDisplayViewController *toController = (id)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
	
	[toController.view layoutIfNeeded];
	[toController.view layoutSubviews];
	
	UIView *containerView = [transitionContext containerView];
	NSTimeInterval duration = [self transitionDuration:transitionContext];
	
	// Create snapshot of album cover in cell
	UICollectionView *collectionView = fromController.collectionView;
	HIHSearchAlbumCell *cell = (id)[collectionView cellForItemAtIndexPath:[collectionView indexPathsForSelectedItems].firstObject];
	UIView *snapshot = [cell.imageView snapshotViewAfterScreenUpdates:false];
	snapshot.frame = [containerView convertRect:cell.imageView.frame fromView:cell.imageView.superview];
	cell.imageView.hidden = true;
	cell.shadowView.hidden = true;
	
	
	
	toController.view.frame = [transitionContext finalFrameForViewController:toController];
	toController.view.alpha = 0;
	toController.albumCoverImageView.hidden = true;
	
	[containerView addSubview:toController.view];
	[containerView addSubview:snapshot];
	
	[UIView animateWithDuration:duration animations:^{
		
		toController.view.alpha = 1;
		
		CGRect frame = [containerView convertRect:toController.albumCoverImageView.frame toView:toController.view];
		snapshot.frame = frame;
		
	} completion:^(BOOL finished) {
		
		toController.albumCoverImageView.hidden = false;
		cell.imageView.hidden = false;
		cell.shadowView.hidden = false;
		[snapshot removeFromSuperview];
		
		[transitionContext completeTransition:!transitionContext.transitionWasCancelled];
		
	}];
}

- (void)runReverseWithTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
	HIHAlbumDisplayViewController *fromController = (id)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
	HIHSearchViewController *toController = (id)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
	
	UIView *containerView = [transitionContext containerView];
	NSTimeInterval duration = [self transitionDuration:transitionContext];
	
	// Create snapshot of album cover
	UIView *snapshot = [fromController.albumCoverImageView snapshotViewAfterScreenUpdates:false];
	snapshot.frame = [containerView convertRect:fromController.albumCoverImageView.frame fromView:fromController.albumCoverImageView.superview];
	fromController.albumCoverImageView.hidden = true;
	
	UICollectionView *collectionView = toController.collectionView;
	HIHSearchAlbumCell *cell = (id)[collectionView cellForItemAtIndexPath:[collectionView indexPathsForSelectedItems].firstObject];
	cell.imageView.hidden = true;
	cell.shadowView.hidden = true;
	
	toController.view.frame = [transitionContext finalFrameForViewController:toController];
	[containerView insertSubview:toController.view belowSubview:fromController.view];
	[containerView addSubview:snapshot];
	
	[UIView animateWithDuration:duration animations:^{
		
		fromController.view.alpha = 0;
		
		snapshot.frame = [containerView convertRect:cell.imageView.frame fromView:cell.imageView.superview];
		
	} completion:^(BOOL finished) {
		
		[snapshot removeFromSuperview];
		fromController.albumCoverImageView.hidden = false;
		cell.imageView.hidden = false;
		cell.shadowView.hidden = false;
		
		[transitionContext completeTransition:!transitionContext.transitionWasCancelled];
		
	}];
}

@end
