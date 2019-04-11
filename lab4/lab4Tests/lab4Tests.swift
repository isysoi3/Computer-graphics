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

    func testTime() {
        let startPoint = CGPoint(x: -100, y: -25)
        let finishPoint = CGPoint(x: 100, y: 15)
        let timeService = TimeService()
        let t = RasterAlgorithmsService()
        timeService.timeMeasure {
            t.stepByStep(startPoint: startPoint, finishPoint: finishPoint)
            return "stepByStep"
        }
        timeService.timeMeasure {
            t.digitalDifferentialAnalyzer(startPoint: startPoint, finishPoint: finishPoint)
            return "digitalDifferentialAnalyzer"
        }
        timeService.timeMeasure {
            t.bresenhamLine(startPoint: startPoint, finishPoint: finishPoint)
            return "bresenhamLine"
        }
        timeService.timeMeasure {
            t.castePitveraAlgorithm(startPoint: startPoint, finishPoint: finishPoint)
            return "castePitveraAlgorithm"
        }
        timeService.timeMeasure {
            t.bresenhamCircle(centerPoint: startPoint, radius: CGPoint.distance(startPoint, finishPoint))
            return "bresenhamCircle"
        }
    }
    
}

/*
Time for "stepByStep":                  0.0003579854965209961 seconds
Time for "digitalDifferentialAnalyzer": 0.0003459453582763672 seconds
Time for "bresenhamLine":               0.00007891654         seconds
Time for "castePitveraAlgorithm":       0.0021439790725708008 seconds
Time for "bresenhamCircle":             0.0004138946533203125 seconds
 */
