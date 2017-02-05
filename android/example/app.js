var TiKeyframes = require('ti.keyframes');

var win = Ti.UI.createWindow({
    backgroundColor: '#fff',
    title: 'Ti.Keyframes Demo'
});

var lbl = Ti.UI.createLabel({
    bottom: 50,
    color: "#000"
});

var offset = 0;

var view = TiKeyframes.createLottie({
    width: 200,
    height: 200,
    file: '/LightBulb.json',
    loop: true,
    autoStart: true
});

var view2 = TiKeyframes.createKeyframes({
    file: '/sample_logo.json',
    width: 200,
    height: 200
});

win.add(view);
win.add(view2);

win.add(createButtonWithAction('Start animation', startAnimation));
win.add(createButtonWithAction('Play till end', playEndAnimation));
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
    view2.seekToProgress(e.value);
});

win.addEventListener('open', function() {
    view2.initialize();
})

function onOpen(e) {
    lbl.text = "Framecount: " + view2.getFrameCount() + "\nFrameRate: " + view2.getFrameRate();
}

win.addEventListener("open", onOpen);
win.add(lbl);
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
    view.startAnimation();
    view2.startAnimation();
}

function pauseAnimation() {
    view2.pauseAnimation();
}

function resumeAnimation() {
    view2.resumeAnimation();
}

function playEndAnimation() {
    view2.startAnimation();
    setTimeout(function() {
        view2.stopAnimationAtLoopEnd();
    }, 100);
}
