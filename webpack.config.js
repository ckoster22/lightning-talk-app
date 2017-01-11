var webpack = require('webpack');
var HtmlWebpackPlugin = require('html-webpack-plugin');
var path = require('path');

var elmLoader = process.env.ENV === 'production' ? 'elm-webpack' : 'elm-webpack?debug=true';

var config = {
    entry: {
        app: ['./src/main.js']
    },
    module: {
        loaders: [
            {
                test: /\.elm$/,
                loader: elmLoader,
                exclude: [/elm_stuff/, /node_modules/]
            },
            {
                test: /\.css$/,
                loader: 'style!css!postcss'
            },
            {
                test: /\.scss$/,
                loader: 'style!css!postcss!sass'
            },
            {
                test: /vendor[\/\\]icons[\/\\][-_\w]*[\/\\][-_\w]*.svg$/i,
                loader: 'svg-sprite-loader'
            },
            {
                test: /\.(ico|woff)$/,
                loader: 'file-loader?name=[path][name].[ext]',
                exclude: [/elm_stuff/, /node_modules/]
            },
            {
                test: /\.jpg$/,
                loader: 'file-loader',
                exclude: [/elm_stuff/, /node_modules/]
            }
        ]
    },
    output: {
        filename: 'bundle.js',
        path: path.resolve(__dirname, 'build'),
        publicPath: 'http://localhost:8080/'
    },
    resolve: {
        extensions: ['', '.js', '.elm'],
    },
    plugins: [
        new HtmlWebpackPlugin({
            title: 'Aviture Lightning Talks',
            template: 'index.html',
            hash: true
        })
    ],
    devServer: {
        historyApiFallback: true,
        hot: true,
        inline: true,
        proxy: {
            '/api': {
                target: 'http://localhost:3000'
            }
        },
        stats: {
            colors: true
        },
        watchOptions: {
            aggregateTimeout: 300,
            poll: 1000
        }
    }
};

if (process.env.ENV !== 'production') {
    config.plugins.unshift(new webpack.HotModuleReplacementPlugin());
}


module.exports = config;
