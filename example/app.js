var TiAnimation = require('ti.animation');

var win = Ti.UI.createWindow({
    backgroundColor: '#fff',
    title: 'Ti.Keyframes Demo'
});

var lbl = Ti.UI.createLabel({
    bottom: 50,
    color: "#000"
});

var offset = 0;

var view = TiAnimation.createLottie({
    width: 200,
    height: 200,
    file: '/LightBulb.json',
    loop: false,
    autoStart: false
});

var view2 = TiAnimation.createKeyframes({
    file: '/s2.json',
    width: 148,
    height: 54,
    bottom: 70,
    loop: false,
    autoStart: false
});
win.add(view);
win.add(view2);
win.add(lbl);

win.add(createButtonWithAction('Start animation', startAnimation));
win.add(createButtonWithAction('Pause animation', pauseAnimation));
win.add(createButtonWithAction('Resume animation', resumeAnimation));

var slider = Ti.UI.createSlider({
    value: 0,
    min: 0,
    max: 1,
    bottom: 10,
    width: 300
});

slider.addEventListener('change', function(e) {
    view.seekToProgress(e.value);
    view2.seekToProgress(e.value);
});

function onOpen(e) {
    lbl.text = "Framecount: " + view2.getFrameCount() + " - FrameRate: " + view2.getFrameRate();
}

win.addEventListener("open", onOpen);
win.add(slider);
win.open();

function createButtonWithAction(title, action) {

    var btn = Ti.UI.createButton({
        title: title,
        top: offset
    });

    btn.addEventListener('click', action);

    offset += 40;
    return btn;
}

function startAnimation() {
    view.start();
    view2.start();
}

function pauseAnimation() {
    view.pause();
    view2.pause();
}

function resumeAnimation() {
    view.resume();
    view2.resume();
}
