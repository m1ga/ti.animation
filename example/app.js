const TiAnimation = require('ti.animation');
const win = Ti.UI.createWindow();
const view = TiAnimation.createAnimationView({
	file: 'https://migaweb.de/sample_lottie.json',
	loop: false,
	height: 120,
	width: 120,
	borderRadius: 60,
	autoStart: true,
	speed: 2,
	loop: true
});

win.add(view);
win.open();
