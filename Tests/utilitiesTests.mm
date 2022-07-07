//
//  utilitiesTest.m
//  Tests
//
//  Created by Daniele Colombo on 06/07/2022.
//

#import <XCTest/XCTest.h>
#import "utilities.hpp"

@interface utilitiesTest : XCTestCase

@end

@implementation utilitiesTest

- (void)testDimensionsChecker {
    npp::DimensionsChecker<int> checker;
    XCTAssertNoThrow(checker.check<3>({
            {{1,  2,  3,  4},  {5,  6,  7,  8},  {9,  10, 11, 12}},
            {{13, 14, 15, 16}, {17, 18, 19, 20}, {21, 22, 23, 24}},
        })
    );

    XCTAssertNoThrow(checker.check<2>({{1,  2,  3,  4},  {5,  6,  7,  8},  {9,  10, 11, 12}}));

    XCTAssertNoThrow(checker.check<1>({1,  2,  3,  4}));

    XCTAssertThrows(checker.check<3>({
            {{1,  2,  3,  4},  {5,  6,  7,  8},  {9,  10, 11, 12}},
            {{13, 14, 15, 16}, {17, 18, 19, 20}, {21, 22, 23}},
        })
    );
    
    XCTAssertThrows(checker.check<3>({
            {{1,  2,  3,  4},  {5,  6,  7,  8},  {9,  10, 11, 12}},
            {{13, 14, 15, 16}, {17, 18, 19, 20}},
        })
    );
    
    XCTAssertThrows(checker.check<3>({
            {{1,  2,  3,  4},  {5,  6,  7,  8},  {9,  10, 11, 12}},
            {{13, 14, 15}, {17, 18, 19}, {21, 22, 23}},
        })
    );
}

@end
