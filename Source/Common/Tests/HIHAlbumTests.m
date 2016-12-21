//
//  HIHAlbumTests.m
//  InterviewHomework
//
//  Created by Daniel Loomb on 12/21/16.
//  Copyright © 2016 Daniel Loomb. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "HIHAlbum.h"

@interface HIHAlbumTests : XCTestCase

@end

@implementation HIHAlbumTests

- (void)testExampleItSerializeAnAlbum {
	NSString *path = [[NSBundle mainBundle] pathForResource:@"album"ofType:@"json"];
	NSData *data = [NSData dataWithContentsOfFile:path];
	NSDictionary *object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
	
	HIHAlbum *album = [[HIHAlbum alloc] initWithData:object];
	XCTAssertTrue([album.identifier isEqualToString:@"5ZwLv27mDGPJqZjhHxElHT"]);
	XCTAssertTrue([album.title isEqualToString:@"ABCD - Any Body Can Dance (Original Motion Picture Soundtrack)"]);
	XCTAssertTrue([album.artist isEqualToString:@"Sachin-Jigar"]);
	XCTAssertTrue([album.imageUrl isEqualToString:@"https://i.scdn.co/image/c94fb1dce70e32b7561a6ce87e8d68bd58ee04e1"]);
	XCTAssertTrue([album.thumbnailUrl isEqualToString:@"https://i.scdn.co/image/5ade613f0c6275885010fa08d8a9589adfa34666"]);
	XCTAssertTrue([album.hrefUrl isEqualToString:@"https://api.spotify.com/v1/albums/5ZwLv27mDGPJqZjhHxElHT"]);
}

@end
