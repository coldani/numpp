//
//  TestsStorage.m
//  Tests
//
//  Created by Daniele Colombo on 24/06/2022.
//

#import <XCTest/XCTest.h>
#import <utility>
#import "storage.hpp"
#import "shape.hpp"


/* ******************************************************/
/* TESTS FOR INSTANCES OF NORMAL (NO REFERENCE) STORAGE */
/* ******************************************************/


@interface StorageTests : XCTestCase

@end

@implementation StorageTests

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
    npp::Storage<int> const storage {-1, -2, -3};
    
    int el0 = storage[0];
    int el1 = storage[1];
    int el2 = storage[2];
    
    XCTAssertEqual(el0, -1);
    XCTAssertEqual(el1, -2);
    XCTAssertEqual(el2, -3);

    int elmin1 = storage[-1];
    int elmin2 = storage[-2];
    int elmin3 = storage[-3];
    
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

@interface ReferenceStorageTests : XCTestCase

@end

@implementation ReferenceStorageTests

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


- (void)testVectorReferenceWithShape {
    std::vector<int> vec {1, 2, 3, 4};
    npp::Shape s(std::vector<size_t>({2, 2}));
    npp::Storage<int, std::vector<int>&> storage{vec, s};
    XCTAssertEqual(storage.size(), 4);
    XCTAssertEqual(storage.shape().ndims(), 2);
    XCTAssertEqual(storage.shape()[0], 2);
    XCTAssertEqual(storage.shape()[1], 2);
    
    for (auto i = 0u; i < storage.size(); i++) {
        XCTAssertEqual(storage[i], vec[i]);
    }
    
    // Changing data on underlying vector changes data on storage and vice versa
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


- (void)testVectorToPointers2D { // just to test fillStorage(pointer_type const& element)
    int i = 1;
    int ii = 2;
    npp::Storage<int*> storage {{&i, &ii}};
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


/* ************************************/
/* TESTS FOR MULTIDIMENTIONAL STORAGE */
/* ************************************/

@interface MultidimensionalStorageTests : XCTestCase

@end

@implementation MultidimensionalStorageTests

- (void)testEmptyMultiDimStorage {
    npp::Storage<int> s {npp::Shape(4,3,2)};
    XCTAssertEqual(s.size(), 0);
    XCTAssertEqual(s.capacity(), 24);
    
    XCTAssertEqual(s.shape().ndims(), 3);
    XCTAssertEqual(s.shape()[0], 4);
    XCTAssertEqual(s.shape()[1], 3);
    XCTAssertEqual(s.shape()[2], 2);
    
    XCTAssertEqual(s.strides().ndims(), 3);
    XCTAssertEqual(s.strides()[0], 6);
    XCTAssertEqual(s.strides()[1], 2);
    XCTAssertEqual(s.strides()[2], 1);
}

- (void)test2DStorage {
    npp::Storage<int> s {{1, 2, 3}, {4, 5, 6}};
    XCTAssertEqual(s.size(), 6);
    XCTAssertEqual(s.capacity(), 6);
    
    XCTAssertEqual(s.shape().ndims(), 2);
    XCTAssertEqual(s.shape()[0], 2);
    XCTAssertEqual(s.shape()[1], 3);
    
    XCTAssertEqual(s.strides().ndims(), 2);
    XCTAssertEqual(s.strides()[0], 3);
    XCTAssertEqual(s.strides()[1], 1);
    
    int v = 1;
    for (auto e: s) {
        XCTAssertEqual(e, v++);
    }
}

- (void)test3DStorage {
    npp::Storage<int> s{
        {{1,  2,  3,  4},  {5,  6,  7,  8},  {9,  10, 11, 12}},
        {{13, 14, 15, 16}, {17, 18, 19, 20}, {21, 22, 23, 24}}
    };
    XCTAssertEqual(s.size(), 24);
    XCTAssertEqual(s.capacity(), 24);
    
    XCTAssertEqual(s.shape().ndims(), 3);
    XCTAssertEqual(s.shape()[0], 2);
    XCTAssertEqual(s.shape()[1], 3);
    XCTAssertEqual(s.shape()[2], 4);
    
    XCTAssertEqual(s.strides().ndims(), 3);
    XCTAssertEqual(s.strides()[0], 12);
    XCTAssertEqual(s.strides()[1], 4);
    XCTAssertEqual(s.strides()[2], 1);
    
    int v = 1;
    for (auto e: s) {
        XCTAssertEqual(e, v++);
    }
}

- (void)testWrongShape {
    try {
        npp::Storage<int> s{
            {{1,  2,  3,  4},  {5,  6,  7,  8}},
            {{13, 14, 15, 16}, {17, 18}}
        };
        XCTAssertTrue(false);
    } catch (npp::ShapeDeductionError e) {
        XCTAssertTrue(true);
    } catch (...) {
        XCTAssertTrue(false);
    }
}

- (void)test1DStorageIndex {
    npp::Storage<int> s {1, 2, 3};
    XCTAssertEqual(s(0), 1);
    XCTAssertEqual(s(1), 2);
    XCTAssertEqual(s(2), 3);
}

- (void)test1DHorizIndex {
    npp::Storage<int> s {{1, 2, 3}};
    XCTAssertEqual(s(0,0), 1);
    XCTAssertEqual(s(0,1), 2);
    XCTAssertEqual(s(0,2), 3);
}

- (void)test2DStorageIndex {
    npp::Storage<int> s {{1, 2, 3}, {4, 5, 6}};
    XCTAssertEqual(s(0,0), 1);
    XCTAssertEqual(s(0,1), 2);
    XCTAssertEqual(s(0,2), 3);
    XCTAssertEqual(s(1,0), 4);
    XCTAssertEqual(s(1,1), 5);
    XCTAssertEqual(s(1,2), 6);
}

- (void)test3DStorageIndex {
    npp::Storage<int> s{
        {{1,  2,  3,  4},  {5,  6,  7,  8},  {9,  10, 11, 12}},
        {{13, 14, 15, 16}, {17, 18, 19, 20}, {21, 22, 23, 24}}
    };
    XCTAssertEqual(s(0,0,0), 1);
    XCTAssertEqual(s(0,0,1), 2);
    XCTAssertEqual(s(0,0,2), 3);
    XCTAssertEqual(s(0,0,3), 4);
    XCTAssertEqual(s(0,1,0), 5);
    XCTAssertEqual(s(0,1,3), 8);
    XCTAssertEqual(s(0,2,1), 10);
    XCTAssertEqual(s(1,0,0), 13);
    XCTAssertEqual(s(1,0,2), 15);
    XCTAssertEqual(s(1,1,2), 19);
    XCTAssertEqual(s(1,2,3), 24);

}

- (void)test3DConstStorageIndex {
    npp::Storage<int> const s{
        {{1,  2,  3,  4},  {5,  6,  7,  8},  {9,  10, 11, 12}},
        {{13, 14, 15, 16}, {17, 18, 19, 20}, {21, 22, 23, 24}}
    };
    XCTAssertEqual(s(0,0,0), 1);
    XCTAssertEqual(s(0,0,1), 2);
    XCTAssertEqual(s(0,0,2), 3);
    XCTAssertEqual(s(0,0,3), 4);
    XCTAssertEqual(s(0,1,0), 5);
    XCTAssertEqual(s(0,1,3), 8);
    XCTAssertEqual(s(0,2,1), 10);
    XCTAssertEqual(s(1,0,0), 13);
    XCTAssertEqual(s(1,0,2), 15);
    XCTAssertEqual(s(1,1,2), 19);
    XCTAssertEqual(s(1,2,3), 24);

}

- (void)testWrongIndex {
    // non-const
    npp::Storage<int> s {{1, 2, 3}, {4, 5, 6}};
    try {
        s(0);
        XCTAssertTrue(false);
    } catch (npp::IndexError) {
        XCTAssertTrue(true);
    } catch (...) {
        XCTAssertTrue(false);
    }
    
    try {
        s(0, 1, 2);
        XCTAssertTrue(false);
    } catch (npp::IndexError) {
        XCTAssertTrue(true);
    } catch (...) {
        XCTAssertTrue(false);
    }
    
    // const
    npp::Storage<int> const sconst {{1, 2, 3}, {4, 5, 6}};
    try {
        sconst(0);
        XCTAssertTrue(false);
    } catch (npp::IndexError) {
        XCTAssertTrue(true);
    } catch (...) {
        XCTAssertTrue(false);
    }
    
    try {
        sconst(0, 1, 2);
        XCTAssertTrue(false);
    } catch (npp::IndexError) {
        XCTAssertTrue(true);
    } catch (...) {
        XCTAssertTrue(false);
    }
}

- (void)testNegative3DIndices {
    npp::Storage<int> s{
        {{1,  2,  3,  4},  {5,  6,  7,  8},  {9,  10, 11, 12}},
        {{13, 14, 15, 16}, {17, 18, 19, 20}, {21, 22, 23, 24}}
    };
    XCTAssertEqual(s(-1, -1, -1), 24);
    XCTAssertEqual(s(0, 0, -4), 1);
    XCTAssertEqual(s(-2, -1, -3), 10);
    XCTAssertEqual(s(-1, 1, 0), 17);
    XCTAssertEqual(s(-1, -3, 2), 15);
    XCTAssertEqual(s(-2, 1, -3), 6);
}

- (void)testAssignValuesVia3DIndices {
    npp::Storage<int> s{
        {{1,  2,  3,  4},  {5,  6,  7,  8},  {9,  10, 11, 12}},
        {{13, 14, 15, 16}, {17, 18, 19, 20}, {21, 22, 23, 24}}
    };
    s(0, 0, 0) = 100;
    s(-1, -2, 3) = 200;
    
    XCTAssertEqual(s(0, 0, 0), 100);
    XCTAssertEqual(s(-2, -3, -4), 100);
    XCTAssertEqual(s[0], 100);
    
    XCTAssertEqual(s(-1, -2, 3), 200);
    XCTAssertEqual(s(1, 1, -1), 200);
    XCTAssertEqual(s[19], 200);
}


@end



/* ***************************/
/* TESTS FOR STORAGE RESHAPE */
/* ***************************/

@interface StorageReshapeTests : XCTestCase

@end

@implementation StorageReshapeTests

- (void)testCanReshapeFrom1Dto2D {
    npp::Storage<int> s{1, 2, 3, 4};
    npp::Storage<int> new_s = s.reshape({2, 2});
    
    XCTAssertEqual(s.shape().ndims(), 1);
    XCTAssertEqual(s.shape()[0], 4);
    XCTAssertEqual(new_s.shape().ndims(), 2);
    XCTAssertEqual(new_s.shape()[0], 2);
    XCTAssertEqual(new_s.shape()[1], 2);
    
    XCTAssertEqual(s(0), new_s(0, 0));
    XCTAssertEqual(s(1), new_s(0, 1));
    XCTAssertEqual(s(2), new_s(1, 0));
    XCTAssertEqual(s(3), new_s(1, 1));
}

- (void)testCanReshape1DHorizTo1DVert {
    npp::Storage<int> s{{1, 2, 3, 4}};
    npp::Storage<int> new_s = s.reshape({4, 1});
    
    XCTAssertEqual(s.shape().ndims(), 2);
    XCTAssertEqual(s.shape()[0], 1);
    XCTAssertEqual(s.shape()[1], 4);
    XCTAssertEqual(new_s.shape().ndims(), 2);
    XCTAssertEqual(new_s.shape()[0], 4);
    XCTAssertEqual(new_s.shape()[1], 1);
    
    XCTAssertEqual(s(0, 0), new_s(0, 0));
    XCTAssertEqual(s(0, 1), new_s(1, 0));
    XCTAssertEqual(s(0, 2), new_s(2, 0));
    XCTAssertEqual(s(0, 3), new_s(3, 0));
}

- (void)testCanReshape2Dto2D {
    npp::Storage<int> s{{1, 2, 3, 4}, {5, 6, 7, 8}};
    npp::Storage<int> new_s = s.reshape({4, 2});
    
    XCTAssertEqual(s.shape().ndims(), 2);
    XCTAssertEqual(s.shape()[0], 2);
    XCTAssertEqual(s.shape()[1], 4);
    XCTAssertEqual(new_s.shape().ndims(), 2);
    XCTAssertEqual(new_s.shape()[0], 4);
    XCTAssertEqual(new_s.shape()[1], 2);
    
    XCTAssertEqual(s(0, 0), new_s(0, 0));
    XCTAssertEqual(s(0, 1), new_s(0, 1));
    XCTAssertEqual(s(0, 2), new_s(1, 0));
    XCTAssertEqual(s(1, 2), new_s(3, 0));
    XCTAssertEqual(s(1, -1), new_s(3, 1));
}

- (void)testCanReshape2Dto1D {
    npp::Storage<int> s{{1, 2, 3, 4}, {5, 6, 7, 8}};
    npp::Storage<int> new_s = s.reshape({8});
    
    XCTAssertEqual(s.shape().ndims(), 2);
    XCTAssertEqual(s.shape()[0], 2);
    XCTAssertEqual(s.shape()[1], 4);
    XCTAssertEqual(new_s.shape().ndims(), 1);
    XCTAssertEqual(new_s.shape()[0], 8);
    
    XCTAssertEqual(s(0, 0), new_s(0));
    XCTAssertEqual(s(0, 1), new_s(1));
    XCTAssertEqual(s(0, 2), new_s(2));
    XCTAssertEqual(s(1, 2), new_s(6));
    XCTAssertEqual(s(1, -1), new_s(7));
}

- (void)testFlatten {
    npp::Storage<int> s{{1, 2, 3, 4}, {5, 6, 7, 8}};
    npp::Storage<int> new_s = s.flatten();
    
    XCTAssertEqual(s.shape().ndims(), 2);
    XCTAssertEqual(s.shape()[0], 2);
    XCTAssertEqual(s.shape()[1], 4);
    XCTAssertEqual(new_s.shape().ndims(), 1);
    XCTAssertEqual(new_s.shape()[0], 8);
    
    XCTAssertEqual(s(0, 0), new_s(0));
    XCTAssertEqual(s(0, 1), new_s(1));
    XCTAssertEqual(s(0, 2), new_s(2));
    XCTAssertEqual(s(1, 2), new_s(6));
    XCTAssertEqual(s(1, -1), new_s(7));
}

- (void)testWrongShape {
    npp::Storage<int> s{{1, 2, 3, 4}, {5, 6, 7, 8}};
    
    try {
    npp::Storage<int> new_s = s.reshape({4, 3});
        XCTAssertTrue(false);
    } catch (npp::DimensionsMismatchError) {
        XCTAssertTrue(true);
    } catch (...) {
        XCTAssertTrue(false);
    }
}

- (void)testChangingValuesWorks {
    npp::Storage<int> s{1, 2, 3, 4};
    npp::Storage<int, std::vector<int>&> new_s = s.reshape({2, 2});
    
    s(0) = 100;
    XCTAssertEqual(new_s(0, 0), 100);
    
    new_s(1, 0) = 200;
    XCTAssertEqual(s(2), 200);
    
    new_s.flatten()(0) = 1000;
    XCTAssertEqual(s(0), 1000);
    XCTAssertEqual(new_s(0,0), 1000);
    
}

- (void)testResize {
    npp::Storage<int> s{
        {{1,  2,  3,  4},  {5,  6,  7,  8},  {9,  10, 11, 12}},
        {{13, 14, 15, 16}, {17, 18, 19, 20}, {21, 22, 23, 24}}
    };
    
    
    s.resize({3, 2, 4});
    XCTAssertEqual(s(0,0,0), 1);
    XCTAssertEqual(s(2,1,3), 24);
    
    XCTAssertEqual(s.size(), 24);
    XCTAssertEqual(s.capacity(), 24);
    
    XCTAssertEqual(s.shape().ndims(), 3);
    XCTAssertEqual(s.shape()[0], 3);
    XCTAssertEqual(s.shape()[1], 2);
    XCTAssertEqual(s.shape()[2], 4);
    
    XCTAssertEqual(s.strides().ndims(), 3);
    XCTAssertEqual(s.strides()[0], 8);
    XCTAssertEqual(s.strides()[1], 4);
    XCTAssertEqual(s.strides()[2], 1);
}

- (void)testResizeflat {
    npp::Storage<int> s{
        {{1,  2,  3,  4},  {5,  6,  7,  8},  {9,  10, 11, 12}},
        {{13, 14, 15, 16}, {17, 18, 19, 20}, {21, 22, 23, 24}}
    };
    
    
    s.resize_flat();
    XCTAssertEqual(s(0), 1);
    XCTAssertEqual(s(-1), 24);
    
    XCTAssertEqual(s.size(), 24);
    XCTAssertEqual(s.capacity(), 24);
    
    XCTAssertEqual(s.shape().ndims(), 1);
    XCTAssertEqual(s.shape()[0], 24);;
    
    XCTAssertEqual(s.strides().ndims(), 1);
    XCTAssertEqual(s.strides()[0], 1);
}

- (void)testResizeWrongDimensions {
    npp::Storage<int> s{
        {{1,  2,  3,  4},  {5,  6,  7,  8},  {9,  10, 11, 12}},
        {{13, 14, 15, 16}, {17, 18, 19, 20}, {21, 22, 23, 24}}
    };
    try {
        s.resize({3, 3, 3});
        XCTAssertTrue(false);
    } catch (npp::DimensionsMismatchError) {
        XCTAssertTrue(true);
    } catch (...) {
        XCTAssertTrue(false);
    }
}

@end


/* ***************************/
/* TESTS FOR STORAGE VIEW    */
/* ***************************/

@interface StorageViewTests : XCTestCase

@end

@implementation StorageViewTests

- (void)testMakeScalarViewOf1D {
    npp::Storage<int> s{1,  2,  3,  4};
    auto view = s.view(0);
    
    XCTAssertEqual(view.size(), 1);
    XCTAssertEqual(view[0],1);
    
    s[0] = 100;
    XCTAssertEqual(s[0], 100);
    XCTAssertEqual(view[0], 100);
    
    view[0] = 200;
    XCTAssertEqual(s[0], 200);
    XCTAssertEqual(view[0], 200);
}

- (void)testMakeSliceViewOf1D {
    npp::Storage<int> s{1,  2,  3,  4};
    auto view = s.view(npp::slice{0, 2});
    
    XCTAssertEqual(view.size(), 2);
    XCTAssertEqual(view[0],1);
    XCTAssertEqual(view[1],3);
    
    s[0] = 100;
    XCTAssertEqual(s[0], 100);
    XCTAssertEqual(view[0], 100);
    
    view[1] = 200;
    XCTAssertEqual(s[2], 200);
    XCTAssertEqual(view[1], 200);
}

- (void)testMakeViewSlice {
    npp::Storage<int> s{{1,  2,  3,  4}, {5,  6,  7,  8}};
    auto view = s.view(npp::slice{-1, -2}, npp::slice{0, 2});
    
    XCTAssertEqual(view.size(), 4);
    XCTAssertEqual(view.shape().ndims(), 2);
    XCTAssertEqual(view.shape()[0], 2);
    XCTAssertEqual(view.shape()[1], 2);

    XCTAssertEqual(view(0, 0), 5);
    XCTAssertEqual(view(0, 1), 7);
    XCTAssertEqual(view(1, 0), 1);
    XCTAssertEqual(view(1, 1), 3);
    
    s(0,0) = 100;
    XCTAssertEqual(s(0,0), 100);
    XCTAssertEqual(view(1, 0), 100);
    
    view(-1, -1) = 200;
    XCTAssertEqual(s(0, 2), 200);
    XCTAssertEqual(view(-1,-1), 200);
}

- (void)testMakeViewRange {
    npp::Storage<int> s{{1,  2,  3,  4}, {5,  6,  7,  8}};
    auto view = s.view(npp::range(0,-1), npp::range(0, 2));
    
    XCTAssertEqual(view.size(), 6);
    XCTAssertEqual(view.shape().ndims(), 2);
    XCTAssertEqual(view.shape()[0], 2);
    XCTAssertEqual(view.shape()[1], 3);

    XCTAssertEqual(view(0, 0), 1);
    XCTAssertEqual(view(0, 1), 2);
    XCTAssertEqual(view(0, 2), 3);
    XCTAssertEqual(view(1, 0), 5);
    XCTAssertEqual(view(1, 1), 6);
    XCTAssertEqual(view(1, 2), 7);
    
    s(1,1) = 600;
    XCTAssertEqual(s(1, 1), 600);
    XCTAssertEqual(view(1, 1), 600);
    
    view(-1, -1) = 700;
    XCTAssertEqual(s(1, 2), 700);
    XCTAssertEqual(view(-1, -1), 700);
}

- (void)testMakeViewAll {
    npp::Storage<int> s{{1,  2,  3,  4}, {5,  6,  7,  8}};
    auto view = s.view(npp::all(), npp::all());
    
    XCTAssertEqual(view.size(), 8);
    XCTAssertEqual(view.shape().ndims(), 2);
    XCTAssertEqual(view.shape()[0], 2);
    XCTAssertEqual(view.shape()[1], 4);

    XCTAssertEqual(view(0, 0), 1);
    XCTAssertEqual(view(0, 1), 2);
    XCTAssertEqual(view(0, 2), 3);
    XCTAssertEqual(view(0, 3), 4);
    XCTAssertEqual(view(1, 0), 5);
    XCTAssertEqual(view(1, 1), 6);
    XCTAssertEqual(view(1, 2), 7);
    XCTAssertEqual(view(1, 3), 8);
    
    s(1,1) = 600;
    XCTAssertEqual(s(1, 1), 600);
    XCTAssertEqual(view(1, 1), 600);
    
    view(-1, -1) = 800;
    XCTAssertEqual(s(1, 3), 800);
    XCTAssertEqual(view(1, 3), 800);
}

- (void)testMakeViewMix {
    npp::Storage<int> s{
        {{1,  2,  3,  4}, {5,  6,  7,  8}},
        {{10, 20, 30, 40}, {50, 60, 70, 80}}
    };
    auto view = s.view(0, npp::all(), npp::slice{0, 1, -1});
    
    XCTAssertEqual(view.size(), 6);
    XCTAssertEqual(view.shape().ndims(), 3);
    XCTAssertEqual(view.shape()[0], 1);
    XCTAssertEqual(view.shape()[1], 2);
    XCTAssertEqual(view.shape()[2], 3);

    XCTAssertEqual(view(0, 0, 0), 1);
    XCTAssertEqual(view(0, 0, 1), 2);
    XCTAssertEqual(view(0, 0, 2), 4);
    XCTAssertEqual(view(0, 1, 0), 5);
    XCTAssertEqual(view(0, 1, 1), 6);
    XCTAssertEqual(view(0, 1, 2), 8);
    
    s(0, 1, 3) = 800;
    XCTAssertEqual(s(0, 1, 3), 800);
    XCTAssertEqual(view(0, 1, 2), 800);
    
    view(-1, -1, -1) = 800;
    XCTAssertEqual(s(0, 1, -1), 800);
    XCTAssertEqual(view(-1, -1, -1), 800);
}

- (void)testConstView {
    npp::Storage<int> s{1, 2, 3};
    auto const view = s.view(0);
    
    XCTAssertEqual(view.size(), 1);
    XCTAssertEqual(view.shape().ndims(), 1);
    XCTAssertEqual(view.shape()[0], 1);

    XCTAssertEqual(view(0), 1);
    
    s(0) = 100;
    XCTAssertEqual(s(0), 100);
    XCTAssertEqual(view(0), 100);
}

- (void)testViewException {
    npp::Storage<int> s{1, 2, 3};
    try {
        auto const view = s.view(1, 0);
        XCTAssertTrue(false);
    } catch (npp::DimensionsMismatchError) {
        XCTAssertTrue(true);
    } catch (...) {
        XCTAssertTrue(false);
    }
}

- (void)testFullView {
    npp::Storage<int> s{{1, 2, 3}, {4, 5, 6}};
    auto v = s.view();
    
    XCTAssertEqual(v.shape().ndims(), 2);
    XCTAssertEqual(v.shape()[0], 2);
    XCTAssertEqual(v.shape()[1], 3);
    XCTAssertEqual(v(0,0), 1);
    XCTAssertEqual(v(0,1), 2);
    XCTAssertEqual(v(0,2), 3);
    XCTAssertEqual(v(1,0), 4);
    XCTAssertEqual(v(1,1), 5);
    XCTAssertEqual(v(1,2), 6);
    
    s(0,0) = 100;
    XCTAssertEqual(s(0, 0), 100);
    XCTAssertEqual(v(0, 0), 100);
    
    v(0, 1) = 200;
    XCTAssertEqual(s(0, 1), 200);
    XCTAssertEqual(v(0, 1), 200);
}


- (void)testFullCopy {
    npp::Storage<int> s{{1, 2, 3}, {4, 5, 6}};
    auto v = s.view();
    auto cs = s.copy();
    auto cv = v.copy();
    
    XCTAssertEqual(cv.shape().ndims(), 2);
    XCTAssertEqual(cv.shape()[0], 2);
    XCTAssertEqual(cv.shape()[1], 3);
    XCTAssertEqual(cv(0,0), 1);
    XCTAssertEqual(cv(0,1), 2);
    XCTAssertEqual(cv(0,2), 3);
    XCTAssertEqual(cv(1,0), 4);
    XCTAssertEqual(cv(1,1), 5);
    XCTAssertEqual(cv(1,2), 6);
    XCTAssertEqual(cs.shape().ndims(), cv.shape().ndims());
    XCTAssertEqual(cs.shape()[0], cv.shape()[0]);
    XCTAssertEqual(cs.shape()[1], cv.shape()[1]);
    XCTAssertEqual(cs(0,0), cv(0,0));
    XCTAssertEqual(cs(0,1), cs(0,1));
    XCTAssertEqual(cs(0,2), cs(0,2));
    XCTAssertEqual(cs(1,0), cs(1,0));
    XCTAssertEqual(cs(1,1), cs(1,1));
    XCTAssertEqual(cs(1,2), cs(1,2));
    
    s(0,0) = 100;
    XCTAssertEqual(s(0, 0), 100);
    XCTAssertEqual(cs(0, 0), 1);
    XCTAssertEqual(cv(0, 0), 1);
    
    cv(0, 1) = 200;
    XCTAssertEqual(s(0, 1), 2);
    XCTAssertEqual(cv(0, 1), 200);
    XCTAssertEqual(cs(0, 1), 2);
    
    cs(0, 2) = 300;
    XCTAssertEqual(s(0, 2), 3);
    XCTAssertEqual(cv(0, 2), 3);
    XCTAssertEqual(cs(0, 2), 300);
}

@end
