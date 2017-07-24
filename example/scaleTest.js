var TiAnimation = require('ti.animation');
var isAndroid = (Ti.Platform.osname == 'android');

var win = Ti.UI.createWindow({
	backgroundColor: '#fff',
	title: '',
	fullscreen: true
});

var scroller = Ti.UI.createScrollView({
	width: Ti.UI.FILL,
	height: Ti.UI.FILL,
	layout: "vertical"
})

var ani1 = TiAnimation.createLottieView({
	file: 'sample_lottie.json',
	top: 5,
	loop: true,
	width: 200,
	height: 200,
	borderWidth: 1,
	borderColor: "#000",
	autoStart: true
});
var ani2 = TiAnimation.createLottieView({
	file: 'sample_lottie.json',
	top: 5,
	loop: true,
	width: 20,
	height: 20,
	borderWidth: 1,
	borderColor: "#000",
	autoStart: true
});
var ani3 = TiAnimation.createLottieView({
	file: 'sample_lottie.json',
	top: 5,
	loop: true,
	width: 200,
	height: 20,
	borderWidth: 1,
	borderColor: "#000",
	autoStart: true
});
var ani4 = TiAnimation.createLottieView({
	file: 'sample_lottie.json',
	top: 5,
	loop: true,
	width: 320,
	height: 50,
	borderWidth: 1,
	borderColor: "#000",
	autoStart: true,
	scaleMode: "centerCrop"
});
var ani5 = TiAnimation.createLottieView({
	file: 'sample_lottie.json',
	top: 5,
	loop: true,
	width: 320,
	height: 50,
	borderWidth: 1,
	borderColor: "#000",
	autoStart: true
});

scroller.add(ani1);
scroller.add(ani2);
scroller.add(ani3);
scroller.add(ani4);
scroller.add(ani5);
win.add(scroller);

win.open();
