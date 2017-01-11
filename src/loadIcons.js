var files = require.context('../vendor/icons', true, /^\.\/.*\.svg$/);
files.keys().forEach(files);
