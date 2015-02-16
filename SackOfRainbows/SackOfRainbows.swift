import Foundation

import UIKit

// MARK: - Public Interface

// We don't inherit from the Swift standard library's `GeneratorType` because doing so complicates generator nesting.
// Specifically, `SerialColorGen` and `ParallelColorGen` need to keep collections of `ColorGenerator`s, but Swift only
// allows protocols containing associated types to be used as generic constraints (not as types).
public protocol ColorGenerator {
    mutating func next() -> UIColor?
    mutating func reset()
    func times(i: Int) -> Self
    func forever() -> Self
    func then(nextGen: ColorGenerator) -> SerialColorGen
}

extension ColorGenerator {
    public func then(nextGen: ColorGenerator) -> SerialColorGen {
        return SerialColorGen(gen1: self, gen2: nextGen)
    }
}

enum RepeatType {
    case Times(Int)
    case Forever
}

public func theColor(color: UIColor) -> SingleColorGen {
    return SingleColorGen(color: color)
}

public func theColors(colors: UIColor...) -> ColorGenerator {
    return concatColors(colors)
}

public func gradient() -> GradientColorGen {
    return GradientColorGen()
}

public func alternate(generators: ColorGenerator...) -> ParallelColorGen {
    return ParallelColorGen(generators: generators)
}

// MARK: Private Methods

private func concatColors(colors: [UIColor]) -> ColorGenerator {
    let count = colors.count
    if count == 1 {
        return theColor(colors[0])
    }
    let tail = concatColors(Array(colors[1..<count]))
    return theColor(colors[0]).then(tail)
}