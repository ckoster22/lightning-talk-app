# Overview

This application is a trimmed down version of the application that we are currently using at work. `json-server` is currently configured to use an in-memory database so if you plan on changing data you only have to `npm start` again to get the original data back.

I hope you find this repository useful!

- Charlie and the Aviture team

# Setup

1. Install Elm 0.18 from http://elm-lang.org/install
2. Run `elm-package install -y`
3. Run `npm install`
4. Run `npm start` to run the app and go to http://localhost:8080
5. We're using [Basscss](http://www.basscss.com/) for CSS utility classes
6. We are using [CSS Comb](https://github.com/csscomb/csscomb.js) with the default 'CSS comb' config for CSS formatting in our IDEs.

# What you need to know

## Model Design

The most critical concept to understand is that the application `Model` is a *Union Type*, not a Record. Take a look at its definition.

```
type Model
    = NoData Date
    | Loading Page Data
    | Show Page Data Modifier
```

The application can be in one of three general states. Either we don't have and haven't asked for any data (but we have a date), or we are actively performing the initial query for data, or we have the data and we are showing a specific page.

**Page** itself is a *Union Type* that indicates which page we're looking at.

**Data** is a *Type Alias* the holds both today's date and all of the data to be displayed.

**Modifier** is a *Union Type* that describes more specific details about the page. Are we looking at an empty form or a form with errors? That sort of thing.

This reads somewhat naturally in the update files:

```
case msg of
    SomeMsg ->
        Show UpcomingTalks data WithNoSelection ! [ Cmd.none ]

    ...
```

*Note:* This Model is the latest in a series of attempts to further simplify what was becoming a monolothic Record. The Model will likely change as new capabilities are added, but future modifications will likely involve heavy usage of Union Types as well.

## Themes

The theme colors for the entire application is driven by three colors. These colors can be found under `src/Presentation/Theme/_themes.scss` and it's as simple as commenting out the current theme and uncommenting a different theme.

## All Hands Page

The [all hands](http://localhost:8080/#allhands) page is a one-off page that I use as a poor man's solution to generating a slide for an All Hands presentation. I navigate to that page directly, grab a screenshot, and paste it into the presentation.
