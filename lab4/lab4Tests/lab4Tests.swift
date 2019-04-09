//
//  lab4Tests.swift
//  lab4Tests
//
//  Created by Ilya Sysoi on 4/9/19.
//  Copyright © 2019 isysoi. All rights reserved.
//

import XCTest

class lab4Tests: XCTestCase {

    func testCastePitveraAlgorithm() {
        let actual = RasterAlgorithmsService().castePitveraAlgorithm(startPoint: CGPoint(x: 0, y: 0), finishPoint: CGPoint(x: 5, y: 4))
        let expected = [CGPoint(x: 0.0, y: 0.0),
                        CGPoint(x: 1.0, y: 1.0),
                        CGPoint(x: 2.0, y: 2.0),
                        CGPoint(x: 3.0, y: 2.0),
                        CGPoint(x: 4.0, y: 3.0),
                        CGPoint(x: 5.0, y: 4.0)]
        XCTAssert(actual == expected)
    }
    
    
    func testStepByStep() {
        let actual = RasterAlgorithmsService().stepByStep(startPoint: CGPoint(x: 0, y: 0), finishPoint: CGPoint(x: 5, y: 4))
        let expected = [CGPoint(x: 0.0, y: 0.0),
                        CGPoint(x: 1.0, y: 0.0),
                        CGPoint(x: 2.0, y: 1.0),
                        CGPoint(x: 3.0, y: 2.0),
                        CGPoint(x: 4.0, y: 3.0),
                        CGPoint(x: 5.0, y: 4.0)]
        XCTAssert(actual == expected)
    }
    
    func testBresenhamLine() {
        let actual = RasterAlgorithmsService().bresenhamLine(startPoint: CGPoint(x: 0, y: 0), finishPoint: CGPoint(x: 5, y: 4))
        let expected = [CGPoint(x: 0.0, y: 0.0),
                        CGPoint(x: 1.0, y: 1.0),
                        CGPoint(x: 2.0, y: 2.0),
                        CGPoint(x: 3.0, y: 2.0),
                        CGPoint(x: 4.0, y: 3.0),
                        CGPoint(x: 5.0, y: 4.0)]
        XCTAssert(actual == expected)
    }
    
    func testDDA() {
        let actual = RasterAlgorithmsService().digitalDifferentialAnalyzer(startPoint: CGPoint(x: 0, y: 0), finishPoint: CGPoint(x: 5, y: 4))
        let expected = [CGPoint(x: 0.0, y: 0.0),
                        CGPoint(x: 1.0, y: 1.0),
                        CGPoint(x: 2.0, y: 2.0),
                        CGPoint(x: 3.0, y: 2.0),
                        CGPoint(x: 4.0, y: 3.0),
                        CGPoint(x: 5.0, y: 4.0)]
        XCTAssert(actual == expected)
    }
    
    func testBresenhamLineAndDDA() {
        let actual = RasterAlgorithmsService().bresenhamLine(startPoint: CGPoint(x: 0, y: 0), finishPoint: CGPoint(x: 5, y: 4))
        let expected = RasterAlgorithmsService().digitalDifferentialAnalyzer(startPoint: CGPoint(x: 0, y: 0), finishPoint: CGPoint(x: 5, y: 4))
        XCTAssert(actual == expected)
    }

}
