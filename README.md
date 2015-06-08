# coral.blob.js
Blob.js provides the functionality to generate procedural blob-geometries in three.js. 

![example image](http://matthiasdv.org/cdn/img/example_blob.png "An exemplary image")

# How To Install

You can install blob.js using the classic script tag:
```
<script src='coral.blob.min.js'></script>
```
You may also install blob.js using bower:
```
**$** bower install coral.blob.js
```

# Usage
Generating a random blob can be done using:
```
**var** blobGeometry = Coral.Blob( { options } );
```

# Options
the *{options}* object is optional, and may contain:
* **smoothing** *(float)* The amount of smoothing applied to the blob geometry
* **detail** *(integer)* The level of detail applied to the geometry. Higher detail equals more vertices.
* **radius** *(float)* The radius of the blob geometry
* **noiseOptions** *(object)* The options-object passed to the noise generator. Details can be found [here](https://github.com/joshforisha/fast-simplex-noise-js)
    
Credit goes to [joshforisha](https://github.com/joshforisha/fast-simplex-noise-js) for his JavaScript implementation of [Simplex noise](http://webstaff.itn.liu.se/~stegu/simplexnoise/simplexnoise.pdf). 

