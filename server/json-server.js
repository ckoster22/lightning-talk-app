const jsonServer = require('json-server');
const routes = require('./routes.json');
const server = jsonServer.create();
const router = jsonServer.router(process.env.ENV === 'development' ? createFakeDb() : 'server/data/db.json');
const middlewares = jsonServer.defaults();
const logger = require('./logger');

server.use(jsonServer.rewriter(routes));
server.use(require('body-parser').json());
server.use(middlewares);
server.use(logger);
server.listen(3000, () => {
    console.log('JSON Server is running');
});
server.post('/rounds', (req, res, next) => {
    const {
        id,
        startDateTime,
        theme = ''
    } = req.body;
    if (id) {
        return next(); // In case somebody attempts to update via POST
    } else if (startDateTime === undefined) { // undefined as opposed to ! because 0 is considered valid
        res.status(400).send(`'startDateTime' property is required to create a round.`);
    } else {
        next();
    }
});

server.use(router); // Leave this down here, it affects how the application works if moved up

function createFakeDb() {
    const dayInMillis = 1000 * 60 * 60 * 24;
    const nowInMillis = (new Date()).getTime();

    return {
        rounds: [
            {
                id: 'cbf2b34e-f3e9-4bd8-b7fc-ae9cd6028ed7',
                startDateTime: nowInMillis - 13 * dayInMillis,
                theme: 'Talks rebooted',
                slot1: {
                    description: 'We have been doing ShipIt Days every other Wednesday for a year. We sat down to do some analysis and want to share the outcomes.',
                    speakers: 'Kathy What-Does-The-I-Stand-For Andersen',
                    topic: 'One Year of Ship-It Days Examined'
                },
                slot2: {
                    description: 'Fuzz testing (also known as Property Based Testing) is a technique that allows you to generate hundreds of unit tests with only a few lines of code. In five minutes I\'ll demonstrate how to write fuzz tests and show how it can help you find bugs that are otherwise hard to discover.',
                    speakers: 'Charlie Koster',
                    topic: 'Fuzz Testing: How to write 500 tests in 5 minutes'
                },
                slot3: null,
                slot4: {
                    description: 'A high level overview on how Pug can make your life better by allowing you to write HTML as CSS selectors & providing additional features.',
                    speakers: 'Evan Williams',
                    topic: 'Pug (formerly Jade)'
                }
            },
            {
                id: 'acb413f3-7f21-4e85-bbf8-8e93267e21a4',
                startDateTime: nowInMillis + dayInMillis,
                theme: 'What\'s on your 2017 Radar?',
                slot1: {
                    description: 'A discussion of the current state of application containers, its pros and cons and what advances to expect in the future.',
                    speakers: 'Mike Kaylan',
                    topic: 'The Future of Containerization'
                },
                slot2: {
                    description: 'A preview on the latest progress with augmented reality (AR) and virtual reality (VR) and what we can expect in 2017.',
                    speakers: 'John Doe',
                    topic: 'Alternate Realities with AR & VR'
                },
                slot3: null,
                slot4: null
            },
            {
                id: 'b146082c-4f37-4808-949a-d143fe136dac',
                startDateTime: nowInMillis + 15 * dayInMillis,
                theme: '',
                slot1: {
                    description: 'Pitfalls of NPM has been a hot topic lately. There is an alternative built on the same repository and works very similarly, but with much better performance and built in safety nets like "shrinkwrapping."',
                    speakers: 'Evan Williams',
                    topic: 'Yarn'
                },
                slot2: null,
                slot3: {
                    description: 'What separates people who succeed from people who just talk about it? It\'s not intelligence, and it\'s not skill - it\'s about overcoming obstacles and continuing your work over a long period of time. In other words, it\'s about GRIT. That\'s "grit" with an "R" - no  version control here. Just good old-fashioned meme-filled lightning talk goodness.',
                    speakers: 'Art "Texas Ranger" Doler',
                    topic: 'Grit - Good for Gizzards, but Perfect for Perseverance'
                },
                slot4: null
            },
            {
                id: '29ca6381-bf91-4a9b-80e5-8e30ef8ca7e5',
                startDateTime: nowInMillis + 29 * dayInMillis,
                theme: 'UX Lessons Learned',
                slot1: null,
                slot2: null,
                slot3: null,
                slot4: null
            }
        ]
    };
}
