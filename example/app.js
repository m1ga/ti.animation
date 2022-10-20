const TiAnimation = require('ti.animation');
const isAndroid = (Ti.Platform.osname == 'android');
var offset = 0;
var isDouble = false;
var isLoop = false;
var isDay = true;

const win = Ti.UI.createWindow({
	backgroundColor: '#fff',
	title: 'Titanium demo',
	fullscreen: true
});

var buttonRow = Ti.UI.createView({
	height: Ti.UI.SIZE,
	width: Ti.UI.SIZE,
	layout: "horizontal",
	top: 10
});
var buttonRow2 = Ti.UI.createView({
	height: Ti.UI.SIZE,
	width: Ti.UI.SIZE,
	layout: "horizontal",
	top: 65
});
var buttonRow3 = Ti.UI.createView({
	height: Ti.UI.SIZE,
	width: Ti.UI.SIZE,
	layout: "horizontal",
	bottom: 100
});


function onClickLoop(e) {
	isLoop = !isLoop;
	if (isLoop) {
		e.source.backgroundColor = "#afa";
	} else {
		e.source.backgroundColor = "#fff";
	}
}


buttonRow.add([
	createButtonWithAction('Start', startAnimation),
	createButtonWithAction('Pause', pauseAnimation),
	createButtonWithAction('Resume', resumeAnimation),
	createButtonWithAction('Stop/Reset', resetAnimation),
]);
buttonRow2.add([
	createButtonWithAction('Loop', onClickLoop),
]);
buttonRow3.add([
	createButtonWithAction('Double speed', doubleSpeed),
	createButtonWithAction('Get frame', getFrame),
]);

const lbl_title = Ti.UI.createLabel({
	bottom: 300,
	color: "#000",
	text: "Lottie:"
});
const lbl = Ti.UI.createLabel({
	bottom: 40,
	color: "#000",
	textAlign: Ti.UI.TEXT_ALIGNMENT_CENTER,
	font: {
		fontSize: 12
	}
});
const view = TiAnimation.createAnimationView({
	file: '/sample_lottie.json',
	loop: false,
	bottom: 200,
	left: 30,
	height: 120,
	width: 120,
	borderRadius: 60,
	autoStart: false
});
const view2 = TiAnimation.createAnimationView({
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
});
const riveView = TiAnimation.createAnimationView({
	file: '/knight.riv',
	top: 140,
	height: 200,
	width: 200,
	animationType: TiAnimation.ANIMATION_RIVE,
	//artboardName: "Main",
	animationName: "idle",
	//stateName: "idle"
});
const slider = Ti.UI.createSlider({
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
	view, view2, riveView, lbl_title, lbl, buttonRow, slider, buttonRow2, buttonRow3
]);

win.open();

riveView.addEventListener("click", function() {
	if (isDay) {
		riveView.animationName = "day_night";
	} else {
		riveView.animationName = "night_day";
	}
	isDay = !isDay;
})

function doubleSpeed(e) {
	if (isDouble) {
		e.source.title = " Double speed ";
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
		height: 50,
		borderRadius: 4,
		borderWidth: 1,
		right: 2,
		borderColor: "#000",
		color: "#000",
		backgroundColor: "#eee",
		touchFeedback: true,
		touchFeedbackColor: "#aaa"
	});

	btn.addEventListener('click', action);

	return btn;
}

function startAnimation() {
	view.loop = isLoop;
	view.start();
	riveView.start({
		animationName: "idle",
		loop: isLoop
	});
}

function resetAnimation() {
	riveView.reset();
}

function pauseAnimation() {
	view.pause();
	riveView.pause();
}

function resumeAnimation() {
	view.resume();
	riveView.resume();
}
