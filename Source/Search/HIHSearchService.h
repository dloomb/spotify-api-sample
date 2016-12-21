//
//  HIHSearchService.h
//  InterviewHomework
//
//  Created by Daniel Loomb on 12/20/16.
//  Copyright © 2016 Daniel Loomb. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HIHHttpClientInterface;
@class HIHAlbum;


@interface HIHSearchService : NSObject

- (instancetype __nonnull)initWithHttpClient:(id<HIHHttpClientInterface> __nonnull)http;
- (void)search:(NSString * _Nonnull)query completion:(void(^ _Nonnull)(NSError * _Nullable error, NSArray<HIHAlbum *> * _Nullable response))completion;

@end
