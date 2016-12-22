//
//  HIHSearchViewController.m
//  InterviewHomework
//
//  Created by Daniel Loomb on 12/20/16.
//  Copyright © 2016 Daniel Loomb. All rights reserved.
//

#import "HIHSearchIndex.h"

#import "HIHAlbumDisplayIndex.h"
#import "HIHCommonIndex.h"

@interface HIHSearchViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate>

@property (nonnull, nonatomic, strong) HIHSearchService *searchService;
@property (nonnull, nonatomic, strong) NSArray *data;
@property (nullable, atomic, strong) UIAlertController *errorAlert;
@property (atomic) NSInteger queryId;


@property (weak, nonatomic) IBOutlet HIHSearchInputView *searchInputView;


@end

@implementation HIHSearchViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.searchService = [[HIHSearchService alloc] init];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	self.navigationController.delegate = self;
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
	if (self.navigationController.delegate == self) {
		self.navigationController.delegate = nil;
	}
}

- (BOOL)prefersStatusBarHidden {
	return true;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
	CGFloat duration = 0.2;
	[UIView animateWithDuration:duration animations:^{
		self.collectionView.alpha = 0;
	} completion:^(BOOL finished) {
		[self.collectionView reloadData];
		[UIView animateWithDuration:duration animations:^{
			self.collectionView.alpha = 1;
		}];
	}];
	
	
	// Fire on next run loop
	dispatch_async(dispatch_get_main_queue(), ^{
		[self.searchInputView updateScreenPosition:true];
	});
}



#pragma mark - Navigation Controller Delegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
								  animationControllerForOperation:(UINavigationControllerOperation)operation
											   fromViewController:(UIViewController *)fromVC
												 toViewController:(UIViewController *)toVC {
	
	if (fromVC == self && [toVC isKindOfClass:[HIHAlbumDisplayViewController class]]) {
		return [[HIHAlbumDisplayTransitionAnimator alloc] initWithDirection:HIHAlbumDisplayTransitionAnimatorDirectionForward];
	} else {
		return nil;
	}
}




#pragma mark - Collection View

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	HIHSearchAlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AlbumCell" forIndexPath:indexPath];
	
	HIHAlbum *album = self.data[indexPath.item];
	
	cell.dividerImageView.alpha = indexPath.item < self.data.count - 1;
	cell.titleLabel.text = album.title;
	cell.secondaryLabel.text = album.artist;
	cell.imageView.image = nil;
	
	NSInteger tag = cell.tag + 1;
	cell.tag = tag;
	
	[HIHImageCacheService loadImageWithUrl:album.thumbnailUrl completion:^(NSError * _Nullable error, UIImage * _Nullable image) {
		
		if (error || !image) {
			[self showAlertForError:error];
		} else if (cell.tag == tag) {
			cell.imageView.image = image;
		}
	}];
	
	return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat width = CGRectGetWidth(collectionView.frame);
	return CGSizeMake(width, 150);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	[self.searchInputView endEditing:true];
	
	HIHAlbumDisplayViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:HIHAlbumDisplayViewControllerStoryboardIdentifier];
	controller.album = self.data[indexPath.item];
	[self.navigationController pushViewController:controller animated:true];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	[self.searchInputView endEditing:true];
}




#pragma mark - Query TextField

- (IBAction)onSearchInputTextFieldChanged:(UITextField *)sender {
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(performQuery) object:nil];
	
	if (sender.text.length > 3) {
		
		[self performSelector:@selector(performQuery) withObject:nil afterDelay:0.3];
		
	} else if (self.data.count) {
		self.queryId++;
		self.data = @[];
		[self.collectionView reloadData];
	}
	
}




#pragma mark - Searching

- (void)performQuery {
	NSString *query = self.searchInputView.queryTextField.text;
	
	NSInteger queryId = self.queryId + 1;
	self.queryId = queryId;
	
	self.data = @[];
	[self.collectionView reloadData];
	
	[self.searchService search:query completion:^(NSError * _Nullable error, NSArray<HIHAlbum *> * _Nullable response) {
		if (self.queryId == queryId) {
			
			if (error) {
				[self showAlertForError:error];
			} else {
				
				self.data = response ?: @[];
				[self.collectionView performBatchUpdates:^{
					NSMutableArray *indexes = [NSMutableArray array];
					for (int i = 0; i < response.count; i++) {
						[indexes addObject:[NSIndexPath indexPathForItem:i inSection:0]];
					}
					[self.collectionView insertItemsAtIndexPaths:indexes];
					
				} completion:nil];
				
			}
		}
		
	}];
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
