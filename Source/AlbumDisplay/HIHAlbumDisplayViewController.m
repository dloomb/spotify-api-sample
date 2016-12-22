//
//  HIHAlbumDisplayViewController.m
//  InterviewHomework
//
//  Created by Daniel Loomb on 12/21/16.
//  Copyright © 2016 Daniel Loomb. All rights reserved.
//


#import "HIHAlbumDisplayIndex.h"

#import "HIHSearchViewController.h"
#import "HIHCommonIndex.h"

NSString * const HIHAlbumDisplayViewControllerStoryboardIdentifier = @"HIHAlbumDisplayViewControllerStoryboardIdentifier";

@interface HIHAlbumDisplayViewController () <UINavigationControllerDelegate>

@property (nullable, atomic, strong) UIAlertController *errorAlert;
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactivePopTransition;

@property (weak, nonatomic) IBOutlet UILabel *albumNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;

@end




@implementation HIHAlbumDisplayViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.albumNameLabel.text = self.album.title;
	self.artistNameLabel.text = self.album.artist;
	self.albumCoverImageView.image = nil;
	
	[HIHImageCacheService loadImageWithUrl:self.album.imageUrl completion:^(NSError * _Nullable error, UIImage * _Nullable image) {
		
		if (error || !image) {
			[self showAlertForError:error];
		} else {
			self.albumCoverImageView.image = image;
		}
	}];
	
	self.navigationController.interactivePopGestureRecognizer.delegate = nil;
	
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


#pragma mark - Actions

- (IBAction)onBackTouchUpInside:(UIButton *)sender {
	[self.navigationController popViewControllerAnimated:true];
}



#pragma mark - Navigation Controller Delegate 

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
								  animationControllerForOperation:(UINavigationControllerOperation)operation
											   fromViewController:(UIViewController *)fromVC
												 toViewController:(UIViewController *)toVC {

	if (fromVC == self && [toVC isKindOfClass:[HIHSearchViewController class]]) {
		return [[HIHAlbumDisplayTransitionAnimator alloc] initWithDirection:HIHAlbumDisplayTransitionAnimatorDirectionReverse];
	} else {
		return nil;
	}
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
						 interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {

	HIHAlbumDisplayTransitionAnimator *animator = animationController;
	if ([animator respondsToSelector:@selector(direction)] && animator.direction == HIHAlbumDisplayTransitionAnimatorDirectionReverse) {
		return self.interactivePopTransition;
	} else {
		return nil;
	}
}



#pragma mark UIGestureRecognizer handlers

/**
 Used in conjunction with HIHAlbumDisplayTransitionAnimator and UINavigationControllers interactivePopGesure
 */
- (void)handlePopRecognizer:(UIScreenEdgePanGestureRecognizer*)recognizer {
	CGFloat progress = [recognizer translationInView:self.view].x / (self.view.bounds.size.width * 1.0);
	progress = MIN(1.0, MAX(0.0, progress));
	
	if (recognizer.state == UIGestureRecognizerStateBegan) {
		self.interactivePopTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
		[self.navigationController popViewControllerAnimated:YES];
	} else if (recognizer.state == UIGestureRecognizerStateChanged) {
		[self.interactivePopTransition updateInteractiveTransition:progress];
	} else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
		[self.interactivePopTransition finishInteractiveTransition];
		self.interactivePopTransition = nil;
	}
	
}



#pragma mark - Error Handling

- (void)showAlertForError:(NSError *)error {
	if (self.errorAlert == nil) {
		NSString *message = error.localizedDescription ?: @"Sorry, but an unexpected error occured. Please check you network connection and try again.";
		self.errorAlert = [UIAlertController alertControllerWithTitle:@"Error" message:message preferredStyle:(UIAlertControllerStyleAlert)];
		[self.errorAlert addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
			self.errorAlert = nil;
		}]];
		[self presentViewController:self.errorAlert animated:true completion:nil];
	}
}



@end
