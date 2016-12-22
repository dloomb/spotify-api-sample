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
#import "HIHMockHttpClient.h"
#import "HIHAlbum.h"

@interface HIHSearchServiceTests : XCTestCase

@property (strong, nonatomic) HIHMockHttpClient *http;
@property (strong, nonatomic) HIHSearchService *searchService;

@end

@implementation HIHSearchServiceTests

- (void)setUp {
    [super setUp];
	
	self.http = [[HIHMockHttpClient alloc] init];
	self.searchService = [[HIHSearchService alloc] initWithHttpClient:self.http];
}

- (void)tearDown {
	self.searchService = nil;
	self.http = nil;
	
    [super tearDown];
}

- (void)testSearchReturnsAnErrorWhenThereIsNoResponseFromServer {
	__block NSError *result;
	
	[self.searchService search:@"Abcd" completion:^(NSError * _Nullable error, NSArray<HIHAlbum *> * _Nullable response) {
		result = error;
	}];
	
	
	XCTAssertEqual(result.code, 503);
}

- (void)testSearchReturnsAnArrayOfAlbums {
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"query_ok_200_res"ofType:@"json"];
	NSString *json = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
	
	__block NSArray *result;
	[self.http setNextResponse:json];
	[self.searchService search:@"Abcd" completion:^(NSError * _Nullable error, NSArray<HIHAlbum *> * _Nullable response) {
		result = response;
	}];
	
	XCTAssertTrue([result isKindOfClass:[NSArray class]]);
	XCTAssertTrue([result.lastObject isKindOfClass:[HIHAlbum class]]);
}

@end
