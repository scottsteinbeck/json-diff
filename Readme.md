# JSON Diff
An ColdFusion utility for checking if 2 JSON objects have differences

*Important:* JSON Objects NOT Serialized JSON Strings (Please de-serialize them first)

## License

Apache License, Version 2.0.

## System Requirements

- Lucee 5+
- Adobe ColdFusion 2016 (Deprecated)
- Adobe ColdFusion 2018+

## Installation

Use CommandBox CLI to install:

```bash
box install jsondiff
```

## Installation
```javascript
property name="JSONDiff" inject="JSONDiff"; //wirebox
/* or (dot) folder path to the cfc */
JSONDiff = new path.to.the.cfc.JSONDiff(); //Instantiate Object
```
## Methods
```javascript
JSONDiff.diff(origData, newData [, ignored array of keys])
JSONDiff.diffByKey(origData, newData, uniqueKey [, ignored array of keys])
JSONDiff.isSame(origData, newData [, ignored array of keys])
JSONDiff.summary(diffs)
JSONDiff.visualizeDiff(origData, newData [, ignored array of keys])
```

## Usage
---
### Diff (origData, newData [, ignored array of keys])
#### Call `JSONDiff.diff` to get a detailed list of changes made between the JSON objects.

```javascript
    // JSONDiff.diff(origData, newData [, ignored array of keys])
    JSONDiff.diff(
        { test: ["test", { test: true }] },
        { test: ["test", { test: false }] }
    ));

    //Result
    [
        {
            "type": "CHANGE",
            "path": ["test", 2, "test"],
            "old": true,
            "new": false,
        },
    ]

    /*
        Diff with ignored keys
        If you provide an array of ignored keys, the diff function will 
        skip comparison on those keys
    */

    JSONDiff.diff(
        { test: ["test", { test: true }] },
        { test: ["test", { test: false }], dirty:true }
        ['dirty'] //Ignored Keys
    ));

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

### DiffByKey (origData, newData, uniqueKey [, ignored array of keys])
#### Call `JSONDiff.diffByKey` to get a detailed list of changes based on a unique key
Great for comparing 2 arrays of structs

```javascript
    // JSONDiff.diffByKey(origData, newData, uniqueKey [, ignored array of keys])

    JSONDiff.diffByKey(
        [
            {'id':26,'x':480,'y':0},
            {'id':28,'x':482,'y':10},
            {'id':32,'x':480,'y':12}
        ],
        [
            {'id':25,'x':10,'y':0},
            {'id':65,'x':298,'y':0},
            {'id':32,'x':415,'y':2}
        ],
        'id'
    );

    //Result
    {
        "REMOVE": [{
            "data": {"y": 0,"x": 298,"id": 65 },
            "key": 65
        }, {
            "data": { "y": 0, "x": 10, "id": 25 },
            "key": 25
        }],
        "UPDATE": [{
            "changes": [
                { "path": ["y"], "key": "y", "old": 2, "new": 12 }, 
                { "path": ["x"], "key": "x", "old": 415, "new": 480 }
            ],
            "key": "32",
            "oldData": { "y": 2, "x": 415, "id": 32 },
            "newData": { "y": 12, "x": 480, "id": 32  }
        }],
        "ADD": [{
            "data": { "y": 10, "x": 482, "id": 28 },
            "key": 28
        }, {
            "data": { "y": 0, "x": 480, "id": 26 },
            "key": 26
        }]
    }
```

### isSame (origData, newData [, ignored array of keys])
#### Call `JSONDiff.isSame` to get a simple boolean `true` or `false`.

```javascript
    JSONDiff.isSame(
        { test: ["test", { test: true }] },
        { test: ["test", { test: false }] }
    ))

    //Result
    false
```

### summary (diffs)
#### Get a count of each diff type.

```javascript
    var diffs = JSONDiff.diff({a:1},{a:2,b:3});
    JSONDiff.summary(diffs);

    //Result
    {
        add: 1,
        remove: 0,
        change: 1,
        update: 0
    }
```

### visualizeDiff (origData, newData [, ignored array of keys])
#### Return a simple HTML diff between two objects.

```javascript
    JSONDiff.visualizeDiff({a:1},{a:2});

    //Result
    <ul><li><span style="font-weight:bold">a</span>: <span style="background: #ffbbbb;text-decoration: line-through;">1</span> <span style="background: #bbffbb;">2</span></li></ul>
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
