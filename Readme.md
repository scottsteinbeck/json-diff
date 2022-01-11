# JSON Diff
An ColdFusion utility for checking if 2 JSON objects have differences


## Installation
```javascript
property name="JSONDiff" inject="JSONDiff"; //wirebox

JSONDiff = new path.to.the.cfc.JSONDiff(); //Instantiate Object

```
## Usage
### Diff
Call `JSONDiff.diff` to get a detailed list of changes made between the JSON objects.

```javascript
    JSONDiff.diff(
        { test: ["test", { test: true }] },
        { test: ["test", { test: false }] }
    ))

    //Result
    [
        {
            "type": "CHANGE",
            "path": ["test", 2, "test"],
            "old": true,
            "new": false,
        },
    ]
```
### Diff with ignored keys
If you provide an array of ignored keys, the diff function will skip comparison on those keys

```javascript
    // JSONDiff.diff(origData, newData [, ignored array of keys])
    JSONDiff.diff(
        { test: ["test", { test: true }] },
        { test: ["test", { test: false }], dirty:true }
        ['dirty']
    ))

    //Result
    [
        {
            "type": "CHANGE",
            "path": ["test", 2, "test"],
            "old": true,
            "new": false,
        },
    ]
```

### isSame
Call `JSONDiff.isSame` to get a simple boolean `true` or `false`.

```javascript
    JSONDiff.isSame(
        { test: ["test", { test: true }] },
        { test: ["test", { test: false }] }
    ))

    //Result
    false
```

## License

This library is distributed under the apache license, version 2.0

> Copyright 2021 Scott Steinbeck; All rights reserved.
>
> Licensed under the apache license, version 2.0 (the "license");
> You may not use this library except in compliance with the license.
> You may obtain a copy of the license at:
>
> http://www.apache.org/licenses/license-2.0
>
> Unless required by applicable law or agreed to in writing, software
> distributed under the license is distributed on an "as is" basis,
> without warranties or conditions of any kind, either express or
> implied.
>
> See the license for the specific language governing permissions and
> limitations under the license.
