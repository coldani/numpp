//
//  TestsStorage.m
//  Tests
//
//  Created by Daniele Colombo on 24/06/2022.
//

#import <XCTest/XCTest.h>
#import <utility>
#import "storage.hpp"


/* ******************************************************/
/* TESTS FOR INSTANCES OF NORMAL (NO REFERENCE) STORAGE */
/* ******************************************************/


@interface storageTests : XCTestCase

@end

@implementation storageTests

// Constructors and copy/move assignment
- (void)testEmptyInitialize {
    npp::Storage<int> storage;
    XCTAssertEqual(storage.size(), 0);
    XCTAssertEqual(storage.capacity(), 0);
    XCTAssertEqual(storage.shape().ndims(), 0);
    XCTAssertEqual(storage.strides().ndims(), 0);
}

- (void)testReserveInitialize {
    npp::Storage<int> storage(3);
    XCTAssertEqual(storage.size(), 0);
    XCTAssertEqual(storage.capacity(), 3);
    XCTAssertEqual(storage.shape().ndims(), 1);
    XCTAssertEqual(storage.shape()[0], 3);
    XCTAssertEqual(storage.strides().ndims(), 1);
    XCTAssertEqual(storage.strides()[0], 1);
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
    
    XCTAssertEqual(storage1.shape().ndims(), 1);
    XCTAssertEqual(storage3.shape().ndims(), 1);
    XCTAssertEqual(storage0.shape().ndims(), 0);
    XCTAssertEqual(storage1.shape()[0], 1);
    XCTAssertEqual(storage3.shape()[0], 3);
    
    XCTAssertEqual(storage1.strides().ndims(), 1);
    XCTAssertEqual(storage3.strides().ndims(), 1);
    XCTAssertEqual(storage0.strides().ndims(), 0);
    XCTAssertEqual(storage1.strides()[0], 1);
    XCTAssertEqual(storage3.strides()[0], 1);
}

- (void)testCopyConstruct {
    npp::Storage<int> storage {0, 1, 2};
    npp::Storage<int> otherStorage(storage);
    
    XCTAssertEqual(otherStorage.size(), 3);
    XCTAssertEqual(otherStorage.capacity(), 3);
    XCTAssertEqual(otherStorage.shape().ndims(), 1);
    XCTAssertEqual(otherStorage.shape()[0], 3);
    XCTAssertEqual(otherStorage.strides().ndims(), 1);
    XCTAssertEqual(otherStorage.strides()[0], 1);
    
    
    int i = 0;
    for (auto element: storage) {
        XCTAssertEqual(element, otherStorage[i++]);
    }
   
    // Data on the two storages are separate - changing one does not change the other
    otherStorage[0] = 100;
    XCTAssertEqual(otherStorage[0], 100);
    XCTAssertEqual(storage[0], 0);

    storage[2] = 200;
    XCTAssertEqual(otherStorage[2], 2);
    XCTAssertEqual(storage[2], 200);
}

- (void)testCopyAssignment {
    npp::Storage<int> storage {1, 2, 3};
    npp::Storage<int> otherStorage;
    otherStorage = storage;
    
    XCTAssertEqual(otherStorage.size(), 3);
    XCTAssertEqual(otherStorage.capacity(), 3);
    XCTAssertEqual(otherStorage.shape().ndims(), 1);
    XCTAssertEqual(otherStorage.shape()[0], 3);
    XCTAssertEqual(otherStorage.strides().ndims(), 1);
    XCTAssertEqual(otherStorage.strides()[0], 1);
    
    int i = 0;
    for (auto element: storage) {
        XCTAssertEqual(element, otherStorage[i++]);
    }
    
    // Data on the two storages are separate - changing one does not change the other
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
    XCTAssertEqual(otherStorage.shape().ndims(), 1);
    XCTAssertEqual(otherStorage.shape()[0], 3);
    XCTAssertEqual(otherStorage.strides().ndims(), 1);
    XCTAssertEqual(otherStorage.strides()[0], 1);
    
    int i = 0;
    for (auto element: otherStorage) {
        XCTAssertEqual(element, i++);
    }
}

- (void)testMoveAssignment {
    npp::Storage<int> storage {1, 2, 3};
    npp::Storage<int> otherStorage;
    otherStorage = std::move(storage);
    
    XCTAssertEqual(otherStorage.size(), 3);
    XCTAssertEqual(otherStorage.capacity(), 3);
    XCTAssertEqual(otherStorage.shape().ndims(), 1);
    XCTAssertEqual(otherStorage.shape()[0], 3);
    XCTAssertEqual(otherStorage.strides().ndims(), 1);
    XCTAssertEqual(otherStorage.strides()[0], 1);

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

/* ******************************************/
/* TESTS FOR INSTANCES OF REFERENCE STORAGE */
/* ******************************************/

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
    
    // Data on the two storages are linked - changing one changes the other
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

    // Changing data on underlying vector changes data on storage
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
    
    // Data on the two storages are linked - changing one changes the other
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
    
    // Data on the two storages are linked - changing one changes the other
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
    
    // Changing underlying elements in vector changes data in storage
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
    
    // Data on the two storages are linked - changing one changes the other
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
    
    // Data on the two storages are linked - changing one changes the other
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
    
    // Changing underlying elements in vector changes data in storage
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
    
    // Changing underlying vector changes data on storage
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
    
    // Data on the two storages are linked - changing one changes the other
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
    
    // Data on the two storages are linked - changing one changes the other
    storage[0] = 100;
    XCTAssertEqual(otherStorage[0], 100);
    
    otherStorage[1] = 200;
    XCTAssertEqual(storage[1], 200);
}

@end
