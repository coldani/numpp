//
//  arrayCreatorsTest.m
//  Tests
//
//  Created by Daniele Colombo on 23/07/2022.
//

#import <XCTest/XCTest.h>

#import "numpp.hpp"

@interface FullTests : XCTestCase

@end

@implementation FullTests

- (void)testFull {
    auto f = npp::full<int>({4, 3, 2}, -1);
    
    XCTAssertEqual(f.shape().ndims(), 3);
    XCTAssertEqual(f.shape()[0], 4);
    XCTAssertEqual(f.shape()[1], 3);
    XCTAssertEqual(f.shape()[2], 2);
    for (auto i = 0u; i < f.size(); i++) {
        XCTAssertEqual(f[i], -1);
    }
}
@end


@interface EyeTests : XCTestCase

@end

@implementation EyeTests

- (void)testEyeDefault {
    auto e = npp::eye<double>(3);
    
    XCTAssertEqual(e.shape().ndims(), 2);
    XCTAssertEqual(e.shape()[0], 3);
    XCTAssertEqual(e.shape()[1], 3);
    for (auto row = 0u; row < e.shape()[0]; row++) {
        for (auto col = 0u; col < e.shape()[1]; col++) {
            if (row == col) XCTAssertEqual(e(row, col), 1);
            else XCTAssertEqual(e(row, col), 0);
        }
    }
}

- (void)testEyeNonDefault {
    auto e = npp::eye<int>(10, -1);
    
    XCTAssertEqual(e.shape().ndims(), 2);
    XCTAssertEqual(e.shape()[0], 10);
    XCTAssertEqual(e.shape()[1], 10);
    for (auto row = 0u; row < e.shape()[0]; row++) {
        for (auto col = 0u; col < e.shape()[1]; col++) {
            if (row == col) XCTAssertEqual(e(row, col), -1);
            else XCTAssertEqual(e(row, col), 0);
        }
    }
}

@end
