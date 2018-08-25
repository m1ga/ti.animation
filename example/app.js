var TiAnimation = require('ti.animation');
var isAndroid = (Ti.Platform.osname == 'android');
var offset = 0;
var isDouble = false;

var win = Ti.UI.createWindow({
		backgroundColor: '#fff',
		title: 'Ti.Animation Demo',
		fullscreen: true
	}),
	lbl = Ti.UI.createLabel({
		bottom: 50,
		color: "#000",
		textAlign: Ti.UI.TEXT_ALIGNMENT_CENTER,
		font: {
			fontSize: 12
		}
	}),
	view = TiAnimation.createLottieView({
		file: 'sample_lottie.json',
		loop: false,
		bottom: 300,
		height: 120,
		width: 120,
		borderRadius: 60,
		autoStart: false
	}),
	view2 = TiAnimation.createLottieView({
		file: 'sample_lottie.json',
		loop: false,
		bottom: 200,
		height: 120,
		width: 120,
		borderRadius: 60,
		autoStart: true,
		speed: 2,
		loop: true
	}),
	slider = Ti.UI.createSlider({
		value: 0,
		min: 0,
		max: 1,
		bottom: 10,
		width: 300
	});

if (isAndroid) {
	view.addEventListener("update", function(e) {
		console.log("current frame: " + e.frame)
	});
}
view.addEventListener("complete", function() {
	console.log("view: complete");
});
view2.addEventListener("complete", function() {
	console.log("view2: complete");
});

slider.addEventListener('change', seekToProgress);

win.add([
	view, view2, lbl, createButtonWithAction('Start animation', startAnimation), createButtonWithAction('Pause animation', pauseAnimation),
	createButtonWithAction('Resume animation', resumeAnimation), createButtonWithAction('Double speed', doubleSpeed), createButtonWithAction('Get frame', getFrame), slider
]);

function onOpen(e) {
	var dur = (isAndroid) ? view.getDuration() : (Math.floor(view.getDuration() * 1000));
	lbl.text = "Lottie: Duration: " + dur + "ms\n";
}
win.addEventListener("open", onOpen);

if (isAndroid) {
	win.open();
} else {
	var nav = Ti.UI.iOS.createNavigationWindow({
		window: win
	});
	nav.open();
}


function doubleSpeed(e) {
	if (isDouble) {
		e.source.title = "Double speed";
		view.setSpeed(1);
	} else {
		e.source.title = "Normal speed";
		view.setSpeed(2);
	}
	isDouble = !isDouble;
}

function seekToProgress(e) {
	view.setProgress(e.value);
}

function getFrame() {
	console.log("Current frame view-animation: " + view.getFrame());
}

function createButtonWithAction(title, action) {
	var btn = Ti.UI.createButton({
		title: title,
		top: offset,
		height: 28,
		width: 200,
		borderRadius: 4,
		borderWidth: 1,
		borderColor: "#000",
		color: "#000",
		backgroundColor: "#fff"
	});

	btn.addEventListener('click', action);

	offset += 30;
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
