//
//  HIHMockHttpClient.m
//  InterviewHomework
//
//  Created by Daniel Loomb on 12/20/16.
//  Copyright © 2016 Daniel Loomb. All rights reserved.
//

#import "HIHMockHttpClient.h"

@interface HIHMockHttpClient()

@property (strong, nonatomic) NSString *nextResponse;

@end

@implementation HIHMockHttpClient

- (void)setNextResponse:(NSString *)response {
	_nextResponse = response;
}

- (void)get:(NSString *)url completion:(void (^)(NSError * _Nullable, id _Nullable))completion {
	
	if (self.nextResponse) {
		
		NSData *data = [self.nextResponse dataUsingEncoding:NSUTF8StringEncoding];
		NSError *error;
		NSDictionary *object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
		
		if (error || !object) {
			completion(nil, self.nextResponse);
		} else {
			completion(nil, object);
		}
		
	} else {
		completion([NSError errorWithDomain:@"com.dloomb.errors.http_client" code:503 userInfo:@{
			NSLocalizedFailureReasonErrorKey: @"The server is currently unavailable (because it is overloaded or down for maintenance). Generally, this is a temporary state.",
			NSLocalizedRecoverySuggestionErrorKey: @"Try again later."
		}], nil);
	}
	
}

@end
