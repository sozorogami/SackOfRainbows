//
//  ParallelColorGen.swift
//  SackOfRainbows
//
//  Created by Tyler on 6/21/15.
//  Copyright © 2015 sozorogami. All rights reserved.
//

import Foundation

public struct ParallelColorGen: ColorGenerator {
    private var repeatType: RepeatType
    private var step: Int

    private var generators: Array<ColorGenerator>
    private var nextIndex: Int

    init(generators: [ColorGenerator]) {
        repeatType = .Times(1)
        step = 0
        self.generators = generators
        nextIndex = 0
    }

    private init(repeatType: RepeatType, step: Int, generators: Array<ColorGenerator>, nextIndex: Int) {
        self.repeatType = repeatType
        self.step = step
        self.generators = generators
        self.nextIndex = nextIndex
    }

    public mutating func reset() {
        nextIndex = 0
        generators = generators.map({g in
            var a = g;
            a.reset()
            return a
        })
    }

    public mutating func next() -> UIColor? {
        var shift = 0
        while shift < generators.count {
            let index = (nextIndex + shift) % generators.count;
            if let c = generators[index].next() {
                nextIndex += shift + 1
                return c
            }
            shift++
        }

        switch repeatType {
        case .Times(let maxStep):
            step++
            if step < maxStep {
                reset()
                return next()
            }
            return nil
        case .Forever:
            reset()
            return next()
        }
    }

    public func times(i: Int) -> ParallelColorGen {
        assert(i > 0, "Number of times must be greater than 0")
        return ParallelColorGen(repeatType: .Times(i), step: step, generators: generators, nextIndex: nextIndex)
    }

    public func forever() -> ParallelColorGen {
        return ParallelColorGen(repeatType: .Forever, step: step, generators: generators, nextIndex: nextIndex)
    }
}
