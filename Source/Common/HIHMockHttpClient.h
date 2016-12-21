//
//  HIHMockHttpClient.h
//  InterviewHomework
//
//  Created by Daniel Loomb on 12/20/16.
//  Copyright © 2016 Daniel Loomb. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HIHHttpClient.h"

@interface HIHMockHttpClient : NSObject <HIHHttpClientInterface>

- (void)setNextResponse:(NSString *)response;

@end
