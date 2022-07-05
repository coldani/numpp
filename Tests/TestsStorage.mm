//
//  TestsStorage.m
//  Tests
//
//  Created by Daniele Colombo on 24/06/2022.
//

#import <XCTest/XCTest.h>
#import <utility>
#import "storage.hpp"

@interface TestsStorage : XCTestCase

@end

@implementation TestsStorage

// Constructors and copy/move assignment
- (void)testEmptyInitialize {
    npp::Storage<int> storage(3);
    XCTAssertEqual(storage.size(), 0);
    XCTAssertEqual(storage.capacity(), 3);
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

- (void)testCopyConstruct {
    npp::Storage<int> storage {0, 1, 2};
    npp::Storage<int> otherStorage(storage);
    
    XCTAssertEqual(otherStorage.size(), 3);
    XCTAssertEqual(otherStorage.capacity(), 3);

    int i = 0;
    for (auto element: storage) {
        XCTAssertEqual(element, otherStorage[i++]);
    }
   
    otherStorage[0] = 100;
    XCTAssertEqual(otherStorage[0], 100);
    XCTAssertEqual(storage[0], 0);

    storage[2] = 200;
    XCTAssertEqual(otherStorage[2], 2);
    XCTAssertEqual(storage[2], 200);
}

- (void)testCopyAssignment {
    npp::Storage<int> storage {1, 2, 3};
    npp::Storage<int> otherStorage = storage;
    
    XCTAssertEqual(otherStorage.size(), 3);
    XCTAssertEqual(otherStorage.capacity(), 3);
    
    int i = 0;
    for (auto element: storage) {
        XCTAssertEqual(element, otherStorage[i++]);
    }
    
    otherStorage[0] = 100;
    XCTAssertEqual(otherStorage[0], 100);
    XCTAssertEqual(storage[0], 1);
    
    storage[2] = 200;
    XCTAssertEqual(otherStorage[2], 3);
    XCTAssertEqual(storage[2], 200);
}

- (void)testMoveConstructor {
    npp::Storage<int> storage {0, 1, 2};
    npp::Storage<int> otherStorage(std::move(storage));
    
    XCTAssertEqual(otherStorage.size(), 3);
    XCTAssertEqual(otherStorage.capacity(), 3);
    int i = 0;
    for (auto element: otherStorage) {
        XCTAssertEqual(element, i++);
    }
}

- (void)testMoveAssignment {
    npp::Storage<int> storage {1, 2, 3};
    npp::Storage<int> otherStorage = std::move(storage);
    
    XCTAssertEqual(otherStorage.size(), 3);
    XCTAssertEqual(otherStorage.capacity(), 3);
    XCTAssertEqual(otherStorage[0], 1);
    XCTAssertEqual(otherStorage[1], 2);
    XCTAssertEqual(otherStorage[2], 3);
}


// Element indexing and iterators
- (void)testOperatorSelection {
    npp::Storage<int> storage {1, 2, 3};
    
    int el0 = storage[0];
    int el1 = storage[1];
    int el2 = storage[2];

    XCTAssertEqual(el0, 1);
    XCTAssertEqual(el1, 2);
    XCTAssertEqual(el2, 3);

    int elmin1 = storage[-1];
    int elmin2 = storage[-2];
    int elmin3 = storage[-3];
    
    XCTAssertEqual(elmin1, 3);
    XCTAssertEqual(elmin2, 2);
    XCTAssertEqual(elmin3, 1);
}

- (void)testConstOperatorSelection {
    npp::Storage<int> storage {-1, -2, -3};
    
    int const el0 = storage[0];
    int const el1 = storage[1];
    int const el2 = storage[2];
    
    XCTAssertEqual(el0, -1);
    XCTAssertEqual(el1, -2);
    XCTAssertEqual(el2, -3);

    int const elmin1 = storage[-1];
    int const elmin2 = storage[-2];
    int const elmin3 = storage[-3];
    
    XCTAssertEqual(elmin1, -3);
    XCTAssertEqual(elmin2, -2);
    XCTAssertEqual(elmin3, -1);
}

- (void)testAssignment {
    npp::Storage<int> storage {1, 2, 3};
    
    storage[0] = 10;
    storage[-1] = 11;
    XCTAssertEqual(storage[0], 10);
    XCTAssertEqual(storage[-1], 11);
}


- (void)testRangeLoop {
    npp::Storage<int> storage {0, 1, 2};
    
    int i = 0;
    for (auto element: storage) {
        XCTAssertEqual(element, i++);
    }
}

- (void)testIterator {
    npp::Storage<int> storage {0, 1, 2};
    
    int i = 0;
    for (auto it = storage.begin(); it != storage.end(); ++it) {
        XCTAssertEqual(*it, i++);
    }
}

- (void)testConstIterator {
    npp::Storage<int> storage {0, 1, 2};
    
    int i = 0;
    for (auto it = storage.cbegin(); it != storage.cend(); ++it) {
        XCTAssertEqual(*it, i++);
    }
}

@end
