## Changes

### Summary
- Reformatted whitespace
- Converted manual JSON building to utilize ruby's JSON library via hashes
- Fixed DRY violation in `Waypoint` class by utilizing a `Point`
- Created `Geometry` and `Properties` classes to wrap creation of these JSON fields
- Improved variable names in `World` class (Now called `FeatureCollection`)
- Moved classes to files based on class-goals to increase readability
- Implemented a consistent interface for similar functions across classes; abstracted where possible
- Utilized object dependency injection to avoid unneccessary dependencies, wherever possible
- Utilized keyword arguments to reduce risk of change for some classes
- Renamed classes to clarify purpose

### All Changes
- Fixed initial whitespace
- Removed `TrackSegment` Class
- Converted `Tracker` `get_track_json()` function to use `JSON.generate` and a hash.
- `Waypoint` use `Point` class for `lat`, `lon`, `ele`
- Created GisJson class to abstract creation of commonly-used hashes for Json creation
- Abstracted creation of Coordinates array into `to_arr()` function in `Point` class
- Cleaned up `get_waypoint_json()` function in `Waypoint` class
- Created `geometry()` function in `GisJson` to abstract creation of geometry hash pre-json
- Created `gen()` function in `GisJson` to wrap call to `JSON.generate()`
- Renamed `things` property in `World` initializer to `features`
- Renamed `f` property in `World`'s `add_feature()` to `new_feature`
- All Json getters now use the same interface (function name `get_json()`)
- Abstracted all `get_json` functionality to `get_hash()`
- Cleaned up `World`'s `get_json()`
- Created `GisJsonObj` class to abstract creation of json hashes
- Moved `Point` and `Waypoint` classes to `locations.rb` to improve readability
- Moved `GisJsonObj` class to `dataObjects.rb` to improve readability
- Created abstract data class `ChildData`
- Created data classes `Properties` and `Geometry`
- Removed `GisJson` class
- Created `create_json_obj()` functions to package `Track` and `World` class data into a `GisJsonObj`
- Use `create_json_obj()` for `get_hash()` and `to_json()` functions in `Track` and `World` classes
- Created abstracted `Feature` class in `feature.rb` to reduce redundancy creating Features
- Moved `Track` class into `feature.rb`; made a subclass of `Feature`
- Moved `Waypoint` class into `feature.rb`; made a subclass of `Feature`
- Created `PointSegment` class; named `PointSegment` instead of `TrackSegment` for potential future extensibility
- Changed `Waypoint` class to take a `Point` object as an argument instead of `lon`, `lat`, and `ele` arguments
- Changed `Waypoint` initializer to utilize keyword parameters
- Renamed `World` class to `FeatureCollection`
- Ensured all `hash` and `json` methods use the same interface

## GIS Tool

Geographic Information Systems program.

This is a tool to work with geographic data. It takes a number of
geographic entities (Waypoints, Tracks) as input, and outputs them in a
standard format called GeoJSON.

Unfortunately, the tool (even though it works) suffers from bad
engineering. You should fix it up and eliminate that technical debt.

### Things to Watch For!

* Don't Repeat Yourself (DRY) violations--common code, potential
  subclassing.

* Single Responsibility Principle (SRP) violations

* Law of Demeter (LOD) violations.

* Places where Dependency Injection (DI) can reduce coupling.

* Bad variable names.

* Senseless comments.

* Places common interfaces can help.

Also:

* Make the code look good! Does it read easily?

## Running

You should be able to run it already:

```
ruby gis.rb
```

This will give GeoJSON output for some features that have been added in
the code:

```
{"type":"FeatureCollection","features":[{"type": "Feature","properties":
{"title": "home","icon": "flag"},"geometry":{"type":"Point","coordinates
":[-121.5,45.5,30]}},{"type": "Feature","properties": {"title": "store",
"icon": "dot"},"geometry":{"type":"Point","coordinates":[-121.5,45.6]}},
{"type": "Feature","properties": {"title": "track 1"},"geometry": {"type
": "MultiLineString","coordinates": [[[45,-122],[46,-122],[46,-121]],[[4
5,-121],[46,-121]]]}},{"type": "Feature","properties": {"title": "track 
2"},"geometry": {"type": "MultiLineString","coordinates": [[[45.5,-121],
[45.5,-122]]]}}]}
```

If you pipe it into the program `json_print.rb`, it should pretty
it up for you:

```
ruby gis.rb | ruby json_print.rb
```

**If the above command fails with an error in `parse`, it means the JSON
is malformed and needs to be fixed.**

(See the example at the bottom for sample output from this command.)

## Testing

You can run some unit tests with:

```
ruby tc_gis.rb
```

These tests depend on the method names, so if you change those, be sure
to change them in the tests, too.

The tests convert the JSON strings to Ruby hashes for the comparison so
it should work even if the order of elements in the JSON is changed.

## What to Do

1. Fork this repo. Clone your fork to your computer.

2. Refactor the code so that it follows the principles introduced this
   quarter. Anything in the code can be changed, but the output should
   remain the same.

   ALSO: Maintain a summary list of the changes that you made at the top
   of this README!

3. Commit and push your fork.

4. Submit a link to your fork.

## Hints

* **UNDERSTAND THE CODE AND THE PROBLEM BEFORE YOU START!**

* Make small changes.

* **Test the code at every change.** See the note about running unit
  tests, above.

* If the change works, commit it.

* If the change doesn't work, figure out what's amiss or roll back the
  previous commit.

* You can get a diff from the previous commit with:
  ```
  git diff
  ```

* You can revert uncommitted changes to the previous commit.
  **WARNING: this unceremoniously destroys any changes to the file
  you've made since the last commit!**

  ```
  git checkout gis.rb
  ```

* Though not required, the `json` module might be useful.

* The JSON must be valid. It can have extraneous whitespace or different
  formatting, but it must parse.

## About GeoJson

### Data Representation

* Latitude, longitude: these are decimal degrees (no minutes or
  seconds). West is negative latitude. South is negative longitude.

  Example: Bend, Oregon is at longitude -121.3, latitude 44.05

* Elevation: given in meters above sea level.

### Data Types

There are three types of data you can represent:

* **Waypoint**: This is a point represented by a latitude, longitude,
  and optional elevation. A waypoint also has an optional _name_ and
  _icon_. (e.g. a name might be "ACME Dining" and the icon might be
  "restaurant".)

* **Track Segment**: This is a list of latitude/longitude pairs (with
  optional elevation). The points of a Track Segment do not have names
  or icons. The Track Segment represents a section of a Track.

* **Track**: This is a list of Track Segments. It has an optional
  _name_.

### GeoJSON Format

Look at the example in the next section for context. Make sure you can
match up the following with that example before proceeding.

The GeoJSON file is an object with two fields:

* `"type"` is `"FeatureCollection"`
* `"features"` is an array of features

The features are objects with three fields:

* `"type"` is `"Feature"`
* `"properties"` is an object that contains additional properties
* `"geometry"` is an object that defines the shape of the feature

The geometry objects contain two fields:

* `"type"` is either `"Point"` for a single point, or
  `"MultiLineString"` for tracks
* `"coordinates"` are the coordinates that define the object. This is a
  single longitude/latitude/elevation for Points. It is an array of
  arrays of points for MultiLineStrings.

### Example GeoJSON File

```json
{
    "type":"FeatureCollection",
    "features":[
        {
            "type":"Feature",
            "properties":{
                "title":"home",
                "icon":"flag"
            },
            "geometry":{
                "type":"Point",
                "coordinates":[ -121.5, 45.5, 30 ]
            }
        },
        {
            "type":"Feature",
            "properties":{
                "title":"store",
                "icon":"dot"
            },
            "geometry":{
                "type":"Point",
                "coordinates":[ -121.5, 45.6 ]
            }
        },
        {
            "type":"Feature",
            "properties":{
                "title":"track 1"
            },
            "geometry":{
                "type":"MultiLineString",
                "coordinates":[
                    [
                        [ -122, 45 ], [ -122, 46 ], [ -121, 46 ]
                    ],
                    [
                        [ -121, 45 ], [ -121, 46 ]
                    ]
                ]
            }
        },
        {
            "type":"Feature",
            "properties":{
                "title":"track 2"
            },
            "geometry":{
                "type":"MultiLineString",
                "coordinates":[
                    [
                        [ -121, 45.5 ], [ -122, 45.5 ]
                    ]
                ]
            }
        }
    ]
}
```
