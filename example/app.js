var TiAnimation = require('ti.animation');
var isAndroid = (Ti.Platform.osname == 'android');

var win = Ti.UI.createWindow({
    backgroundColor: '#fff',
    title: 'Ti.Animation Demo',
    fullscreen: true
});

var lbl = Ti.UI.createLabel({
    bottom: 50,
    color: "#000",
    textAlign: Ti.UI.TEXT_ALIGNMENT_CENTER,
    font: {
        fontSize: 12
    }
});

var offset = 0;

var lottieView = TiAnimation.createLottieView({
    file: 'sample_lottie.json',
    loop: false,
    bottom: 300,
    height: 120,
    width: 120,
    borderRadius: 60,
    update: onUpdate,   // android
    autoStart: false
});

var keyframeView = TiAnimation.createKeyframeView({
    file: 'sample_keyframes.json',
    bottom: 100,
    width: 150,
    height: 150,
    loop: false,
    autoStart: false
});

var slider = Ti.UI.createSlider({
    value: 0,
    min: 0,
    max: 1,
    bottom: 10,
    width: 300
});

function onUpdate(e){
    console.log("Percentage: " + e.percentage);
}

slider.addEventListener('change', seekToProgress);

win.add(lottieView);
win.add(keyframeView);
win.add(lbl);

win.add(createButtonWithAction('Start animation', startAnimation));
win.add(createButtonWithAction('Pause animation', pauseAnimation));
win.add(createButtonWithAction('Resume animation', resumeAnimation));
win.add(createButtonWithAction('Double speed', doubleSpeed));

function onOpen(e) {
    var dur = (isAndroid) ? lottieView.getDuration() : (Math.floor(lottieView.getDuration() * 1000));
    lbl.text = "Lottie: Duration: " + dur + "ms\n";

    if (isAndroid) {
        lbl.text += "Keyframe: Frame count: " + keyframeView.getFrameCount() + " - Frame rate: " + keyframeView.getFrameRate();
    }
}

win.addEventListener("open", onOpen);
win.add(slider);

if (isAndroid) {
    win.open();
} else {
    var nav = Ti.UI.iOS.createNavigationWindow({
        window: win
    });
    nav.open();
}

function doubleSpeed(e) {
    lottieView.setSpeed(2);
}

function seekToProgress(e) {
    lottieView.setProgress(e.value);
    keyframeView.seekToProgress(e.value);
}

function createButtonWithAction(title, action) {
    var btn = Ti.UI.createButton({
        title: title,
        top: offset,
        height: 35,
        width: 200,
        borderRadius: 4,
        borderWidth: 1,
        borderColor: "#000",
        color: "#000",
        backgroundColor: "#fff"
    });

    btn.addEventListener('click', action);

    offset += 38;
    return btn;
}

function startAnimation() {
    lottieView.start();
    keyframeView.start();
}

function pauseAnimation() {
    lottieView.pause();
    keyframeView.pause();
}

function resumeAnimation() {
    // lottieView.resume();
    keyframeView.resume();
}
