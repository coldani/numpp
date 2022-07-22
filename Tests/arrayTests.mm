//
//  arrayTests.mm
//  Tests
//
//  Created by Daniele Colombo on 18/07/2022.
//

#import <XCTest/XCTest.h>
#import <vector>
#import "array.hpp"
#import "storage.hpp"
#import "utilities.hpp"
#import "exceptions.hpp"

@interface ArrayBaseTests : XCTestCase

@end

@implementation ArrayBaseTests

- (void)testDefaultConstructor {
    npp::array<int> a;
    
    XCTAssertEqual(a.size(), 0);
    XCTAssertEqual(a.shape().ndims(), 0);
}

- (void)testEmptyWithCapacity {
    npp::array<int> a(10);
    
    XCTAssertEqual(a.size(), 10);
    XCTAssertEqual(a.shape().ndims(), 1);
    XCTAssertEqual(a.shape()[0], 10);
}

- (void)testConstructFromStorage {
    npp::Storage<int> s{1, 2, 3};
    npp::array<int> a(s);
    
    XCTAssertEqual(a.size(), 3);
    XCTAssertEqual(a.shape().ndims(), 1);
    XCTAssertEqual(a.shape()[0], 3);
}

- (void)test1D {
    npp::array<int> a{1, 2, 3};
    
    XCTAssertEqual(a.size(), 3);
    XCTAssertEqual(a.shape().ndims(), 1);
    XCTAssertEqual(a.shape()[0], 3);
    
    XCTAssertEqual(a(0), 1);
    XCTAssertEqual(a(1), 2);
    XCTAssertEqual(a(2), 3);
}

- (void)test2D {
    npp::array<int> a{{1, 2, 3}, {4, 5, 6}};
    
    XCTAssertEqual(a.size(), 6);
    XCTAssertEqual(a.shape().ndims(), 2);
    XCTAssertEqual(a.shape()[0], 2);
    XCTAssertEqual(a.shape()[1], 3);
    
    XCTAssertEqual(a(0, 0), 1);
    XCTAssertEqual(a(1, 0), 4);
    XCTAssertEqual(a(0, 2), 3);
    XCTAssertEqual(a(1, -1), 6);
}

- (void)test3D {
    npp::array<int> const a{
        {{1,  2,  3,  4},  {5,  6,  7,  8},  {9,  10,  11,  12}},
        {{10, 20, 30, 40}, {50, 60, 70, 80}, {90, 100, 110, 120}},
        
    };
    
    XCTAssertEqual(a.size(), 24);
    XCTAssertEqual(a.shape().ndims(), 3);
    XCTAssertEqual(a.shape()[0], 2);
    XCTAssertEqual(a.shape()[1], 3);
    XCTAssertEqual(a.shape()[2], 4);
    
    XCTAssertEqual(a(0, 0, 0), 1);
    XCTAssertEqual(a(1, 0, 0), 10);
    XCTAssertEqual(a(0, 2, -1), 12);
    XCTAssertEqual(a(-1, -1, 2), 110);
}

- (void)testCopyConstructors {
    // container_no_ref
    npp::array<int> a{{1, 2, 3}, {4, 5, 6}};
    auto a1(a);
    
    XCTAssertEqual(a1.size(), 6);
    XCTAssertEqual(a1.shape().ndims(), 2);
    XCTAssertEqual(a1.shape()[0], 2);
    XCTAssertEqual(a1.shape()[1], 3);
    
    XCTAssertEqual(a1(0, 0), 1);
    XCTAssertEqual(a1(1, 0), 4);
    XCTAssertEqual(a1(0, 2), 3);
    XCTAssertEqual(a1(1, -1), 6);
    
    // container_ref
    npp::Storage<int> s{1, 2, 3};
    npp::array<int, std::vector<int>&> aref(s);
    npp::array a3(aref);
    XCTAssertEqual(a3.size(), 3);
    XCTAssertEqual(a3.shape().ndims(), 1);
    XCTAssertEqual(a3.shape()[0], 3);
    
    s(0) = 100;
    XCTAssertEqual(s(0), 100);
    XCTAssertEqual(aref(0), 100);
    XCTAssertEqual(a3(0), 1);
    
    aref(1) = 200;
    XCTAssertEqual(s(1), 200);
    XCTAssertEqual(aref(1), 200);
    XCTAssertEqual(a3(1), 2);
    
    a3(2) = 300;
    XCTAssertEqual(s(2), 3);
    XCTAssertEqual(aref(2), 3);
    XCTAssertEqual(a3(2), 300);
}

- (void)testMoveConstructors {
    // container_no_ref
    npp::array<int> a{{1, 2, 3}, {4, 5, 6}};
    auto a1(std::move(a));
    
    XCTAssertEqual(a1.size(), 6);
    XCTAssertEqual(a1.shape().ndims(), 2);
    XCTAssertEqual(a1.shape()[0], 2);
    XCTAssertEqual(a1.shape()[1], 3);
    
    XCTAssertEqual(a1(0, 0), 1);
    XCTAssertEqual(a1(1, 0), 4);
    XCTAssertEqual(a1(0, 2), 3);
    XCTAssertEqual(a1(1, -1), 6);
    
    // container_ref
    npp::Storage<int> s{1, 2, 3};
    npp::array<int, std::vector<int>&> aref(s);
    npp::array a3(std::move(aref));
    XCTAssertEqual(a3.size(), 3);
    XCTAssertEqual(a3.shape().ndims(), 1);
    XCTAssertEqual(a3.shape()[0], 3);
    
    s(0) = 100;
    XCTAssertEqual(s(0), 100);
    XCTAssertEqual(aref(0), 100);
    XCTAssertEqual(a3(0), 1);
    
    aref(1) = 200;
    XCTAssertEqual(s(1), 200);
    XCTAssertEqual(aref(1), 200);
    XCTAssertEqual(a3(1), 2);
    
    a3(2) = 300;
    XCTAssertEqual(s(2), 3);
    XCTAssertEqual(aref(2), 3);
    XCTAssertEqual(a3(2), 300);
}

- (void)testCopyAssignment {
    npp::array<int> a{{1, 2, 3}, {4, 5, 6}};
    npp::array<int> a1;
    a1 = a;
    
    XCTAssertEqual(a1.size(), 6);
    XCTAssertEqual(a1.shape().ndims(), 2);
    XCTAssertEqual(a1.shape()[0], 2);
    XCTAssertEqual(a1.shape()[1], 3);
    
    XCTAssertEqual(a1(0, 0), 1);
    XCTAssertEqual(a1(1, 0), 4);
    XCTAssertEqual(a1(0, 2), 3);
    XCTAssertEqual(a1(1, -1), 6);
}

- (void)testMoveAssignment {
    npp::array<int> a{{1, 2, 3}, {4, 5, 6}};
    npp::array<int> a1;
    a1 = std::move(a);
    
    XCTAssertEqual(a1.size(), 6);
    XCTAssertEqual(a1.shape().ndims(), 2);
    XCTAssertEqual(a1.shape()[0], 2);
    XCTAssertEqual(a1.shape()[1], 3);
    
    XCTAssertEqual(a1(0, 0), 1);
    XCTAssertEqual(a1(1, 0), 4);
    XCTAssertEqual(a1(0, 2), 3);
    XCTAssertEqual(a1(1, -1), 6);
}

- (void)testView {
    npp::array<int> a{{1, 2, 3}, {4, 5, 6}};
    auto v = a.view(1, npp::all());
    
    XCTAssertEqual(v.size(), 3);
    XCTAssertEqual(v.shape().ndims(), 2);
    XCTAssertEqual(v.shape()[0], 1);
    XCTAssertEqual(v.shape()[1], 3);
    
    XCTAssertEqual(v(0, 0), 4);
    XCTAssertEqual(v(0, 1), 5);
    XCTAssertEqual(v(0 ,2), 6);
    
    
    auto v2 = a.view();
    XCTAssertEqual(v2.size(), 6);
    XCTAssertEqual(v2.shape().ndims(), 2);
    XCTAssertEqual(v2.shape()[0], 2);
    XCTAssertEqual(v2.shape()[1], 3);
    
    XCTAssertEqual(v2(0, 0), 1);
    XCTAssertEqual(v2(1, 0), 4);
    XCTAssertEqual(v2(0, 2), 3);
    XCTAssertEqual(v2(1, -1), 6);
    
    a(1, 0) = 400;
    XCTAssertEqual(a(1,0), 400);
    XCTAssertEqual(v(0,0), 400);
    XCTAssertEqual(v2(1,0), 400);
    
    v(0, -1) = 600;
    XCTAssertEqual(a(1,2), 600);
    XCTAssertEqual(v(0,2), 600);
    XCTAssertEqual(v2(1,2), 600);
    
    v2(1, 1) = 500;
    XCTAssertEqual(a(1,1), 500);
    XCTAssertEqual(v(0,1), 500);
    XCTAssertEqual(v2(1,1), 500);
}

- (void)testConstView {
    npp::array<int> const a{{1, 2, 3}, {4, 5, 6}};
    auto v = a.view(1, npp::all());
    
    XCTAssertEqual(v.size(), 3);
    XCTAssertEqual(v.shape().ndims(), 2);
    XCTAssertEqual(v.shape()[0], 1);
    XCTAssertEqual(v.shape()[1], 3);
    
    XCTAssertEqual(v(0, 0), 4);
    XCTAssertEqual(v(0, 1), 5);
    XCTAssertEqual(v(0 ,2), 6);
    
    
    auto const v2 = a.view();
    XCTAssertEqual(v2.size(), 6);
    XCTAssertEqual(v2.shape().ndims(), 2);
    XCTAssertEqual(v2.shape()[0], 2);
    XCTAssertEqual(v2.shape()[1], 3);
    
    XCTAssertEqual(v2(0, 0), 1);
    XCTAssertEqual(v2(1, 0), 4);
    XCTAssertEqual(v2(0, 2), 3);
    XCTAssertEqual(v2(1, -1), 6);
}

- (void)testCopy {
    npp::array<int> a{{1, 2, 3}, {4, 5, 6}};
    auto v = a.view();
    auto c = v.copy();
    
    XCTAssertEqual(c.size(), 6);
    XCTAssertEqual(c.shape().ndims(), 2);
    XCTAssertEqual(c.shape()[0], 2);
    XCTAssertEqual(c.shape()[1], 3);
    
    XCTAssertEqual(c(0, 0), 1);
    XCTAssertEqual(c(1, 0), 4);
    XCTAssertEqual(c(0, 2), 3);
    XCTAssertEqual(c(1, -1), 6);
    
    a(1, 0) = 400;
    XCTAssertEqual(a(1,0), 400);
    XCTAssertEqual(v(1,0), 400);
    XCTAssertEqual(c(1,0), 4);
    
    v(0, -1) = 300;
    XCTAssertEqual(a(0,2), 300);
    XCTAssertEqual(v(0,2), 300);
    XCTAssertEqual(c(0,2), 3);
    
    c(1, 1) = 500;
    XCTAssertEqual(a(1,1), 5);
    XCTAssertEqual(v(1,1), 5);
    XCTAssertEqual(c(1,1), 500);
}

- (void)testReshape {
    npp::array<int> a{{1, 2, 3}, {4, 5, 6}};
    auto v = a.reshape({3, 2});
    
    XCTAssertEqual(v.size(), 6);
    XCTAssertEqual(v.shape().ndims(), 2);
    XCTAssertEqual(v.shape()[0], 3);
    XCTAssertEqual(v.shape()[1], 2);
    
    XCTAssertEqual(v(0, 0), 1);
    XCTAssertEqual(v(1, 0), 3);
    XCTAssertEqual(v(0, 1), 2);
    XCTAssertEqual(v(2, 1), 6);
    
    a(1, 0) = 400;
    XCTAssertEqual(a(1,0), 400);
    XCTAssertEqual(v(1,1), 400);
    
    v(1, -1) = 200;
    XCTAssertEqual(a(1,0), 200);
    XCTAssertEqual(v(1,1), 200);
    
    a(1, 1) = 500;
    XCTAssertEqual(a(1,1), 500);
    XCTAssertEqual(v(2,0), 500);
}

- (void)testFlatten {
    npp::array<int> a{{1, 2, 3}, {4, 5, 6}};
    auto v = a.flatten();
    
    XCTAssertEqual(v.size(), 6);
    XCTAssertEqual(v.shape().ndims(), 1);
    XCTAssertEqual(v.shape()[0], 6);
    
    XCTAssertEqual(v(0), 1);
    XCTAssertEqual(v(2), 3);
    XCTAssertEqual(v(4), 5);
    XCTAssertEqual(v(-1), 6);
    
    a(1, 0) = 400;
    XCTAssertEqual(a(1,0), 400);
    XCTAssertEqual(v(3), 400);
    
    v(1) = 200;
    XCTAssertEqual(a(0,1), 200);
    XCTAssertEqual(v(1), 200);
    
    a(1, 1) = 500;
    XCTAssertEqual(a(1,1), 500);
    XCTAssertEqual(v(4), 500);
}

- (void)testTranspose {
    npp::array<int> a{
        {{0,  1,  2,  3},
         {4,  5,  6,  7},
         {8,  9,  10, 11}},

        {{12, 13, 14, 15},
         {16, 17, 18, 19},
         {20, 21, 22, 23}}
    };
    auto a_t = a.transpose();
    
    XCTAssertEqual(a_t.shape().ndims(), 3);
    XCTAssertEqual(a_t.shape()[0], 4);
    XCTAssertEqual(a_t.shape()[1], 3);
    XCTAssertEqual(a_t.shape()[2], 2);
    
    XCTAssertEqual(a_t(0, 0, 0), a(0, 0, 0));
    XCTAssertEqual(a_t(0, 2, 1), a(1, 2, 0));
    XCTAssertEqual(a_t(3, 2, 1), a(1, 2, 3));

    XCTAssertEqual(a_t(0, 0, 0), 0);
    XCTAssertEqual(a_t(0, 2, 1), 20);
    XCTAssertEqual(a_t(3, 2, 1), 23);
    
    a(1, 2, 0) = 200;
    XCTAssertEqual(a(1, 2, 0), 200);
    XCTAssertEqual(a_t(0, 2, 1), 200);
    
    a_t(3, 2, 1) = 230;
    XCTAssertEqual(a(1, 2, 3), 230);
    XCTAssertEqual(a_t(3, 2, 1), 230);
}

- (void)testResize {
    npp::array<int> a{{1, 2, 3}, {4, 5, 6}};
    a.resize({3, 2});
    
    XCTAssertEqual(a.size(), 6);
    XCTAssertEqual(a.shape().ndims(), 2);
    XCTAssertEqual(a.shape()[0], 3);
    XCTAssertEqual(a.shape()[1], 2);
    
    XCTAssertEqual(a(0, 0), 1);
    XCTAssertEqual(a(1, 0), 3);
    XCTAssertEqual(a(0, 1), 2);
    XCTAssertEqual(a(2, 1), 6);
}

- (void)testResizeFlat {
    npp::array<int> a{{1, 2, 3}, {4, 5, 6}};
    a.resize_flat();
    
    XCTAssertEqual(a.size(), 6);
    XCTAssertEqual(a.shape().ndims(), 1);
    XCTAssertEqual(a.shape()[0], 6);
    
    XCTAssertEqual(a(0), 1);
    XCTAssertEqual(a(1), 2);
    XCTAssertEqual(a(2), 3);
    XCTAssertEqual(a(5), 6);
}

@end



@interface ArrayOperatorsTests : XCTestCase

@end

@implementation ArrayOperatorsTests

- (void)testOperatorPlus {
    npp::array<int> a{{1, 2, 3}, {4, 5, 6}};
    npp::array<int> a1{{10, 20, 30}, {40, 50, 60}};

    auto result = a + a1;
    XCTAssertEqual(result.size(), 6);
    XCTAssertEqual(result.shape().ndims(), 2);
    XCTAssertEqual(result.shape()[0], 2);
    XCTAssertEqual(result.shape()[1], 3);
    
    XCTAssertEqual(result(0, 0), 11);
    XCTAssertEqual(result(0, 1), 22);
    XCTAssertEqual(result(1, -1), 66);
}

- (void)testOperatorMinus {
    npp::array<double> a{{1., 2., 3.}, {4., 5., 6.}};
    npp::array<int> a1{{10, 20, 30}, {40, 50, 60}};

    auto result = a - a1;
    XCTAssertEqual(result.size(), 6);
    XCTAssertEqual(result.shape().ndims(), 2);
    XCTAssertEqual(result.shape()[0], 2);
    XCTAssertEqual(result.shape()[1], 3);
    
    XCTAssertEqual(result(0, 0), -9.);
    XCTAssertEqual(result(0, 1), -18.);
    XCTAssertEqual(result(1, -1), -54.);
}

- (void)testOperatorMult {
    npp::array<int> a{{1, 2, 3}, {4, 5, 6}};
    npp::array<int> a1{{10, 20, 30}, {40, 50, 60}};

    auto result = a * a1;
    XCTAssertEqual(result.size(), 6);
    XCTAssertEqual(result.shape().ndims(), 2);
    XCTAssertEqual(result.shape()[0], 2);
    XCTAssertEqual(result.shape()[1], 3);
    
    XCTAssertEqual(result(0, 0), 10);
    XCTAssertEqual(result(0, 1), 40);
    XCTAssertEqual(result(1, -1), 360);
}

- (void)testOperatorDiv {
    npp::array<double> a{{1, 2, 3}, {4, 5, 6}};
    npp::array<double> a1{{10, 20, 30}, {8, 10, 12}};

    auto result = a / a1;
    XCTAssertEqual(result.size(), 6);
    XCTAssertEqual(result.shape().ndims(), 2);
    XCTAssertEqual(result.shape()[0], 2);
    XCTAssertEqual(result.shape()[1], 3);
    
    XCTAssertEqual(result(0, 0), 0.1);
    XCTAssertEqual(result(0, 1), 0.1);
    XCTAssertEqual(result(1, -1), 0.5);
}

- (void)testOperatorRemainder {
    npp::array<int> a{{1, 2, 3}, {4, 5, 8}};
    npp::array<int> a1{{10, 20, 30}, {8, 10, 4}};

    auto result = a % a1;
    XCTAssertEqual(result.size(), 6);
    XCTAssertEqual(result.shape().ndims(), 2);
    XCTAssertEqual(result.shape()[0], 2);
    XCTAssertEqual(result.shape()[1], 3);
    
    XCTAssertEqual(result(0, 0), 1);
    XCTAssertEqual(result(0, 1), 2);
    XCTAssertEqual(result(1, -1), 0);
}

- (void)testOperatorEqual {
    npp::array<int> a{{1, 2, 3}, {4, 5, 6}};
    npp::array<int> a1{{10, 2, 30}, {4, 5, 60}};

    auto result = a == a1;
    XCTAssertEqual(result.size(), 6);
    XCTAssertEqual(result.shape().ndims(), 2);
    XCTAssertEqual(result.shape()[0], 2);
    XCTAssertEqual(result.shape()[1], 3);
    
    XCTAssertEqual(result(0, 0), false);
    XCTAssertEqual(result(0, 1), true);
    XCTAssertEqual(result(1, -1), false);
}

- (void)testOperatorGreater {
    npp::array<int> a{{1, 2, 3}, {4, 5, 600}};
    npp::array<int> a1{{10, 2, 30}, {4, 5, 60}};

    auto result = a > a1;
    XCTAssertEqual(result.size(), 6);
    XCTAssertEqual(result.shape().ndims(), 2);
    XCTAssertEqual(result.shape()[0], 2);
    XCTAssertEqual(result.shape()[1], 3);
    
    XCTAssertEqual(result(0, 0), false);
    XCTAssertEqual(result(0, 1), false);
    XCTAssertEqual(result(1, -1), true);
}

- (void)testOperatorGEqual {
    npp::array<int> a{{1, 2, 3}, {4, 5, 600}};
    npp::array<int> a1{{10, 2, 30}, {4, 5, 60}};

    auto result = a >= a1;
    XCTAssertEqual(result.size(), 6);
    XCTAssertEqual(result.shape().ndims(), 2);
    XCTAssertEqual(result.shape()[0], 2);
    XCTAssertEqual(result.shape()[1], 3);
    
    XCTAssertEqual(result(0, 0), false);
    XCTAssertEqual(result(0, 1), true);
    XCTAssertEqual(result(1, -1), true);
}

- (void)testOperatorLess {
    npp::array<int> a{{1, 2, 3}, {4, 5, 600}};
    npp::array<int> a1{{10, 2, 30}, {4, 5, 60}};

    auto result = a < a1;
    XCTAssertEqual(result.size(), 6);
    XCTAssertEqual(result.shape().ndims(), 2);
    XCTAssertEqual(result.shape()[0], 2);
    XCTAssertEqual(result.shape()[1], 3);
    
    XCTAssertEqual(result(0, 0), true);
    XCTAssertEqual(result(0, 1), false);
    XCTAssertEqual(result(1, -1), false);
}

- (void)testOperatorLEqual {
    npp::array<int> a{{1, 2, 3}, {4, 5, 600}};
    npp::array<int> a1{{10, 2, 30}, {4, 5, 60}};

    auto result = a <= a1;
    XCTAssertEqual(result.size(), 6);
    XCTAssertEqual(result.shape().ndims(), 2);
    XCTAssertEqual(result.shape()[0], 2);
    XCTAssertEqual(result.shape()[1], 3);
    
    XCTAssertEqual(result(0, 0), true);
    XCTAssertEqual(result(0, 1), true);
    XCTAssertEqual(result(1, -1), false);
}

- (void)testOperatorPlusElement {
    npp::array<int> a{{1, 2, 3}, {4, 5, 600}};

    auto result = a + 1;
    XCTAssertEqual(result.size(), 6);
    XCTAssertEqual(result.shape().ndims(), 2);
    XCTAssertEqual(result.shape()[0], 2);
    XCTAssertEqual(result.shape()[1], 3);
    
    XCTAssertEqual(result(0, 0), 2);
    XCTAssertEqual(result(0, 1), 3);
    XCTAssertEqual(result(1, -1), 601);
}

- (void)testOperatorMinusElement {
    npp::array<int> a{{1, 2, 3}, {4, 5, 600}};

    auto result = a - 1;
    XCTAssertEqual(result.size(), 6);
    XCTAssertEqual(result.shape().ndims(), 2);
    XCTAssertEqual(result.shape()[0], 2);
    XCTAssertEqual(result.shape()[1], 3);
    
    XCTAssertEqual(result(0, 0), 0);
    XCTAssertEqual(result(0, 1), 1);
    XCTAssertEqual(result(1, -1), 599);
}

- (void)testOperatorMultElement {
    npp::array<int> a{{1, 2, 3}, {4, 5, 600}};

    auto result = a * 2;
    XCTAssertEqual(result.size(), 6);
    XCTAssertEqual(result.shape().ndims(), 2);
    XCTAssertEqual(result.shape()[0], 2);
    XCTAssertEqual(result.shape()[1], 3);
    
    XCTAssertEqual(result(0, 0), 2);
    XCTAssertEqual(result(0, 1), 4);
    XCTAssertEqual(result(1, -1), 1200);
}

- (void)testOperatorDivElement {
    npp::array<int> a{{1, 2, 3}, {4, 5, 600}};

    auto result = a / 2;
    XCTAssertEqual(result.size(), 6);
    XCTAssertEqual(result.shape().ndims(), 2);
    XCTAssertEqual(result.shape()[0], 2);
    XCTAssertEqual(result.shape()[1], 3);
    
    XCTAssertEqual(result(0, 0), 0);
    XCTAssertEqual(result(0, 1), 1);
    XCTAssertEqual(result(1, -1), 300);
}

- (void)testOperatorRemainderElement {
    npp::array<int> a{{1, 2, 3}, {4, 5, 600}};

    auto result = a % 2;
    XCTAssertEqual(result.size(), 6);
    XCTAssertEqual(result.shape().ndims(), 2);
    XCTAssertEqual(result.shape()[0], 2);
    XCTAssertEqual(result.shape()[1], 3);
    
    XCTAssertEqual(result(0, 0), 1);
    XCTAssertEqual(result(0, 1), 0);
    XCTAssertEqual(result(1, -1), 0);
}

- (void)testOperatorEqualElement {
    npp::array<int> a{{1, 2, 3}, {4, 5, 600}};

    auto result = a == 2;
    XCTAssertEqual(result.size(), 6);
    XCTAssertEqual(result.shape().ndims(), 2);
    XCTAssertEqual(result.shape()[0], 2);
    XCTAssertEqual(result.shape()[1], 3);
    
    XCTAssertEqual(result(0, 0), false);
    XCTAssertEqual(result(0, 1), true);
    XCTAssertEqual(result(1, -1), false);
}

- (void)testOperatorGreaterElement {
    npp::array<int> a{{1, 2, 3}, {4, 5, 600}};

    auto result = a > 2;
    XCTAssertEqual(result.size(), 6);
    XCTAssertEqual(result.shape().ndims(), 2);
    XCTAssertEqual(result.shape()[0], 2);
    XCTAssertEqual(result.shape()[1], 3);
    
    XCTAssertEqual(result(0, 0), false);
    XCTAssertEqual(result(0, 1), false);
    XCTAssertEqual(result(1, -1), true);
}

- (void)testOperatorGEqualElement {
    npp::array<int> a{{1, 2, 3}, {4, 5, 600}};

    auto result = a >= 2;
    XCTAssertEqual(result.size(), 6);
    XCTAssertEqual(result.shape().ndims(), 2);
    XCTAssertEqual(result.shape()[0], 2);
    XCTAssertEqual(result.shape()[1], 3);
    
    XCTAssertEqual(result(0, 0), false);
    XCTAssertEqual(result(0, 1), true);
    XCTAssertEqual(result(1, -1), true);
}

- (void)testOperatorLessElement {
    npp::array<int> a{{1, 2, 3}, {4, 5, 600}};

    auto result = a < 2;
    XCTAssertEqual(result.size(), 6);
    XCTAssertEqual(result.shape().ndims(), 2);
    XCTAssertEqual(result.shape()[0], 2);
    XCTAssertEqual(result.shape()[1], 3);
    
    XCTAssertEqual(result(0, 0), true);
    XCTAssertEqual(result(0, 1), false);
    XCTAssertEqual(result(1, -1), false);
}

- (void)testOperatorLEqualElement {
    npp::array<int> a{{1, 2, 3}, {4, 5, 600}};

    auto result = a <= 2;
    XCTAssertEqual(result.size(), 6);
    XCTAssertEqual(result.shape().ndims(), 2);
    XCTAssertEqual(result.shape()[0], 2);
    XCTAssertEqual(result.shape()[1], 3);
    
    XCTAssertEqual(result(0, 0), true);
    XCTAssertEqual(result(0, 1), true);
    XCTAssertEqual(result(1, -1), false);
}

- (void)testAll {
    npp::array<char> a{{false, false, false}, {false, false, false}};
    npp::array<char> a1{{true, true, true}, {true, true, true}};
    npp::array<char> a2{{true, true, true}, {true, true, false}};
    
    XCTAssertFalse(a.all());
    XCTAssertTrue(a1.all());
    XCTAssertFalse(a2.all());
}

- (void)testAny {
    npp::array<char> a{{false, false, false}, {false, false, false}};
    npp::array<char> a1{{true, true, true}, {true, true, true}};
    npp::array<char> a2{{true, true, true}, {true, true, false}};
    
    XCTAssertFalse(a.any());
    XCTAssertTrue(a1.any());
    XCTAssertTrue(a2.any());
}


- (void)testException {
    npp::array<int> a{{1, 2, 3}, {4, 5, 600}};
    npp::array<int> a1{{1, 2}, {4, 5}};
    
    try {
        auto result = a + a1;
        XCTAssertTrue(false);
        
    } catch (npp::DimensionsMismatchError) {
        XCTAssertTrue(true);
    } catch (...) {
        XCTAssertTrue(false);
    }
}

@end


@interface ArrayDotTests : XCTestCase

@end

@implementation ArrayDotTests

- (void)test1Dot1 {
    npp::array<double> a1{1, 2, 3};
    npp::array<double> a2{4, 5, 6};
    
    auto result = a1.dot(a2);
    XCTAssertEqual(result.shape().ndims(), 1);
    XCTAssertEqual(result.shape()[0], 1);
    XCTAssertEqual(result(0), 32);
}

- (void)test1Dot2 {
    npp::array<double> a1{1, 2, 3};
    npp::array<double> a2{{4, 5}, {6, 7}, {8, 9}};
    
    
    auto result = a1.dot(a2);
    XCTAssertEqual(result.shape().ndims(), 1);
    XCTAssertEqual(result.shape()[0], 2);
    XCTAssertEqual(result(0), 40);
    XCTAssertEqual(result(1), 46);
}

- (void)test2Dot1 {
    npp::array<double> a1{{1, 2, 3}, {4, 5, 6}};
    npp::array<double> a2{7, 8, 9};
    
    auto result = a1.dot(a2);
    XCTAssertEqual(result.shape().ndims(), 1);
    XCTAssertEqual(result.shape()[0], 2);
    XCTAssertEqual(result(0), 50);
    XCTAssertEqual(result(1), 122);
}

- (void)test2Dot2 {
    npp::array<double> a1{{1, 2, 3}, {4, 5, 6}};
    npp::array<double> a2{{7, 8}, {9, 10}, {11, 12}};
    
    auto result = a1.dot(a2);
    XCTAssertEqual(result.shape().ndims(), 2);
    XCTAssertEqual(result.shape()[0], 2);
    XCTAssertEqual(result.shape()[1], 2);
    XCTAssertEqual(result(0, 0), 58);
    XCTAssertEqual(result(0, 1), 64);
    XCTAssertEqual(result(1, 0), 139);
    XCTAssertEqual(result(1, 1), 154);
}

- (void)testExceptions {
    try { // > 2 dims
        npp::array<double> a1{{1, 2, 3}, {4, 5, 6}, {4, 5, 6}};
        npp::array<double> a2{{{7, 8}, {9, 10}},
                            {{7, 8}, {9, 10}}};
        a1.dot(a2);
        XCTAssertTrue(false);
    } catch (npp::DimensionsMismatchError) {
        XCTAssertTrue(true);
    } catch (...) {
        XCTAssertTrue(false);
    }
    
    try { // 1dot1
        npp::array<double> a1{1, 2, 3};
        npp::array<double> a2{7, 8};
        a1.dot(a2);
        XCTAssertTrue(false);
    } catch (npp::DimensionsMismatchError) {
        XCTAssertTrue(true);
    } catch (...) {
        XCTAssertTrue(false);
    }
    
    try { // 1dot2
        npp::array<double> a1{1, 2, 3};
        npp::array<double> a2{{7, 8}, {9, 10}};
        a1.dot(a2);
        XCTAssertTrue(false);
    } catch (npp::DimensionsMismatchError) {
        XCTAssertTrue(true);
    } catch (...) {
        XCTAssertTrue(false);
    }
    
    try { // 2dot1
        npp::array<double> a1{{7, 8}, {9, 10}, {9, 10}};
        npp::array<double> a2{1, 2, 3};
        a1.dot(a2);
        XCTAssertTrue(false);
    } catch (npp::DimensionsMismatchError) {
        XCTAssertTrue(true);
    } catch (...) {
        XCTAssertTrue(false);
    }
    
    try { // 2dot2
        npp::array<double> a1{{7, 8}, {9, 10}, {9, 10}};
        npp::array<double> a2{{7, 8}, {9, 10}, {9, 10}};
        a1.dot(a2);
        XCTAssertTrue(false);
    } catch (npp::DimensionsMismatchError) {
        XCTAssertTrue(true);
    } catch (...) {
        XCTAssertTrue(false);
    }
}



@end
