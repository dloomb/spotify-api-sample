//
//  HIHAlbumDisplayTransitionAnimatorTests.m
//  InterviewHomework
//
//  Created by Daniel Loomb on 12/21/16.
//  Copyright © 2016 Daniel Loomb. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "HIHAlbumDisplayIndex.h"

@interface HIHAlbumDisplayTransitionAnimatorTests : XCTestCase

@end

@implementation HIHAlbumDisplayTransitionAnimatorTests

- (void)testItInitializesWithADefaultDirection {
	HIHAlbumDisplayTransitionAnimator *animator = [[HIHAlbumDisplayTransitionAnimator alloc] init];
	XCTAssertEqual(animator.direction, HIHAlbumDisplayTransitionAnimatorDirectionForward);
}

- (void)testItInitializesWithAGivenDirection {
	HIHAlbumDisplayTransitionAnimator *animator = [[HIHAlbumDisplayTransitionAnimator alloc] initWithDirection:HIHAlbumDisplayTransitionAnimatorDirectionReverse];
	XCTAssertEqual(animator.direction, HIHAlbumDisplayTransitionAnimatorDirectionReverse);
}

@end
