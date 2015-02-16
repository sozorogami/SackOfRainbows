import Quick
import Nimble
import SackOfRainbows

extension ColorGenerator {
    mutating func repeats(period period: Int, times: Int) -> Bool {
        var timesRemaining = times - 1
        var firstColors: [UIColor] = []
        for _ in 0..<period {
            if let color = next() {
                firstColors.append(color)
            } else {
                return false
            }
        }
        while timesRemaining > 0 {
            for color in firstColors {
                if let testColor = next() {
                    if !color.isEqual(testColor) {
                        return false
                    }
                } else {
                    return false
                }
            }
            timesRemaining--
        }
        return true;
    }
}

class SackOfRainbowsTests: QuickSpec {
    override func spec() {
        describe("Sack of rainbows") {
            describe("theColor") {
                it("generates a color once") {
                    var redColor = theColor(red)
                    expect{redColor.next()}.to(equal(red))
                    expect{redColor.next()}.to(beNil())
                }

                context("when it is set to run a particular number of times") {
                    it("generates the color that many times") {
                        var tripleRed = theColor(red).times(3)
                        expect{tripleRed.next()}.to(equal(red))
                        expect{tripleRed.next()}.to(equal(red))
                        expect{tripleRed.next()}.to(equal(red))
                        expect{tripleRed.next()}.to(beNil())
                    }
                }


                context("when it is set to run forever") {
                    it("generates the same color endlessly") {
                        var infiniteRed = theColor(red).times(20)
                        let repeatsIndefinitely = infiniteRed.repeats(period: 1, times: 20)
                        expect(repeatsIndefinitely).to(beTrue())
                    }
                }
            }

            describe("theColors") {
                context("when given a single color") {
                    it("creates a single color generator") {
                        var oneColor = theColors(gray) as! SingleColorGen
                        expect(oneColor.next()).to(equal(gray))
                        expect(oneColor.next()).to(beNil())
                    }
                }
                context("when given multiple colors") {
                    it("chains them as generators in sequence") {
                        var newspaper = theColors(black, white, red) as! SerialColorGen
                        expect(newspaper.next()).to(equal(black))
                        expect(newspaper.next()).to(equal(white))
                        expect(newspaper.next()).to(equal(red))
                        expect(newspaper.next()).to(beNil())
                    }
                }
            }

            describe("then") {
                it("chains two generators in sequence") {
                    var redThenBlue = theColor(red).then(theColor(blue))
                    expect(redThenBlue.next()).to(equal(red))
                    expect(redThenBlue.next()).to(equal(blue))
                    expect(redThenBlue.next()).to(beNil())
                }

                context("when the first generator runs multiple times") {
                    it("runs until empty, then moves to the second") {
                        var red2thenBlue = theColor(red).times(2).then(theColor(blue))
                        expect(red2thenBlue.next()).to(equal(red))
                        expect(red2thenBlue.next()).to(equal(red))
                        expect(red2thenBlue.next()).to(equal(blue))
                        expect(red2thenBlue.next()).to(beNil())
                    }
                }

                context("when it is set to run a particular number of times") {
                    it("runs that many times, then returns nil") {
                        var redThenBlueFiveTimes = theColor(red).then(theColor(blue)).times(5)
                        let repeatsFiveTimes = redThenBlueFiveTimes.repeats(period: 2, times: 5)
                        expect(repeatsFiveTimes).to(beTrue())
                        expect(redThenBlueFiveTimes.next()).to(beNil())
                    }
                }

                context("when it is set to run forever") {
                    it("returns the generators in sequence forever") {
                        var redThenBlueForever = theColor(red).then(theColor(blue)).forever()
                        let repeatsForever = redThenBlueForever.repeats(period: 2, times: 25)
                        expect(repeatsForever).to(beTrue())
                    }
                }
            }

            describe("alternate") {
                it("chains multiple generators in paralell") {
                    let red2 = theColor(red).times(2)
                    let white2 = theColor(white).times(2)
                    let blue2 = theColor(blue).times(2)
                    var usa = alternate(red2, white2, blue2)

                    expect(usa.next()).to(equal(red))
                    expect(usa.next()).to(equal(white))
                    expect(usa.next()).to(equal(blue))
                    expect(usa.next()).to(equal(red))
                    expect(usa.next()).to(equal(white))
                    expect(usa.next()).to(equal(blue))
                    expect(usa.next()).to(beNil())
                }

                context("when it is set to run a particular number of times") {
                    it("runs that many times, then returns nil") {
                        let red2 = theColor(red).times(2)
                        let white2 = theColor(white).times(2)
                        let blue2 = theColor(blue).times(2)
                        var uk = alternate(red2, white2, blue2).times(2)
                        let repeatsTwice = uk.repeats(period: 6, times: 2)
                        expect(repeatsTwice).to(beTrue())
                        expect(uk.next()).to(beNil())
                    }
                }

                context("when a generator runs out of colors") {
                    it("skips it") {
                        let threeReds = theColors(red, red, red)
                        let twoBlues = theColors(blue, blue)
                        let oneYellow = theColor(yellow)
                        var alternator = alternate(threeReds, twoBlues, oneYellow)
                        expect(alternator.next()).to(equal(red))
                        expect(alternator.next()).to(equal(blue))
                        expect(alternator.next()).to(equal(yellow))
                        expect(alternator.next()).to(equal(red))
                        expect(alternator.next()).to(equal(blue))
                        expect(alternator.next()).to(equal(red))
                        expect(alternator.next()).to(beNil())
                    }
                }

                context("when it is set to run forever") {
                    it("alternates through the generators indefinitely") {
                        let threeReds = theColors(red, red, red)
                        var alternator = alternate(threeReds, theColor(orange)).forever()
                        expect(alternator.repeats(period: 4, times: 25)).to(beTrue())
                    }
                }
            }

            describe("gradients") {
                let midwayColor = UIColor(red: 0.5, green: 0.0, blue: 0.5, alpha: 1)

                it("generates colors in a gradient between the start and end color") {
                    var aGradient = gradient().from(red).to(blue).steps(3)
                    let firstColor = aGradient.next()
                    let secondColor = aGradient.next()
                    let thirdColor = aGradient.next()

                    expect(firstColor).to(equal(red))
                    expect(secondColor).to(equal(midwayColor))
                    expect(thirdColor).to(equal(blue))
                }

                context("when there is one step to the gradient") {
                    it("returns the start color") {
                        var barelyAGradient = gradient().from(red).to(blue).steps(1)
                        expect(barelyAGradient.next()).to(equal(red))
                        expect(barelyAGradient.next()).to(beNil())
                    }
                }

                context("when it is set to run a particular number of times") {
                    it("repeats that many times, then returns nil") {
                        var repeatingGradient = gradient().from(red).to(blue).steps(3).times(5)
                        let repeatsFiveTimes = repeatingGradient.repeats(period: 3, times: 5)
                        expect(repeatsFiveTimes).to(beTrue())
                        expect(repeatingGradient.next()).to(beNil())
                    }
                }

                context("when it is set to run forever") {
                    it("repeats the gradient forever") {
                        var foreverGradient = gradient().from(red).to(blue).steps(3).forever()
                        let repeatsForever = foreverGradient.repeats(period: 3, times: 30)
                        expect(repeatsForever).to(beTrue())
                    }
                }
            }
        }
    }
}
