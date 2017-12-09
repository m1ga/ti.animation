# Ti.Animation [![Build Status](https://travis-ci.org/m1ga/ti.animation.svg?branch=master)](https://travis-ci.org/m1ga/ti.animation)

![gif](animation.gif)

Appcelerator Titanium Android module for [Facebooks Keyframes](https://github.com/facebookincubator/Keyframes) libray and for [Airbnb Lottie](https://github.com/airbnb/lottie-android). 

## Requirements
- Titanium Mobile SDK 6.0.0.GA or later

## Library versions:
The Titanium modules use external libraries

|Library|Platform|Version|Build Date|
|---|---|---|---|
| [Facebooks Keyframes](https://github.com/facebookincubator/Keyframes) | Android | 1.0.0 | 2017/02/11 |
| [Facebooks Keyframes](https://github.com/facebookincubator/Keyframes) | iOS | 1.0.0 | 2017/02/11 |
| [Airbnb Lottie](https://github.com/airbnb/lottie-android) | Android | 2.3.1 | 2017/12/09 |
| [Airbnb Lottie](https://github.com/airbnb/lottie-ios) | iOS | 2.1.5 | 2017/12/09 |


## Choose your view
### Lottie
```js
var animation = TiAnimation.createLottieView({
    file: 'file.json',
    loop: false,
    autoStart: false
});
```
### Keyframes
```js
var animation = TiAnimation.createKeyframeView({
    file: 'file.json',
    loop: false,
    autoStart: false
});
```

## Features/Documentation
Visit the [wiki](https://github.com/m1ga/ti.animation/wiki) for the documentation.

## Example
Please see the basic example in `example/app.js`. More examples can found in the [wiki](https://github.com/m1ga/ti.animation/wiki)

## Resources
At [LottieFiles](http://www.lottiefiles.com/) you will find a list of free Lottie animations.

Authors
---------------
- Hans Knoechel ([@hansemannnn](https://twitter.com/hansemannnn) / [Web](http://hans-knoechel.de))
- Michael Gangolf ([@MichaelGangolf](https://twitter.com/MichaelGangolf) / [Web](http://migaweb.de))
