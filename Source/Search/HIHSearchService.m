//
//  HIHSearchService.m
//  InterviewHomework
//
//  Created by Daniel Loomb on 12/20/16.
//  Copyright © 2016 Daniel Loomb. All rights reserved.
//

#import "HIHSearchService.h"
#import "HIHHttpClient.h"
#import "HIHAlbum.h"

NSString * const HIHSearchServiceEndpoint = @"https://api.spotify.com/v1/search?type=album&limit=10&q=";

@interface HIHSearchService ()

@property (strong, nonatomic) HIHHttpClient *http;

@end

@implementation HIHSearchService

- (instancetype)init
{
	self = [super init];
	if (self) {
		self.http = [[HIHHttpClient alloc] initWithUrlSession:[NSURLSession sharedSession]];
	}
	return self;
}

- (void)search:(NSString *)query completion:(void (^)(NSError * _Nullable, NSArray<HIHAlbum *> * _Nullable))completion {
	NSString *safeQuery = [query stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
	NSString *url = [HIHSearchServiceEndpoint stringByAppendingString:safeQuery];
	[self.http get:url completion:^(NSError * _Nullable error, id  _Nullable response) {
		
		if (error) {
			completion(error, response);
		} else {
			completion(nil, [self serializeAlbumsFromResponse:response]);
		}
		
	}];
}

- (NSArray<HIHAlbum *> *)serializeAlbumsFromResponse:(NSDictionary *)response {
	NSDictionary *data = response[@"albums"];
	NSArray *items = data[@"items"];
	
	NSMutableArray *output = [NSMutableArray arrayWithCapacity:items.count];
	
	for (NSDictionary *item in items) {
		HIHAlbum *album = [[HIHAlbum alloc] initWithData:item];
		[output addObject:album];
	}
	
	return [output copy];
}

@end
