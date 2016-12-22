//
//  HIHMockUrlSession.m
//  InterviewHomework
//
//  Created by Daniel Loomb on 12/21/16.
//  Copyright © 2016 Daniel Loomb. All rights reserved.
//

#import "HIHMockUrlSession.h"

@implementation HIHMockUrlSession

+ (HIHMockUrlSession *)mockSession {
	return [[HIHMockUrlSession alloc] init];
}

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completionHandler {
	
	if (self.nextResponse) {
		
		NSData *data = [self.nextResponse dataUsingEncoding:NSUTF8StringEncoding];
		completionHandler(data, nil, nil);
		
	} else {
		completionHandler(nil, nil, [NSError errorWithDomain:@"com.dloomb.errors.http_client" code:503 userInfo:@{
			NSLocalizedFailureReasonErrorKey: @"The server is currently unavailable (because it is overloaded or down for maintenance). Generally, this is a temporary state.",
			NSLocalizedRecoverySuggestionErrorKey: @"Try again later."
		}]);
	}

	return nil;
}

@end
