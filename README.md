# Ti.Animation

<span class="badge-buymeacoffee"><a href="https://www.buymeacoffee.com/miga" title="donate"><img src="https://img.shields.io/badge/buy%20me%20a%20coke-donate-orange.svg" alt="Buy Me A Coke donate button" /></a></span>

![gif](animation.gif)


Appcelerator Titanium Android module to support smooth and scalable animations using [Airbnb Lottie](https://airbnb.design/lottie/).



> ⚠️ The versions iOS 2.0.0 and Android 3.0.0 contain a breaking change that removed the Facebook Keyframes library. We decided to go with a Lottie only library for the future, since it made the race for the best animation library. Also, the deprecated method `addViewToLayer` is now removed. Please continue to use `addViewToKeypathLayer`.

## Migrate from iOS < 2.0.0 and Android < 3.0.0

Instead of using `createLottieView`, simply use `createAnimationView` now. That's it!

## Requirements

- Axway Titanium SDK 7.0.0+
- Axway Titanium SDK 9.0.0+ for Ti.Animation 4.0.0+

## Library versions:

The Titanium modules use external libraries

|Library|Platform|Version|Build Date|
|---|---|---|---|
| [Airbnb Lottie](https://github.com/airbnb/lottie-android) | Android | 3.4.0 | 2020/02/22 |
| [Airbnb Lottie](https://github.com/airbnb/lottie-ios) | iOS | 2.5.2 | 2018/12/10 |


## Create a View

```js
var animation = TiAnimation.createAnimationView({
  file: '/file.json',
  loop: false,
  autoStart: false
});
```

or in Alloy:
```xml
<AnimationView id='view_lottie' module='ti.animation' />
```

## Update native Libraries

- iOS: Use Carthage and `carthage update` to compile the framework automatically. Then, copy the output from `ios/Carthage/Build/iOS` to `ios/platform/`.
- Android: change the version number in `build.gradle`

## Features/Documentation

Visit the [wiki](https://github.com/m1ga/ti.animation/wiki) for the documentation.

## Example

Please see the basic example in `example/app.js`. More examples can found in the [wiki](https://github.com/m1ga/ti.animation/wiki)

## Resources

* At [LottieFiles](http://www.lottiefiles.com/) you will find a list of free Lottie animations.
* Elephant animation by <a href="https://lottiefiles.com/user/266156">LottieFiles - weejkqwjlkejlk2</a>

## Authors

- Hans Knöchel ([@hansemannnn](https://twitter.com/hansemannnn) / [Web](http://hans-knoechel.de))
- Michael Gangolf ([@MichaelGangolf](https://twitter.com/MichaelGangolf) / [Web](http://migaweb.de))

<span class="badge-patreon"><a href="https://www.patreon.com/michaelgangolf" title="Donate to this project using Patreon"><img src="https://img.shields.io/badge/patreon-donate-yellow.svg" alt="Patreon donate button" /></a></span>
