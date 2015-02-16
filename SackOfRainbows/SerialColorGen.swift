//
//  SerialColorGen.swift
//  SackOfRainbows
//
//  Created by Tyler on 6/21/15.
//  Copyright © 2015 sozorogami. All rights reserved.
//

import Foundation

public struct SerialColorGen: ColorGenerator {
    private var repeatType: RepeatType
    private var step: Int

    private var generators: Array<ColorGenerator>

    init(gen1: ColorGenerator, gen2: ColorGenerator) {
        self.repeatType = .Times(1)
        self.step = 0
        generators = [gen1, gen2]
    }

    private init(repeatType: RepeatType, step: Int, gen1: ColorGenerator, gen2: ColorGenerator) {
        self.repeatType = repeatType
        self.step = step
        generators = [gen1, gen2]
    }

    public mutating func reset() {
        generators[0].reset()
        generators[1].reset()
    }

    public mutating func next() -> UIColor? {
        if let a = generators[0].next() {
            return a
        }
        if let b = generators[1].next() {
            return b
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

    public func times(i: Int) -> SerialColorGen {
        assert(i > 0, "Number of times must be greater than 0")
        return SerialColorGen(repeatType: .Times(i), step: step, gen1: generators[0], gen2: generators[1])
    }

    public func forever() -> SerialColorGen {
        return SerialColorGen(repeatType: .Forever, step: step, gen1: generators[0], gen2: generators[1])
    }
}
