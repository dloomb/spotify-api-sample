//
//  HIHAlbum.m
//  InterviewHomework
//
//  Created by Daniel Loomb on 12/20/16.
//  Copyright © 2016 Daniel Loomb. All rights reserved.
//

#import "HIHAlbum.h"

@implementation HIHAlbum

- (instancetype)initWithData:(NSDictionary *)data {
	self = [super init];
	if (self) {
		self.identifier = data[@"id"];
		self.hrefUrl = data[@"href"];
		self.title = data[@"name"];
		self.artist = [data[@"artists"] firstObject][@"name"];
		
		[self loadImageUrlsFromArray:data[@"images"]];
	}
	return self;
}

- (void)loadImageUrlsFromArray:(NSArray *)images {
	NSArray *sorted = [images sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *left, NSDictionary *right) {
		NSNumber *lWidth = left[@"width"];
		NSNumber *rWidth = right[@"width"];
		
		return [lWidth compare:rWidth];
	}];
	
	self.imageUrl = [sorted lastObject][@"url"];
	self.thumbnailUrl = self.imageUrl;
	if ([sorted count] > 2) {
		self.thumbnailUrl = sorted[sorted.count - 2][@"url"];
	}
}

@end
