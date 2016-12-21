//
//  HIHImageCacheService.h
//  InterviewHomework
//
//  Created by Daniel Loomb on 12/20/16.
//  Copyright © 2016 Daniel Loomb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HIHImageCacheService : NSObject

+ (void)loadImageWithUrl:(NSString * _Nonnull)url completion:(void (^ _Nonnull)(NSError * _Nullable, UIImage * _Nullable))completion;

@end
