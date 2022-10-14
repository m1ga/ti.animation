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
	view = TiAnimation.createAnimationView({
		file: '/sample_lottie.json',
		loop: false,
		bottom: 200,
		left: 30,
		height: 120,
		width: 120,
		borderRadius: 60,
		autoStart: false
	}),
	view2 = TiAnimation.createAnimationView({
		file: '/sample_lottie.json',
		loop: false,
		bottom: 200,
		right: 30,
		height: 120,
		width: 120,
		borderRadius: 60,
		autoStart: true,
		speed: 2,
		loop: true
	}),
	view3 = TiAnimation.createAnimationView({
		file: '/rocket.riv',
		//loop: true,
		bottom: 200,
		height: 120,
		width: 120,
		animationType: TiAnimation.ANIMATION_RIVE,
		//artboardName: "Main",
		//animationName: "Timeline 1",
		//stateName: "idle"
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
view.addEventListener("ready", function() {
	var dur = (isAndroid) ? view.duration : (Math.floor(view.duration * 1000));
	lbl.text = "Lottie: Duration: " + dur + "ms\n";
});
view.addEventListener("complete", function() {
	console.log("view: complete");
});
view2.addEventListener("complete", function() {
	console.log("view2: complete");
});

slider.addEventListener('change', seekToProgress);

win.add([
	view, view2, view3, lbl, createButtonWithAction('Start animation', startAnimation), createButtonWithAction('Pause animation', pauseAnimation),
	createButtonWithAction('Resume animation', resumeAnimation), createButtonWithAction('Double speed', doubleSpeed), createButtonWithAction('Get frame', getFrame), slider
]);

if (isAndroid) {
	win.open();
} else {
	var nav = Ti.UI.iOS.createNavigationWindow({
		window: win
	});
	nav.open();
}

view3.addEventListener("click", function() {
	view3.animationName = ["idle", "curves"];
})

function doubleSpeed(e) {
	if (isDouble) {
		e.source.title = "Double speed";
		view.speed = 1;
	} else {
		e.source.title = "Normal speed";
		view.speed = 2;
	}
	isDouble = !isDouble;
}

function seekToProgress(e) {
	view.progress = e.value;
}

function getFrame() {
	console.log("Current frame view-animation: " + view.frame);
}

function createButtonWithAction(title, action) {
	var btn = Ti.UI.createButton({
		title: title,
		top: offset,
		height: 30,
		width: 200,
		borderRadius: 4,
		borderWidth: 1,
		borderColor: "#000",
		color: "#000",
		backgroundColor: "#fff"
	});

	btn.addEventListener('click', action);

	offset += 32;
	return btn;
}

function startAnimation() {
	view.start();
    view3.start({
        animationName: "Timeline 1",
        loop: true
    });
}

function pauseAnimation() {
	view.pause();
	view3.pause();
}

function resumeAnimation() {
	view.resume();
	view3.resume();
}
