# Project 1 - Flicks

Flicks is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

## User Stories

The following **required** functionality is completed:

- [x] User can view a list of movies currently playing in theaters. Poster images load asynchronously.
- [x] User can view movie details by tapping on a cell.
- [x] User sees loading state while waiting for the API.
- [x] User sees an error message when there is a network error.
- [x] User can pull to refresh the movie list.

The following **optional** features are implemented:

- [x] Add a tab bar for **Now Playing** and **Top Rated** movies.
- [x] Implement bar button item to switch between list view and grid view.
- [x] Add a search bar.
- [x] All images fade in.
- [x] For the large poster, load the low-res image first, switch to high-res when complete.
- [x] Customize the highlight and selection effect of the cell.
- [x] Customize the navigation bar.

The following **additional** features are implemented:

- [x] Long movie titles wrap in the detail view.
- [x] Used NSDateFormatter to convert and format dates.
- [x] Created a custom view for the network error view.
- [x] Collection view cell size changes accoring to the device screen size to always have only two cells per row.
- [x] On the movie detail screen the movie detail view animates to inform the user that there is more content.

## Video Walk-through

Here's a walk-through of implemented user stories:

![Walk-through Video](flicks_walkthrough.gif)

Video showing the network error:

![Network Error Video](flicks_network_error.gif)

I made the video with the following settings:

- I set configuration.URLCache = nil to keep NSURLSession from caching the request. Otherwise it was difficult to show the network error message.
- I used the Network Link Conditioner to reduce the bandwidth (DSL profile) so you could see the images loading and to simulate 100% data loss.

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Getting the layout right once I had the ability to toggle between table and collection view was a bit of work. Once I added a UISearchController things got a bit more difficult. I got things working, but I was not happy with how it worked--it would hide the nav bar so the user could not toggle between the table and collection view while searching. And while the UITableView would slide up to meet the bottom of the UISearchController the UICollectionView would not. I tried several things to fix this, but eventually gave up. It did not look too bad, but it was not ideal. I was also initially adding two UISearchControllers in code (one for the table view and the other for the collection view). I decided to redo the whole search functionality and just use one shared UISearchBar. This gave me the functionality I wanted, and was easier to configure. It was difficult to correctly layout both the UITableView and the UICollectionView in one storyboard scene, so I just set the frame/origin/size in code. The other thing I did not expect was that the UITableView behaves differently from the UICollectionView when there is a translucent nav and tab bar. I assumed the table and collection view would both have the same dimensions, but I had to change things a bit to accommodate the UITableViews behavior when under a translucent tab and nav bar. In retrospect I think I would have just made the nav and tab bars opaque had I know in advance.

Figuring out what code I need to customize the highlighted state of the table cell was more difficult than I thought it should be. The code itself was trivial. I kept. however, reading that the highlighted and selected states were different, but I could not find out how to change the background color of the highlighted state. Turns out you have to set the selectedBackgroundView. I saw this multiple times in the CodePath guides, but kept ignoring it looking for something like highlightedBackgroundView.

## Icons

- The tickets icon on the tab bar was created by Arthur Lacôte of the Noun Project [thenounproject](http://thenounproject.com).
- Some of the icons came from [iconmonstr](http://iconmonstr.com)
- Some of the icons (including the app icon) were made by me, Marc Adam Anderson.

## License

    Copyright 2016 Marc Adam Anderson

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.