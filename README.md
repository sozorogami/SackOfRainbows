# SackOfRainbows #

`SackOfRainbows` provides an expressive syntax for creating color generators. Chain generators in serial or parallel to easily produce gradients and complex patterns.

## Installation ##

*`SackOfRainbows` is written in Swift 2.0 and requires Xcode 7.*

### Via Cocoapods ###

Add the following line to your Podfile and run `pod install`.

```
pod 'SackOfRainbows'
```

## Usage ##

### The basics ###

To make a single color, use `theColor()`. All your favorite `UIColor`s have been aliased for easy use.

```swift
var redGenerator = theColor(red)
redGenerator.next() // returns red
redGenerator.next() // returns nil
```

You can generate a bunch of colors in order using `theColors()` like so:

```swift
var rainbow = theColors(red, orange, yellow, green, blue,
    UIColor(red: 0.29, green: 0.0, blue: 0.51, alpha: 1), purple)
rainbow.next() // returns red
rainbow.next() // returns orange
rainbow.next() // returns yellow
// ...
```

Making a series of colors in a gradient is easy as well. Just indicate the start color, end color, and how many steps start to finish.

``` swift
var tequilaSunrise = gradient().from(orange).to(red).steps(10)
tequilaSunrise.next() // returns orange
tequilaSunrise.next() // returns a slightly reddish orange
tequilaSunrise.next() // returns a slightly more reddish orange
// ...
```
![basic](https://cloud.githubusercontent.com/assets/1407680/8275961/7442efb4-187d-11e5-80c8-02ff6717df6d.png)


### Chaining ###

To chain generators in sequence, use `then()`.

``` swift
let batman = theColors(blue, black)
let robin = theColors(yellow, green, red)
var batmanAndRobin = batman.then(robin)
```

To chain in parallel, use `alternate()`.
``` swift
var olympics = alternate(batman, robin)
```

![batlympics](https://cloud.githubusercontent.com/assets/1407680/8286899/6ad39bba-18da-11e5-9f42-a94c307cbaec.png)


### Repeating ###

Repeat a fixed number of times with `times()`.

``` swift
var doubleRainbow = rainbow.times(2)
```
![doublerainbow](https://cloud.githubusercontent.com/assets/1407680/8276037/fa02d898-187e-11e5-8954-1c9380e99248.gif)

To enter a world of endless color, use `forever()`.
``` swift
let blueToWhite = gradient().from(blue).to(white).steps(10)
let whiteToBlue = gradient().from(white).to(blue).steps(10)
var allTheWayAcrossTheSky = blueToWhite.then(whiteToBlue).forever()
```
![alltheway](https://cloud.githubusercontent.com/assets/1407680/8276038/fb406c48-187e-11e5-9618-c0dd0b44232a.gif)

## License

SackOfRainbows is released under the [MIT License](https://github.com/sozorogami/SackOfRainbows/blob/master/LICENSE.txt).
