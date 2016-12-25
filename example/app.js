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

var view = TiKeyframes.createKeyframes({
    file: '/sample_logo.json',
    width: 200,
    height: 200
});

win.add(view);

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
    view.seekToProgress(e.value);
});

win.addEventListener('open', function() {
    view.initialize();
})

function onOpen(e) {
    lbl.text = "Framecount: " + view.getFrameCount() + "\nFrameRate: " + view.getFrameRate();
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
}

function pauseAnimation() {
    view.pauseAnimation();
}

function resumeAnimation() {
    view.resumeAnimation();
}

function playEndAnimation() {
    view.startAnimation();
    setTimeout(function() {
        view.stopAnimationAtLoopEnd();
    }, 100);
}
