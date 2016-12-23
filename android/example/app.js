var TiKeyframes = require('ti.keyframes');

var win = Ti.UI.createWindow({
    backgroundColor: '#fff',
    title: 'Ti.Keyframes Demo'
});

var offset = 0;

var view = TiKeyframes.createKeyframes({
	file: '/sample_logo.json'
});

win.add(view);

win.add(createButtonWithAction('Start animation', startAnimation));
win.add(createButtonWithAction('Pause animation', pauseAnimation));
win.add(createButtonWithAction('Resume animation', resumeAnimation));

var slider = Ti.UI.createSlider({
    value: 0,
    min: 0,
    max: 1,
    bottom: 50,
    width: 300
});

slider.addEventListener('change', function(e) {
    view.seekToProgress(e.value);
});

win.addEventListener('open', function() {
	view.initialize();
})

win.add(slider);
win.open();

function createButtonWithAction(title, action) {
    offset += 40;
    
    var btn = Ti.UI.createButton({
        title: title,
    	top: offset
    });

    btn.addEventListener('click', action);
    
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
