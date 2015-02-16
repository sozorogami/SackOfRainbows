import Foundation

public struct GradientColorGen: ColorGenerator {
    private var repeatType: RepeatType
    private var step: Int

    private var gradientStep: Int
    private var maxGradientStep: Int
    private var startColor: UIColor
    private var endColor: UIColor

    init() {
        repeatType = .Times(1)
        step = 0
        gradientStep = 0
        maxGradientStep = 0
        startColor = UIColor.whiteColor()
        endColor = UIColor.whiteColor()
    }

    private init(repeatType: RepeatType, step: Int, gradientStep: Int, maxGradientStep: Int,
        startColor: UIColor, endColor: UIColor) {
            self.repeatType = repeatType
            self.step = step
            self.gradientStep = gradientStep
            self.maxGradientStep = maxGradientStep
            self.startColor = startColor
            self.endColor = endColor
    }

    public func steps(i: Int) -> GradientColorGen {
        return GradientColorGen(repeatType: repeatType, step: step, gradientStep: gradientStep, maxGradientStep: i, startColor: startColor, endColor: endColor)
    }

    public func from(color: UIColor) -> GradientColorGen {
        return GradientColorGen(repeatType: repeatType, step: step, gradientStep: gradientStep,
            maxGradientStep: maxGradientStep, startColor: color, endColor: endColor)
    }

    public func to(color: UIColor) -> GradientColorGen {
        return GradientColorGen(repeatType: repeatType, step: step, gradientStep: gradientStep,
            maxGradientStep: maxGradientStep, startColor: startColor, endColor: color)
    }

    public mutating func reset() {
        step = 0
        gradientStep = 0
    }

    public mutating func next() -> UIColor? {
        if gradientStep >= maxGradientStep {
            switch repeatType {
            case .Forever:
                gradientStep = 0
            case let .Times(maxStep):
                step++
                if step < maxStep {
                    gradientStep = 0
                } else {
                    return nil
                }
            }
        }

        if maxGradientStep <= 1 {
            gradientStep = maxGradientStep
            return startColor
        }

        let ratio: CGFloat = CGFloat(gradientStep) / CGFloat(maxGradientStep - 1)
        let startRGBA = rgbaValues(startColor)
        let endRGBA = rgbaValues(endColor)
        let deltas = (startRGBA.r + ((endRGBA.r - startRGBA.r) * ratio),
            startRGBA.g + ((endRGBA.g - startRGBA.g) * ratio),
            startRGBA.b + ((endRGBA.b - startRGBA.b) * ratio),
            startRGBA.a + ((endRGBA.a - startRGBA.a) * ratio))
        gradientStep++
        return colorFromRGBAValues(deltas)
    }

    public func times(i: Int) -> GradientColorGen {
        assert(i > 0, "Number of times must be greater than 0")
        return GradientColorGen(repeatType: .Times(i), step: step, gradientStep: gradientStep,
            maxGradientStep: maxGradientStep, startColor: startColor, endColor: endColor)
    }

    public func forever() -> GradientColorGen {
        return GradientColorGen(repeatType: .Forever, step: step, gradientStep: gradientStep,
            maxGradientStep: maxGradientStep, startColor: startColor, endColor: endColor)
    }
}

private func rgbaValues(color: UIColor) -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
    var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
    color.getRed(&r, green: &g, blue: &b, alpha: &a)
    return (r, g, b, a)
}

private func colorFromRGBAValues(rgba :(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)) -> UIColor {
    return UIColor(red: rgba.r, green: rgba.g, blue: rgba.b, alpha: rgba.a)
}