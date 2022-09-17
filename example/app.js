const TiAnimation = require('ti.animation');

const isAndroid = (Ti.Platform.osname === 'android');
let offset = 20;
let isDouble = false;

TiAnimation.newRenderingEngineEnabled = true; // iOS-only: Use the CoreAnimation background rendering engine instead of the main thread

const win = Ti.UI.createWindow({
		backgroundColor: '#fff',
		title: 'Ti.Animation Demo'
	}),
	lbl = Ti.UI.createLabel({
		bottom: 50,
		color: '#000',
		textAlign: Ti.UI.TEXT_ALIGNMENT_CENTER,
		font: {
			fontSize: 12
		}
	}),
	view = TiAnimation.createAnimationView({
		file: 'sample_lottie_new_rendering_engine.json',
		loop: false,
		bottom: 200,
		left: 30,
		height: 120,
		width: 120,
		borderRadius: 60,
		autoStart: false
	}),
	view2 = TiAnimation.createAnimationView({
		file: 'sample_lottie.json',
		loop: true,
		bottom: 200,
		right: 30,
		height: 120,
		width: 120,
		borderRadius: 60,
		autoStart: true
	}),
	slider = Ti.UI.createSlider({
		value: 0,
		min: 0,
		max: 1,
		bottom: 10,
		width: 300
	});

if (isAndroid) {
	view.addEventListener('update', function (e) {
		console.log('current frame: ' + e.frame);
	});
}
view.addEventListener('ready', function () {
	var dur = (isAndroid) ? view.duration : (Math.floor(view.duration * 1000));
	lbl.text = 'Lottie: Duration: ' + dur + 'ms\n';
});
view.addEventListener('complete', function () {
	console.log('view: complete');
});
view2.addEventListener('complete', function () {
	console.log('view2: complete');
});

slider.addEventListener('change', seekToProgress);

win.add([
	view, view2, lbl, createButtonWithAction('Start animation', startAnimation), createButtonWithAction('Pause animation', pauseAnimation),
	createButtonWithAction('Resume animation', resumeAnimation), createButtonWithAction('Double speed', doubleSpeed), createButtonWithAction('Get frame', getFrame), slider
]);

if (isAndroid) {
	win.open();
} else {
	var nav = Ti.UI.createNavigationWindow({
		window: win
	});
	nav.open();
}

function doubleSpeed(e) {
	if (isDouble) {
		e.source.title = 'Double speed';
		view.speed = 1;
	} else {
		e.source.title = 'Normal speed';
		view.speed = 2;
	}
	isDouble = !isDouble;
}

function seekToProgress(e) {
	view.progress = e.value;
}

function getFrame() {
	console.log('Current frame view-animation: ' + view.frame);
}

function createButtonWithAction(title, action) {
	var btn = Ti.UI.createButton({
		title: title,
		top: offset,
		height: 30,
		width: 200,
		borderRadius: 4,
		borderWidth: 1,
		borderColor: '#000',
		color: '#000',
		backgroundColor: '#fff'
	});

	btn.addEventListener('singletap', action);

	offset += 32;
	return btn;
}

function startAnimation() {
	view.start();
}

function pauseAnimation() {
	view.pause();
}

function resumeAnimation() {
	view.resume();
}
