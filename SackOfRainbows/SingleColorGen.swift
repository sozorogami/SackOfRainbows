import Foundation

public struct SingleColorGen: ColorGenerator {
    private var color: UIColor
    private var repeatType: RepeatType
    private var step: Int

    init() {
        repeatType = .Times(1)
        step = 0
        color = white
    }

    init(color: UIColor) {
        self.init()
        self.color = color
    }

    private init(color: UIColor, repeatType: RepeatType, step: Int) {
        self.color = color
        self.repeatType = repeatType
        self.step = step
    }

    public mutating func reset() {
        step = 0
    }

    public mutating func next() -> UIColor? {
        switch repeatType {
        case let .Times(maxStep):
            if step < maxStep {
                step++
                return color
            }
        case .Forever:
            return color
        }
        return nil
    }

    public func times(i: Int) -> SingleColorGen {
        assert(i > 0, "Number of times must be greater than 0")
        return SingleColorGen(color: color, repeatType: .Times(i), step: step)
    }

    public func forever() -> SingleColorGen {
        return SingleColorGen(color: color, repeatType: .Forever, step: step)
    }
}