//
//  TestShape.m
//  Tests
//
//  Created by Daniele Colombo on 06/07/2022.
//

#import <XCTest/XCTest.h>
#import <cstddef>
#import <vector>
#import "shape.hpp"
#import "exceptions.hpp"

/* *****************/
/* TESTS FOR SHAPE */
/* *****************/

@interface ShapeTests : XCTestCase

@end

@implementation ShapeTests

- (void)testEmptyShape {
    npp::Shape s;
    XCTAssertEqual(s.ndims(), 0);
    XCTAssertEqual(s.calc_size(), 0);
}

- (void)testShapeFromScalar {
    npp::Shape s(10);
    XCTAssertEqual(s.ndims(), 1);
    XCTAssertEqual(s[0], 10);
    XCTAssertEqual(s.calc_size(), 10);
}

- (void)test1DShape {
    npp::Shape s{1., 2., 3., 4.};
    XCTAssertEqual(s.ndims(), 1);
    XCTAssertEqual(s[0], 4);
    XCTAssertEqual(s.calc_size(), 4);
}
- (void)test1DHorizShape {
    npp::Shape s{{1., 2., 3., 4.}};
    XCTAssertEqual(s.ndims(), 2);
    XCTAssertEqual(s[0], 1);
    XCTAssertEqual(s[1], 4);
    XCTAssertEqual(s.calc_size(), 4);
}

- (void)test2DShape {
    npp::Shape<double> s{{1., 2., 3., 4.}, {5., 6., 7., 8.}, {9., 10., 11., 12.}};
    XCTAssertEqual(s.ndims(), 2);
    XCTAssertEqual(s.calc_size(), 12);
    XCTAssertEqual(s[0], 3);
    XCTAssertEqual(s[1], 4);
}

- (void)test3DShape {
    npp::Shape<int> s{
        {{1,  2,  3,  4},  {5,  6,  7,  8},  {9,  10, 11, 12}},
        {{13, 14, 15, 16}, {17, 18, 19, 20}, {21, 22, 23, 24}}
    };
    XCTAssertEqual(s.ndims(), 3);
    XCTAssertEqual(s.calc_size(), 24);
    XCTAssertEqual(s[0], 2);
    XCTAssertEqual(s[1], 3);
    XCTAssertEqual(s[2], 4);
}

- (void)testFromVector {
    std::vector<std::size_t> vec{3, 2};
    npp::Shape s(vec);
    
    XCTAssertEqual(s.ndims(), 2);
    XCTAssertEqual(s.calc_size(), 6);
    XCTAssertEqual(s[0], 3);
    XCTAssertEqual(s[1], 2);
    
    npp::Shape s2(std::vector<std::size_t>{3, 4});
    XCTAssertEqual(s2.ndims(), 2);
    XCTAssertEqual(s2.calc_size(), 12);
    XCTAssertEqual(s2[0], 3);
    XCTAssertEqual(s2[1], 4);
}

- (void)testCopyConstruct {
    npp::Shape<int> s{1, 2};
    npp::Shape<double> sOther(s);
    XCTAssertEqual(s.ndims(), 1);
    XCTAssertEqual(s.calc_size(), 2);
    XCTAssertEqual(s[0], 2);
    XCTAssertEqual(sOther.ndims(), 1);
    XCTAssertEqual(sOther.calc_size(), 2);
    XCTAssertEqual(sOther[0], 2);
}

- (void)testMoveConstruct {
    npp::Shape<int> s{1, 2};
    npp::Shape<double> sOther(std::move(s));
    XCTAssertEqual(sOther.ndims(), 1);
    XCTAssertEqual(sOther.calc_size(), 2);
    XCTAssertEqual(sOther[0], 2);
}

- (void)testCopyAssignm {
    npp::Shape<int> s{1, 2};
    npp::Shape<double> sOther;
    sOther = s;
    XCTAssertEqual(s.ndims(), 1);
    XCTAssertEqual(s.calc_size(), 2);
    XCTAssertEqual(s[0], 2);
    XCTAssertEqual(sOther.ndims(), 1);
    XCTAssertEqual(sOther.calc_size(), 2);
    XCTAssertEqual(sOther[0], 2);
    
    sOther = std::vector<std::size_t>{5, 6, 7};
    XCTAssertEqual(s.ndims(), 1);
    XCTAssertEqual(s.calc_size(), 2);
    XCTAssertEqual(s[0], 2);
    XCTAssertEqual(sOther.ndims(), 3);
    XCTAssertEqual(sOther.calc_size(), 210);
    XCTAssertEqual(sOther[0], 5);
    XCTAssertEqual(sOther[1], 6);
    XCTAssertEqual(sOther[2], 7);
}

- (void)testMoveAssignm {
    npp::Shape<int> s{1, 2};
    npp::Shape<double> sOther;
    sOther = std::move(s);
    XCTAssertEqual(sOther.ndims(), 1);
    XCTAssertEqual(sOther.calc_size(), 2);
    XCTAssertEqual(sOther[0], 2);
}

- (void)testExceptions {
    try {
        npp::Shape<int> s{
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

@end

/* *******************/
/* TESTS FOR STRIDES */
/* *******************/


@interface StridesTests : XCTestCase

@end

@implementation StridesTests

- (void)testEmptyStrides {
    npp::Strides str;
    
    XCTAssertEqual(str.ndims(), 0);
}

- (void)testStridesFromOneDimShape {
    npp::Shape sh(3);
    npp::Strides str(sh);
    
    XCTAssertEqual(str.ndims(), 1);
    XCTAssertEqual(str[0], 1);
}

- (void)testStridesFromMultiDimShape {
    npp::Shape sh(std::vector<std::size_t>{3, 2, 4});
    npp::Strides str(sh);
    
    XCTAssertEqual(str.ndims(), 3);
    XCTAssertEqual(str[0], 8);
    XCTAssertEqual(str[1], 4);
    XCTAssertEqual(str[2], 1);
}

- (void)testCopyConstructor {
    npp::Shape sh(std::vector<std::size_t>{3, 2, 4});
    npp::Strides str(sh);
    npp::Strides otherStr(str);
    
    XCTAssertEqual(otherStr.ndims(), 3);
    XCTAssertEqual(otherStr[0], 8);
    XCTAssertEqual(otherStr[1], 4);
    XCTAssertEqual(otherStr[2], 1);
}

- (void)testMoveConstructor {
    npp::Shape sh(std::vector<std::size_t>{3, 2, 4});
    npp::Strides str(sh);
    npp::Strides otherStr(std::move(str));
    
    XCTAssertEqual(otherStr.ndims(), 3);
    XCTAssertEqual(otherStr[0], 8);
    XCTAssertEqual(otherStr[1], 4);
    XCTAssertEqual(otherStr[2], 1);
}

- (void)testCopyAssignment {
    npp::Shape sh(std::vector<std::size_t>{3, 2, 4});
    npp::Strides str(sh);
    npp::Strides otherStr;
    otherStr = str;
    
    XCTAssertEqual(otherStr.ndims(), 3);
    XCTAssertEqual(otherStr[0], 8);
    XCTAssertEqual(otherStr[1], 4);
    XCTAssertEqual(otherStr[2], 1);
}

- (void)testMoveAssignment {
    npp::Shape sh(std::vector<std::size_t>{3, 2, 4});
    npp::Strides str(sh);
    npp::Strides otherStr;
    otherStr = std::move(str);
    
    XCTAssertEqual(otherStr.ndims(), 3);
    XCTAssertEqual(otherStr[0], 8);
    XCTAssertEqual(otherStr[1], 4);
    XCTAssertEqual(otherStr[2], 1);
}

@end
