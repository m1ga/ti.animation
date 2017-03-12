# Ti.Animation

![gif](animation.gif)

Appcelerator Titanium Android module for [Facebooks Keyframes](https://github.com/facebookincubator/Keyframes) libray and for [Airbnb Lottie](https://github.com/airbnb/lottie-android). 

## Requirements
- Titanium Mobile SDK 6.0.0.GA or later

## Library versions:
The Titanium modules use external libraries

|Library|Build date|
|---|---|
| [Facebooks Keyframes Android](https://github.com/facebookincubator/Keyframes) | 2017/02/11 |
| [Airbnb Lottie Android](https://github.com/airbnb/lottie-android) | 2017/02/24 |
| [Facebooks Keyframes iOS](https://github.com/facebookincubator/Keyframes) | 2017/02/11 |
| [Airbnb Lottie iOS](https://github.com/airbnb/lottie-ios) | 2017/02/11 |


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

## Features

#### Lottie/Keyframes:
_work in progress_
- start()
- stop()
- pause()
- getProgress()/setProgress(percentage)
- getDuration()/setDuration(ms)
- getSpeed()/setSpeed(float)
- isPlaying()

## Example
Please see the full-featured example in `example/app.js`.

## Ressources
At [LottieFiles](http://www.lottiefiles.com/) you will find a list of free Lottie animations.

Authors
---------------
- Hans Knoechel ([@hansemannnn](https://twitter.com/hansemannnn) / [Web](http://hans-knoechel.de))
- Michael Gangolf ([@MichaelGangolf](https://twitter.com/MichaelGangolf) / [Web](http://migaweb.de))
