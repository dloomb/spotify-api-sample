//
//  HIHAlbumDisplayViewController.h
//  InterviewHomework
//
//  Created by Daniel Loomb on 12/21/16.
//  Copyright © 2016 Daniel Loomb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HIHAlbum;

extern NSString * const HIHAlbumDisplayViewControllerStoryboardIdentifier;

@interface HIHAlbumDisplayViewController : UIViewController

@property (nonatomic, strong) HIHAlbum *album;

@property (weak, nonatomic) IBOutlet UIImageView *albumCoverImageView;

@end
