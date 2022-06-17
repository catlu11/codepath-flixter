# Project 1 - Flixter

**Flixter** is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **15** hours spent in total

## User Stories

The following **required** functionality is complete:

- [x] User sees an app icon on the home screen and a styled launch screen.
- [x] User can view a list of movies currently playing in theaters from The Movie Database.
- [x] Poster images are loaded using the UIImageView category in the AFNetworking library.
- [x] User sees a loading state while waiting for the movies API.
- [x] User can pull to refresh the movie list.
- [x] User sees an error message when there's a networking error.
- [x] User can tap a tab bar button to view a grid layout of Movie Posters using a CollectionView.

The following **optional** features are implemented:

- [x] User can tap a poster in the collection view to see a detail screen of that movie
- [x] User can search for a movie.
- [x] All images fade in as they are loading.
- [x] User can view the large movie poster by tapping on a cell.
- [x] For the large poster, load the low resolution image first and then switch to the high resolution image when complete.
- [x] Customize the selection effect of the cell.
- [x] Customize the navigation bar.
- [ ] Customize the UI.
- [ ] Run your app on a real device.

The following **additional** features are implemented:

- [x] Movie trailer can be viewed by tapping on movie poster on detail screen.

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. Autolayouts and ways to improve formatting across devices
2. Customization of movie trailer web view

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='flixter_demo.gif' title='Video Walkthrough' alt='Video Walkthrough' />

## Notes

Formatting and getting layouts to behave as expected was a challenge throughout the project – UI may only display as intended on iPhone 11.

## Credits
- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library
- [WebKit](https://webkit.org/) - web browser engine

## License

    Copyright 2022 Catherine Lu

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
