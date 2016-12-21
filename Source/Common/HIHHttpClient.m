//
//  HIHHttpClient.m
//  InterviewHomework
//
//  Created by Daniel Loomb on 12/20/16.
//  Copyright © 2016 Daniel Loomb. All rights reserved.
//

#import "HIHHttpClient.h"

@implementation HIHHttpClient

- (void)get:(NSString *)url completion:(void (^)(NSError * _Nullable, id _Nullable))completion {
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setHTTPMethod:@"GET"];
	[request setURL:[NSURL URLWithString:url]];
	
	NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
																 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
																	 
																	 dispatch_async(dispatch_get_main_queue(), ^{
																		 if (error) {
																			 completion(error, data);
																		 } else {
																			 NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
																			 
																			 NSError *error;
																			 NSDictionary *object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
																			 
																			 if (error || !object) {
																				 completion(nil, string);
																			 } else {
																				 completion(nil, object);
																			 }
																		 }
																	 });
																	 
																 }];
	[task resume];
	
}

@end
