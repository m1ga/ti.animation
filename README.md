# Ti.Animation

![gif](animation.gif)

Appcelerator Titanium Android module for [Facebooks Keyframes](https://github.com/facebookincubator/Keyframes) libray and for [Airbnb Lottie](https://github.com/airbnb/lottie-android). 

## Requirements
- Titanium Mobile SDK 6.0.0.GA or later

## Library versions:
The Titanium modules use external libraries

|Library|Build date|
|---|---|
| [Facebooks Keyframes Android](https://github.com/facebookincubator/Keyframes) | 11.02.2017 |
| [Airbnb Lottie Android](https://github.com/airbnb/lottie-android) | 11.02.2017 |
| [Facebooks Keyframes iOS](https://github.com/facebookincubator/Keyframes) | -  |
| [Airbnb Lottie iOS](https://github.com/airbnb/lottie-ios) |  - |


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
- start()
- play()
- stop()
- pause()
- resume()
- seekToProgress(percentage)
- getFrameRate()
- getFrameCount()

## Example
Please see the full-featured example in `example/app.js`.
