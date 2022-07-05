//
//  TestsReferenceStorage.m
//  Tests
//
//  Created by Daniele Colombo on 01/07/2022.
//

#import <XCTest/XCTest.h>
#import <vector>
#import "storage.hpp"


@interface TestsReferenceStorage : XCTestCase

@end

@implementation TestsReferenceStorage

    /* Vector Reference */

- (void)testVectorReference {
    std::vector<int> vec {1, 2, 3};
    npp::Storage<int, std::vector<int>&> storage{vec};
    XCTAssertEqual(storage.size(), 3);
    
    for (auto i = 0u; i < storage.size(); i++) {
        XCTAssertEqual(storage[i], vec[i]);
    }
    
    storage[0] = 100;
    XCTAssertEqual(storage[0], 100);
    XCTAssertEqual(vec[0], 100);
    
    vec[1] = 200;
    XCTAssertEqual(storage[1], 200);
    XCTAssertEqual(vec[1], 200);
}

- (void)testVectorReferenceChangeVec {
    std::vector<int> vec {1, 2, 3};
    std::vector<int> otherVec {-1, -2, -3};
    npp::Storage<int, std::vector<int>&> storage{vec};

    vec = otherVec;
    XCTAssertEqual(storage[0], -1);
    XCTAssertEqual(storage[1], -2);
    XCTAssertEqual(storage[2], -3);
}


- (void)testVectorReferenceCopyConstructor {
    npp::Storage<int> storage{1, 2, 3};
    npp::Storage<int, std::vector<int>&> storageRef{storage};
    XCTAssertEqual(storage.size(), 3);
    XCTAssertEqual(storageRef.size(), 3);
    
    for (auto i = 0u; i < storage.size(); i++) {
        XCTAssertEqual(storage[i], storageRef[i]);
    }
    
    storage[0] = 100;
    XCTAssertEqual(storage[0], 100);
    XCTAssertEqual(storageRef[0], 100);
    
    storageRef[1] = 200;
    XCTAssertEqual(storage[1], 200);
    XCTAssertEqual(storageRef[1], 200);
}

- (void)testVectorReferenceCopyAssignment {
    npp::Storage<int> storage{1, 2, 3};
    npp::Storage<int, std::vector<int>&> storageRef = storage;
    XCTAssertEqual(storage.size(), 3);
    XCTAssertEqual(storageRef.size(), 3);
    
    for (auto i = 0u; i < storage.size(); i++) {
        XCTAssertEqual(storage[i], storageRef[i]);
    }
    
    storage[0] = 100;
    XCTAssertEqual(storage[0], 100);
    XCTAssertEqual(storageRef[0], 100);
    
    storageRef[1] = 200;
    XCTAssertEqual(storage[1], 200);
    XCTAssertEqual(storageRef[1], 200);
}

    /* Vector to Pointers */

- (void)testVectorToPointers {
    int i = 1;
    int ii = 2;
    npp::Storage<int*> storage {&i, &ii};
    XCTAssertEqual(storage[0], i);
    XCTAssertEqual(storage[1], ii);
    
    i = 100;
    XCTAssertEqual(storage[0], 100);
    
    storage[1] = 200;
    XCTAssertEqual(ii, 200);
}

- (void)testVectorToPointersCopyConstructor {
    int i = 1;
    int ii = 2;
    npp::Storage<int*> storage {&i, &ii};
    npp::Storage<int*> otherStorage(storage);
    auto j = 0u;
    for (auto element: storage) {
        XCTAssertEqual(*element, otherStorage[j++]);
    }
    
    storage[0] = 100;
    XCTAssertEqual(otherStorage[0], 100);
    
    otherStorage[1] = 200;
    XCTAssertEqual(storage[1], 200);
}

- (void)testVectorToPointersCopyAssignment {
    int i = 1;
    int ii = 2;
    npp::Storage<int*> storage {&i, &ii};
    npp::Storage<int*> otherStorage = storage;
    auto j = 0u;
    for (auto element: storage) {
        XCTAssertEqual(*element, otherStorage[j++]);
    }
    
    storage[0] = 100;
    XCTAssertEqual(otherStorage[0], 100);
    
    otherStorage[1] = 200;
    XCTAssertEqual(storage[1], 200);
}

/* Vector Reference to Pointers */

- (void)testVectorReferenceToPointers {
    int i = 1;
    int ii = 2;
    std::vector<int*> vec {&i, &ii};
    npp::Storage<int*, std::vector<int*>&> storage(vec);
    XCTAssertEqual(storage[0], i);
    XCTAssertEqual(storage[1], ii);
    
    i = 100;
    XCTAssertEqual(storage[0], 100);
    
    storage[1] = 200;
    XCTAssertEqual(ii, 200);
}

- (void)testVectorReferenceToPointersChangeVec {
    int i = 1;
    int ii = 2;
    std::vector<int*> vec {&i, &ii};
    int otheri = -1;
    int otherii = -2;
    std::vector<int*> otherVec {&otheri, &otherii};
    npp::Storage<int*, std::vector<int*>&> storage(vec);
    vec = otherVec;
    XCTAssertEqual(storage[0], -1);
    XCTAssertEqual(storage[1], -2);
}

- (void)testVectorReferenceToPointersCopyConstructor {
    int i = 1;
    int ii = 2;
    std::vector<int*> vec {&i, &ii};
    npp::Storage<int*, std::vector<int*>&> storage(vec);
    npp::Storage<int*, std::vector<int*>&> otherStorage(storage);
    
    auto j = 0u;
    for (auto element: storage) {
        XCTAssertEqual(*element, otherStorage[j++]);
    }
    
    storage[0] = 100;
    XCTAssertEqual(otherStorage[0], 100);
    
    otherStorage[1] = 200;
    XCTAssertEqual(storage[1], 200);
}

- (void)testVectorReferenceToPointersCopyAssignment {
    int i = 1;
    int ii = 2;
    std::vector<int*> vec {&i, &ii};
    npp::Storage<int*, std::vector<int*>&> storage(vec);
    npp::Storage<int*, std::vector<int*>&> otherStorage = storage;
    
    auto j = 0u;
    for (auto element: storage) {
        XCTAssertEqual(*element, otherStorage[j++]);
    }
    
    storage[0] = 100;
    XCTAssertEqual(otherStorage[0], 100);
    
    otherStorage[1] = 200;
    XCTAssertEqual(storage[1], 200);
}

@end
