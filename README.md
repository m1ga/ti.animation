# Ti.Animation

![gif](animation.gif)

Appcelerator Titanium Android module for [Facebooks Keyframes](https://github.com/facebookincubator/Keyframes) libray and for [Airbnb Lottie](https://github.com/airbnb/lottie-android). 

## Requirements
- Titanium Mobile SDK 6.0.0.GA or later

## Choose your view
### Lottie
```js
var animation = TiAnimation.createLottieView();
```
### Keyframes
```js
var animation = TiAnimation.createKeyframeView();
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
