//
//  TestsStorage.m
//  Tests
//
//  Created by Daniele Colombo on 24/06/2022.
//

#import <XCTest/XCTest.h>
#import "storage.hpp"

@interface TestsStorage : XCTestCase

@end

@implementation TestsStorage

- (void)testEmptyInitialize {
    npp::Storage<int> storage3(3);
    XCTAssertEqual(storage3.size(), 0);
    XCTAssertEqual(storage3.capacity(), 3);
}

- (void)testSizeAndCapacity {
    npp::Storage<int> storage1 {1};
    npp::Storage<int> storage3 {1, 2, 3};
    npp::Storage<int> storage0 {};
    
    XCTAssertEqual(storage1.size(), 1);
    XCTAssertEqual(storage3.size(), 3);
    XCTAssertEqual(storage0.size(), 0);
    
    XCTAssertEqual(storage1.capacity(), 1);
    XCTAssertEqual(storage3.capacity(), 3);
    XCTAssertEqual(storage0.capacity(), 0);
}

- (void)testOperatorSelection {
    npp::Storage<int> storage3 {1, 2, 3};
    
    int el0 = storage3[0];
    int el1 = storage3[1];
    int el2 = storage3[2];

    XCTAssertEqual(el0, 1);
    XCTAssertEqual(el1, 2);
    XCTAssertEqual(el2, 3);

    int elmin1 = storage3[-1];
    int elmin2 = storage3[-2];
    int elmin3 = storage3[-3];
    
    XCTAssertEqual(elmin1, 3);
    XCTAssertEqual(elmin2, 2);
    XCTAssertEqual(elmin3, 1);
}

- (void)testConstOperatorSelection {
    npp::Storage<int> storage3 {-1, -2, -3};
    
    int const el0 = storage3[0];
    int const el1 = storage3[1];
    int const el2 = storage3[2];
    
    XCTAssertEqual(el0, -1);
    XCTAssertEqual(el1, -2);
    XCTAssertEqual(el2, -3);

    int const elmin1 = storage3[-1];
    int const elmin2 = storage3[-2];
    int const elmin3 = storage3[-3];
    
    XCTAssertEqual(elmin1, -3);
    XCTAssertEqual(elmin2, -2);
    XCTAssertEqual(elmin3, -1);
}

- (void)testAssignment {
    npp::Storage<int> storage3 {1, 2, 3};
    
    storage3[0] = 10;
    storage3[-1] = 11;
    XCTAssertEqual(storage3[0], 10);
    XCTAssertEqual(storage3[-1], 11);
}

- (void)testCopyAssignment {
    npp::Storage<int> storage3(3);
    storage3 = {1, 2, 3};
    
    XCTAssertEqual(storage3.size(), 3);
    XCTAssertEqual(storage3.capacity(), 3);
    XCTAssertEqual(storage3[0], 1);
    XCTAssertEqual(storage3[1], 2);
    XCTAssertEqual(storage3[2], 3);
}


// TODO implement
/*
- (void)testRangeLoop {
    npp::Storage<int> storage3 {0, 1, 2};
    
    int i = 0;
    for (auto element: storage3) {
        XCTAssertEqual(storage3[i++], i);
    }
}
*/

@end
