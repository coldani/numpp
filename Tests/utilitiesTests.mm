//
//  utilitiesTests.mm
//  Tests
//
//  Created by Daniele Colombo on 06/07/2022.
//

#import <XCTest/XCTest.h>
#import <vector>
#import "utilities.hpp"
#import "storage.hpp"

@interface DimensionsCheckerTests : XCTestCase

@end

@implementation DimensionsCheckerTests

- (void)testDimensionsChecker {
    npp::DimensionsChecker<int> checker;
    XCTAssertNoThrow(checker.checkNestedInitList<3>({
            {{1,  2,  3,  4},  {5,  6,  7,  8},  {9,  10, 11, 12}},
            {{13, 14, 15, 16}, {17, 18, 19, 20}, {21, 22, 23, 24}},
        })
    );

    XCTAssertNoThrow(checker.checkNestedInitList<2>({{1,  2,  3,  4},  {5,  6,  7,  8},  {9,  10, 11, 12}}));

    XCTAssertNoThrow(checker.checkNestedInitList<1>({1,  2,  3,  4}));

    XCTAssertThrows(checker.checkNestedInitList<3>({
            {{1,  2,  3,  4},  {5,  6,  7,  8},  {9,  10, 11, 12}},
            {{13, 14, 15, 16}, {17, 18, 19, 20}, {21, 22, 23}},
        })
    );
    
    XCTAssertThrows(checker.checkNestedInitList<3>({
            {{1,  2,  3,  4},  {5,  6,  7,  8},  {9,  10, 11, 12}},
            {{13, 14, 15, 16}, {17, 18, 19, 20}},
        })
    );
    
    XCTAssertThrows(checker.checkNestedInitList<3>({
            {{1,  2,  3,  4},  {5,  6,  7,  8},  {9,  10, 11, 12}},
            {{13, 14, 15}, {17, 18, 19}, {21, 22, 23}},
        })
    );
}

@end


@interface indices_from_slices_Tests : XCTestCase

@end

@implementation indices_from_slices_Tests

- (void)testIndicesFromSlices {
    auto indices = npp::indices_from_slices({{1,2,3},{10},{4,5,6}});
    
    XCTAssertEqual(indices.size(), 9);
    XCTAssertEqual(indices[0].size(), 3);
    XCTAssertEqual(indices[1].size(), 3);
    XCTAssertEqual(indices[2].size(), 3);
    
    XCTAssertEqual(indices[0], std::vector({1, 10, 4}));
    XCTAssertEqual(indices[1], std::vector({1, 10, 5}));
    XCTAssertEqual(indices[2], std::vector({1, 10, 6}));
    XCTAssertEqual(indices[3], std::vector({2, 10, 4}));
    XCTAssertEqual(indices[4], std::vector({2, 10, 5}));
    XCTAssertEqual(indices[5], std::vector({2, 10, 6}));
    XCTAssertEqual(indices[6], std::vector({3, 10, 4}));
    XCTAssertEqual(indices[7], std::vector({3, 10, 5}));
    XCTAssertEqual(indices[8], std::vector({3, 10, 6}));
}

@end


@interface RangeTests : XCTestCase

@end

@implementation RangeTests

- (void)testRangeFrom0 {
    npp::Storage<int> s(npp::Shape(4,3,2));
    npp::range r(0, 3);
    auto indices = r.convert(s, 0);
    XCTAssertEqual(indices.size(), 4);
    XCTAssertEqual(indices[0], 0);
    XCTAssertEqual(indices[1], 1);
    XCTAssertEqual(indices[2], 2);
    XCTAssertEqual(indices[3], 3);
}

- (void)testRange1Value {
    npp::Storage<int> s(npp::Shape(4,3,2));
    npp::range r(2, 2);
    auto indices = r.convert(s, 0);
    XCTAssertEqual(indices.size(), 1);
    XCTAssertEqual(indices[0], 2);
}

- (void)testRangeSteps {
    npp::Storage<int> s(npp::Shape(4,3,2));
    npp::range r(0, 5, 2);
    auto indices = r.convert(s, 0);
    XCTAssertEqual(indices.size(), 3);
    XCTAssertEqual(indices[0], 0);
    XCTAssertEqual(indices[1], 2);
    XCTAssertEqual(indices[2], 4);
}

- (void)testInverseRange {
    npp::Storage<int> s(npp::Shape(4,3,2));
    npp::range r(3, 0, -1);
    auto indices = r.convert(s, 1);
    XCTAssertEqual(indices.size(), 4);
    XCTAssertEqual(indices[0], 3);
    XCTAssertEqual(indices[1], 2);
    XCTAssertEqual(indices[2], 1);
    XCTAssertEqual(indices[3], 0);
}

- (void)testRangeNegIndices {
    npp::Storage<int> s(npp::Shape(4,3,2));
    npp::range r(0, -1);
    auto indices = r.convert(s, 1);
    XCTAssertEqual(indices.size(), 3);
    XCTAssertEqual(indices[0], 0);
    XCTAssertEqual(indices[1], 1);
    XCTAssertEqual(indices[2], 2);
}

- (void)testRangeOtherNegIndices {
    npp::Storage<int> s(npp::Shape(4,3,2));
    npp::range r(-1, 0, -2);
    auto indices = r.convert(s, 0);
    XCTAssertEqual(indices.size(), 2);
    XCTAssertEqual(indices[0], 3);
    XCTAssertEqual(indices[1], 1);
}


- (void)testRangeException {
    npp::Storage<int> s(npp::Shape(4,3,2));
    
    npp::range r(1, 0);
    try {
        auto indices = r.convert(s, 0);
        XCTAssertTrue(false);
    } catch (npp::InvalidRange) {
        XCTAssertTrue(true);
    } catch (...) {
        XCTAssertTrue(false);
    }
    
    npp::range r1(1, 2, -1);
    try {
        auto indices = r1.convert(s, 0);
        XCTAssertTrue(false);
    } catch (npp::InvalidRange) {
        XCTAssertTrue(true);
    } catch (...) {
        XCTAssertTrue(false);
    }
    
    npp::range r2(-2, -1, -1);
    try {
        auto indices = r2.convert(s, 0);
        XCTAssertTrue(false);
    } catch (npp::InvalidRange) {
        XCTAssertTrue(true);
    } catch (...) {
        XCTAssertTrue(false);
    }
    
    npp::range r3(-1, 0);
    try {
        auto indices = r3.convert(s, 0);
        XCTAssertTrue(false);
    } catch (npp::InvalidRange) {
        XCTAssertTrue(true);
    } catch (...) {
        XCTAssertTrue(false);
    }
}

@end


@interface AllTests : XCTestCase

@end

@implementation AllTests

- (void)testAll {
    npp::Storage<int> s(npp::Shape(4,3,2));
    npp::all a;
    auto indices = a.convert(s, 0);
    XCTAssertEqual(indices.size(), 4);
    XCTAssertEqual(indices[0], 0);
    XCTAssertEqual(indices[1], 1);
    XCTAssertEqual(indices[2], 2);
    XCTAssertEqual(indices[3], 3);
}

@end


@interface SliceTests : XCTestCase

@end

@implementation SliceTests

- (void)testSlice {
    npp::slice s{1, 2, -1};
    auto indices = s.convert();
    XCTAssertEqual(indices.size(), 3);
    XCTAssertEqual(indices[0], 1);
    XCTAssertEqual(indices[1], 2);
    XCTAssertEqual(indices[2], -1);
}

@end
