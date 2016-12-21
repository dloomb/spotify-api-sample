//
//  HIHHttpClient.h
//  InterviewHomework
//
//  Created by Daniel Loomb on 12/20/16.
//  Copyright © 2016 Daniel Loomb. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HIHHttpClientInterface <NSObject>

- (void)get:(NSString * _Nonnull)url completion:(void (^ _Nonnull)(NSError * _Nullable error, id _Nullable response))completion;

@end

@interface HIHHttpClient : NSObject <HIHHttpClientInterface>

@end
