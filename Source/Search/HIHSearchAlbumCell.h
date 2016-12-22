//
//  HIHSearchAlbumCell.h
//  InterviewHomework
//
//  Created by Daniel Loomb on 12/20/16.
//  Copyright © 2016 Daniel Loomb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HIHSearchAlbumCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondaryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dividerImageView;
@property (weak, nonatomic) IBOutlet UIView *shadowView;

@end
