//
//  HIHMockUrlSession.h
//  InterviewHomework
//
//  Created by Daniel Loomb on 12/21/16.
//  Copyright © 2016 Daniel Loomb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HIHMockUrlSession : NSURLSession

@property (strong, nonatomic) NSString *nextResponse;

+ (HIHMockUrlSession *)mockSession;

@end
