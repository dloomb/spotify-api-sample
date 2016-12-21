//
//  HIHImageCacheService.m
//  InterviewHomework
//
//  Created by Daniel Loomb on 12/20/16.
//  Copyright © 2016 Daniel Loomb. All rights reserved.
//

#import "HIHImageCacheService.h"

NSString * const HIHImageCacheDirectoryPath = @"HIHImageCache/";

@implementation HIHImageCacheService

+ (void)loadImageWithUrl:(NSString *)url completion:(void (^)(NSError * _Nullable, UIImage * _Nullable))completion {
	
	NSString *path = [self localPathForImageUrl:url];
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
		UIImage *image = [UIImage imageWithContentsOfFile:path];
		completion(nil, image);
	} else {
		[self downloadImageForUrl:url andSaveToPath:path completion:^(NSError * _Nullable error, UIImage * _Nullable image) {
			dispatch_async(dispatch_get_main_queue(), ^{
				completion(error, image);
			});
		}];
	}
	
}

+ (NSString *)localPathForImageUrl:(NSString *)url {
	NSString *key = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
	NSString *tempDir = NSTemporaryDirectory();
	return [tempDir stringByAppendingFormat:@"%@%@", HIHImageCacheDirectoryPath, key];
}

+ (void)downloadImageForUrl:(NSString *)url andSaveToPath:(NSString *)path completion:(void (^)(NSError * _Nullable, UIImage * _Nullable))completion {
	
	NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession]
										  dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
											  
											  if (error) {
												  completion(error, nil);
											  } else {
												  
												  [self ensureCacheDirectoryExists];
												  
												  if([data writeToFile:path atomically:NO]) {
													  UIImage *image = [UIImage imageWithContentsOfFile:path];
													  completion(nil, image);
												  } else {
													  completion([NSError errorWithDomain:@"com.dloomb.errors.image_cache" code:1 userInfo:@{
														  NSLocalizedFailureReasonErrorKey: @"Failed to write image data to file."
													  }], nil);
												  }
												  
											  }
											  
										  }];
	[downloadTask resume];
	
}

+ (void)ensureCacheDirectoryExists {
	NSString *directory = [NSTemporaryDirectory() stringByAppendingString:HIHImageCacheDirectoryPath];
	[[NSFileManager defaultManager]createDirectoryAtPath:directory withIntermediateDirectories:NO attributes:nil error:nil];
}


@end
