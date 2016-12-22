//
//  HIHImageCacheServiceTests.m
//  InterviewHomework
//
//  Created by Daniel Loomb on 12/21/16.
//  Copyright © 2016 Daniel Loomb. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "HIHImageCacheService.h"

@interface HIHImageCacheService (Testing)

+ (NSString *)localPathForImageUrl:(NSString *)url;
+ (void)ensureCacheDirectoryExists;

@end

@interface HIHImageCacheServiceTests : XCTestCase

@property (strong, nonatomic) NSString *cacheDirectory;
@property (strong, nonatomic) NSString *testUrl;

@end

@implementation HIHImageCacheServiceTests

- (void)setUp {
    [super setUp];
    self.cacheDirectory = [NSTemporaryDirectory() stringByAppendingString:@"HIHImageCache/"];
	self.testUrl = [[[NSBundle mainBundle] URLForResource:@"test" withExtension:@"png"] absoluteString];
	
	[[NSFileManager defaultManager] removeItemAtPath:self.cacheDirectory error:nil];
}

- (void)tearDown {
	[[NSFileManager defaultManager] removeItemAtPath:self.cacheDirectory error:nil];
    [super tearDown];
}

- (void)testItDownloadsAnImage {
	__block UIImage *result;
	XCTestExpectation *expectation = [self expectationWithDescription:@"Image loaded from file"];
	
	[HIHImageCacheService loadImageWithUrl:self.testUrl completion:^(NSError * _Nullable error, UIImage * _Nullable image) {
		result = image;
		[expectation fulfill];
	}];
	
	[self waitForExpectationsWithTimeout:1.0 handler:^(NSError * _Nullable error) {
		XCTAssertNil(error);
	}];
	
	XCTAssertNotNil(result);
	XCTAssertEqual(result.size.width, 600);
	XCTAssertEqual(result.size.height, 600);
}

- (void)testItLoadsAnImageFromTheCache {
	__block UIImage *result;
	
	NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.testUrl]];
	NSString *path = [HIHImageCacheService localPathForImageUrl:self.testUrl];
	[HIHImageCacheService ensureCacheDirectoryExists];
	[data writeToFile:path atomically:true];
	
	[HIHImageCacheService loadImageWithUrl:self.testUrl completion:^(NSError * _Nullable error, UIImage * _Nullable image) {
		result = image;
	}];
	
	XCTAssertNotNil(result);
	XCTAssertEqual(result.size.width, 600);
	XCTAssertEqual(result.size.height, 600);
}

- (void)testItHandlesBadUrlErrors {
	__block NSError *result;
	XCTestExpectation *expectation = [self expectationWithDescription:@"Fails to load non existant image"];
	
	[HIHImageCacheService loadImageWithUrl:@"" completion:^(NSError * _Nullable error, UIImage * _Nullable image) {
		result = error;
		[expectation fulfill];
	}];
	
	[self waitForExpectationsWithTimeout:1.0 handler:^(NSError * _Nullable error) {
		XCTAssertNil(error);
	}];
	
	XCTAssertTrue([result.localizedDescription isEqualToString:@"unsupported URL"]);
}


@end
