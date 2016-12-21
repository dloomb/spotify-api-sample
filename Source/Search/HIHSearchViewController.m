//
//  HIHSearchViewController.m
//  InterviewHomework
//
//  Created by Daniel Loomb on 12/20/16.
//  Copyright © 2016 Daniel Loomb. All rights reserved.
//

#import "HIHSearchIndex.h"

#import "HIHAlbum.h"
#import "HIHImageCacheService.h"

@interface HIHSearchViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonnull, nonatomic, strong) HIHSearchService *searchService;
@property (nonnull, nonatomic, strong) NSMutableArray *data;

@property (weak, nonatomic) IBOutlet HIHSearchInputView *searchInputView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation HIHSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.searchService = [[HIHSearchService alloc] init];
	self.data = [NSMutableArray array];
}

- (BOOL)prefersStatusBarHidden {
	return true;
}




#pragma mark - Collection View

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	HIHSearchAlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AlbumCell" forIndexPath:indexPath];
	
	HIHAlbum *album = self.data[indexPath.item];
	
	cell.bottomBorderView.alpha = indexPath.item < self.data.count - 1;
	cell.titleLabel.text = album.title;
	cell.secondaryLabel.text = album.artist;
	
	NSInteger tag = cell.tag + 1;
	cell.tag = tag;
	
	[HIHImageCacheService loadImageWithUrl:album.thumbnailUrl completion:^(NSError * _Nullable error, UIImage * _Nullable image) {
		
		if (error || !image) {
			#warning Unhandled error scenario
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	[self.searchInputView endEditing:true];
}




#pragma mark - Query TextField

- (IBAction)onSearchInputTextFieldChanged:(UITextField *)sender {
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(performQuery) object:nil];
	
	if (sender.text.length > 3) {
		
		[self performSelector:@selector(performQuery) withObject:nil afterDelay:0.3];
		
	} else if (self.data.count) {
		[self.data removeAllObjects];
		[self.collectionView reloadData];
	}
	
}




#pragma mark - Searching

- (void)performQuery {
	NSString *query = self.searchInputView.queryTextField.text;
	
	[self.searchService search:query completion:^(NSError * _Nullable error, NSArray<HIHAlbum *> * _Nullable response) {
		if (error) {
			#warning Unhandled error scenario
		} else {
			[self.data addObjectsFromArray:response];
			[self.collectionView performBatchUpdates:^{
				
				NSMutableArray *indexes = [NSMutableArray array];
				for (int i = 0; i < response.count; i++) {
					[indexes addObject:[NSIndexPath indexPathForItem:i inSection:0]];
				}
				[self.collectionView insertItemsAtIndexPaths:indexes];
				
			} completion:nil];
		}
	}];
}


@end
