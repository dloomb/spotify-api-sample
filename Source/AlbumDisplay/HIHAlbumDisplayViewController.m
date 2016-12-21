//
//  HIHAlbumDisplayViewController.m
//  InterviewHomework
//
//  Created by Daniel Loomb on 12/21/16.
//  Copyright © 2016 Daniel Loomb. All rights reserved.
//

#import "HIHSearchViewController.h"
#import "HIHAlbumDisplayViewController.h"
#import "HIHAlbumDisplayTransitionAnimator.h"
#import "HIHImageCacheService.h"
#import "HIHAlbum.h"

NSString * const HIHAlbumDisplayViewControllerStoryboardIdentifier = @"HIHAlbumDisplayViewControllerStoryboardIdentifier";

@interface HIHAlbumDisplayViewController () <UINavigationControllerDelegate>

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactivePopTransition;

@property (weak, nonatomic) IBOutlet UILabel *albumNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;

@end

@implementation HIHAlbumDisplayViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.albumNameLabel.text = self.album.title;
	self.artistNameLabel.text = self.album.artist;
	
	[HIHImageCacheService loadImageWithUrl:self.album.imageUrl completion:^(NSError * _Nullable error, UIImage * _Nullable image) {
		
		if (error || !image) {
#warning Unhandled error scenario
		} else {
			self.albumCoverImageView.image = image;
		}
	}];
	
	self.navigationController.interactivePopGestureRecognizer.delegate = nil;
	
	self.albumCoverImageView.layer.cornerRadius = CGRectGetWidth(self.albumCoverImageView.frame) / 2.0;
	self.albumCoverImageView.clipsToBounds = true;
	
	UIScreenEdgePanGestureRecognizer *popRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePopRecognizer:)];
	popRecognizer.edges = UIRectEdgeLeft;
	[self.view addGestureRecognizer:popRecognizer];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	self.navigationController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	if (self.navigationController.delegate == self) {
		self.navigationController.delegate = nil;
	}
}

- (BOOL)prefersStatusBarHidden {
	return true;
}

- (IBAction)onBackTouchUpInside:(UIButton *)sender {
	[self.navigationController popViewControllerAnimated:true];
}



#pragma mark - Navigation Controller Delegate 

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
								  animationControllerForOperation:(UINavigationControllerOperation)operation
											   fromViewController:(UIViewController *)fromVC
												 toViewController:(UIViewController *)toVC {
	// Check if we're transitioning from this view controller to a DSLFirstViewController
	if (fromVC == self && [toVC isKindOfClass:[HIHSearchViewController class]]) {
		return [[HIHAlbumDisplayTransitionAnimator alloc] initWithDirection:HIHAlbumDisplayTransitionAnimatorDirectionReverse];
	}
	else {
		return nil;
	}
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
						 interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
	// Check if this is for our custom transition
	HIHAlbumDisplayTransitionAnimator *animator = animationController;
	if ([animator respondsToSelector:@selector(direction)] && animator.direction == HIHAlbumDisplayTransitionAnimatorDirectionReverse) {
		return self.interactivePopTransition;
	}
	else {
		return nil;
	}
}



#pragma mark UIGestureRecognizer handlers

- (void)handlePopRecognizer:(UIScreenEdgePanGestureRecognizer*)recognizer {
	CGFloat progress = [recognizer translationInView:self.view].x / (self.view.bounds.size.width * 1.0);
	progress = MIN(1.0, MAX(0.0, progress));
	
	if (recognizer.state == UIGestureRecognizerStateBegan) {
		// Create a interactive transition and pop the view controller
		self.interactivePopTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
		[self.navigationController popViewControllerAnimated:YES];
	} else if (recognizer.state == UIGestureRecognizerStateChanged) {
		// Update the interactive transition's progress
		[self.interactivePopTransition updateInteractiveTransition:progress];
	} else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
		// Finish the interactive transition
		[self.interactivePopTransition finishInteractiveTransition];
		
		self.interactivePopTransition = nil;
	}
	
}



@end
