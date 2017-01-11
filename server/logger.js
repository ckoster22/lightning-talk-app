const winston = require('winston');
const expressWinston = require('express-winston');

module.exports = expressWinston.logger({
    transports: [
        new winston.transports.Console({
            json: true,
            colorized: true
        })
    ],
    colorize: true
});
