OSCeletonWrapper
================

OSCeleton Library for use in processing.

INSTALL
-------

Add this folder to the libraries folder inside you Processing Sketch directory

USAGE
-----

This is a processing library which listens to OSC messages sent from
[OSCeleton](https://github.com/Sensebloom/OSCeleton). You will need to
setup your kinect to send skeleton data. More info on how to do that here:
[http://skyra.github.io/blog/Kinect-Processing/](skyra.github.io/blog/Kinect-Processing/)

Once you have that set up, start osceleton on a port

    ./osceleton -p 12345
    
In your processing sketch create a new OSCeletonWrapper object

    OSCeletonWrapper osceleton = new OSCeletonWrapper(this, 12345);

Then you can query this wrapper for skeleton information

    osceleton.getSkeletons();

CONTRIBUTE
----------

If you would like to contribute code to OSCeletonWrapper you can do so through
GitHub by forking the repository and sending a pull request.

You may [file an issue](https://github.com/cketcham/OSCeletonWrapper/issues/new)
if you find bugs or would like to add a new feature.


DEVELOPED BY
------------

* Cameron Ketcham - [http://skyra.github.io](http://skyra.github.io)
