//
//  HIHHttpClient.h
//  InterviewHomework
//
//  Created by Daniel Loomb on 12/20/16.
//  Copyright © 2016 Daniel Loomb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HIHHttpClient : NSObject

- (instancetype __nonnull)initWithUrlSession:(NSURLSession * _Nonnull)session;
- (void)get:(NSString * _Nonnull)url completion:(void (^ _Nonnull)(NSError * _Nullable error, id _Nullable response))completion;

@end
