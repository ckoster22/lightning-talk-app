require('../favicon.ico');
require('basscss/css/basscss.css');
require('./Presentation/index.scss');
require('./loadIcons.js');

const Elm = require('./Main.elm');
Elm.Main.fullscreen({
    initialTime: (new Date()).getTime()
});
