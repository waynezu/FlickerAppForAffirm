# FlickerAppForAffirm

It took 3 hours to do this.
What is left:
A lot methods not implemented yet, and most important part, dynamiclly update the table view.
The fetchImageData will get 100 urls at most at one time. Do this again to get another 100 at fetchMore().
The basic idea is to fetch certain number of image data at a time, download the rest in backend, and then fetch more if user scroll down.
