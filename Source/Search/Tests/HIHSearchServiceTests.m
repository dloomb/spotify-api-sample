//
//  HIHSearchServiceTests.m
//  InterviewHomework
//
//  Created by Daniel Loomb on 12/20/16.
//  Copyright © 2016 Daniel Loomb. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "HIHSearchIndex.h"
#import "HIHHttpClient.h"
#import "HIHAlbum.h"
#import "HIHMockUrlSession.h"

@interface HIHSearchService (Testing)

@property (strong, nonatomic) HIHHttpClient *http;

@end

@interface HIHSearchServiceTests : XCTestCase

@property (strong, nonatomic) HIHMockUrlSession *mockUrlSession;
@property (strong, nonatomic) HIHSearchService *searchService;

@end

@implementation HIHSearchServiceTests

- (void)setUp {
    [super setUp];
	
	self.mockUrlSession = [HIHMockUrlSession mockSession];
	self.searchService = [[HIHSearchService alloc] init];
	self.searchService.http = [[HIHHttpClient alloc] initWithUrlSession:self.mockUrlSession];
}

- (void)tearDown {
	self.searchService = nil;
	self.mockUrlSession = nil;
	
    [super tearDown];
}

- (void)testSearchReturnsAnErrorWhenThereIsNoResponseFromServer {
	__block NSError *result;
	
	XCTestExpectation *expectation = [self expectationWithDescription:@"Returns an error when the server cannot be reached."];
	
	[self.searchService search:@"Abcd" completion:^(NSError * _Nullable error, NSArray<HIHAlbum *> * _Nullable response) {
		result = error;
		[expectation fulfill];
	}];
	
	[self waitForExpectationsWithTimeout:1.0 handler:^(NSError * _Nullable error) {
		XCTAssertNil(error);
	}];
	
	XCTAssertEqual(result.code, 503);
}

- (void)testSearchReturnsAnArrayOfAlbums {
	__block NSArray *result;
	
	XCTestExpectation *expectation = [self expectationWithDescription:@"Returns an error when the server cannot be reached."];
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"query_ok_200_res"ofType:@"json"];
	NSString *json = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
	
	
	
	[self.mockUrlSession setNextResponse:json];
	[self.searchService search:@"Abcd" completion:^(NSError * _Nullable error, NSArray<HIHAlbum *> * _Nullable response) {
		result = response;
		[expectation fulfill];
	}];
	
	[self waitForExpectationsWithTimeout:1.0 handler:^(NSError * _Nullable error) {
		XCTAssertNil(error);
	}];
	
	XCTAssertTrue([result isKindOfClass:[NSArray class]]);
	XCTAssertTrue([result.lastObject isKindOfClass:[HIHAlbum class]]);
}

@end
