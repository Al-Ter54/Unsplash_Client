# unsplash_client

Application receives data from [Unsplash API](https://unsplash.com/) and displays it to the user.

User can get image feed or search for specific image

Data screen has four states:
- empty state (no data to display)
- data state (displaying received data)
- loading state (displaying loader while data is loading)
- error state (when any error happened)


To test states, buttons are added under the search bar at the top of the screen

Image feed and search results support paging on scroll to bottom of current list

When the results run out, the user gets a message at the bottom of the screen

If no data able to display by search query, user see empty state

On tap every image displays on detail screen

Detail screen use hero animation, zoom in/out and can be closed by pull up/down

Queries for receiving data have 2 seconds duration to display loaders

## Getting Started

On application started user can:
- load image feed by pressing button "Load"
- imitate error by pressing button "Get error"
- search specific images by TextField (min 2 characters)
- clear all results by pressing button "Clear"

On images loaded user can go to detail page 

On detail page user can:
- zoom image
- pull up/down to close detail page
