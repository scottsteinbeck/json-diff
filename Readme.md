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

## Setup
```javascript
property name="JSONDiff" inject="JSONDiff"; //wirebox
/* or (dot) folder path to the cfc */
JSONDiff = new path.to.the.cfc.JSONDiff(); //Instantiate Object
```

## Methods
| Method | Purpose |
|---|---|
| `diff(first, second [, ignoreKeys, caseSensitive])` | List every change between two values |
| `diffByKey(first, second, uniqueKeys [, ignoreKeys, caseSensitive])` | Compare two arrays of structs by a unique key; returns `add` / `remove` / `update` |
| `isSame(first, second [, caseSensitive])` | `true` / `false` equality check |
| `patch(original, diff)` | Apply a diff to the original and return the new value |
| `diffPatch(original, diff)` | Return the original with each value as `{old, new, type}` |
| `displayDiff(original, diff)` | Return an HTML string visualising the changes |

Change `type` values are `ADD`, `REMOVE`, `CHANGE` (and `SAME` in `diffPatch` output).

## Usage

### diff
Returns an array of changes. `path` is the location of the change (struct keys and array positions, 1-based).

```javascript
var original = { name: "Ann", tags: ["a", "b"], address: { city: "Rome" } };
var updated  = { name: "Ann", tags: ["a", "c"], address: { city: "Paris", zip: "75001" } };

JSONDiff.diff(original, updated);

// Result
[
    { "type": "CHANGE", "path": ["tags", 2],            "old": "b",    "new": "c" },
    { "type": "CHANGE", "path": ["address", "city"],    "old": "Rome", "new": "Paris" },
    { "type": "ADD",    "path": ["address", "zip"],     "old": "",     "new": "75001" }
]
```
(Order of entries may vary.)

#### Ignoring keys
Keys in the ignore array are skipped during comparison.

```javascript
JSONDiff.diff(
    { id: 1, updatedAt: "2024-01-01", status: "open" },
    { id: 1, updatedAt: "2024-02-01", status: "closed" },
    ["updatedAt"]
);

// Result: only status is reported
[ { "type": "CHANGE", "path": ["status"], "old": "open", "new": "closed" } ]
```

#### Case sensitivity
Comparisons are case-insensitive by default. Pass `true` as the last argument to make them case-sensitive.

```javascript
JSONDiff.diff({ name: "ann" }, { name: "ANN" });              // []
JSONDiff.diff({ name: "ann" }, { name: "ANN" }, [], true);    // one CHANGE
```

### diffByKey
Compares two arrays of structs by identifying rows with a unique key (a string, or an array for composite keys). Great for comparing database results.

```javascript
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

// Result
{
    "remove": [   // in the first array only
        { "key": 26, "data": { "id": 26, "x": 480, "y": 0 } },
        { "key": 28, "data": { "id": 28, "x": 482, "y": 10 } }
    ],
    "add": [      // in the second array only
        { "key": 25, "data": { "id": 25, "x": 10,  "y": 0 } },
        { "key": 65, "data": { "id": 65, "x": 298, "y": 0 } }
    ],
    "update": [   // in both, with differences
        {
            "key": 32,
            "orig": { "id": 32, "x": 480, "y": 12 },
            "data": { "id": 32, "x": 415, "y": 2 },
            "changes": [
                { "key": "x", "path": ["x"], "old": 480, "new": 415 },
                { "key": "y", "path": ["y"], "old": 12,  "new": 2 }
            ]
        }
    ]
}
```

#### Composite keys
Pass an array of column names. The returned `key` is an array of the values (a single key returns a plain value).

```javascript
JSONDiff.diffByKey(rowsA, rowsB, ["oid", "member_id"]);
// e.g. "key": [48280, 1988]
```

### isSame
```javascript
JSONDiff.isSame({ a: [1, { b: true }] }, { a: [1, { b: false }] }); // false
JSONDiff.isSame({ a: 1 }, { a: 1 });                                // true
JSONDiff.isSame("Foo", "foo");                                      // true
JSONDiff.isSame("Foo", "foo", true);                                // false (case sensitive)
```

### patch
Applies a diff to the original and returns the resulting value. The inputs are not modified.

```javascript
var original = { name: "Ann", tags: ["a", "b"] };
var updated  = { name: "Bob", tags: ["a", "b", "c"] };
var diff     = JSONDiff.diff(original, updated);

JSONDiff.patch(original, diff);

// Result (equal to `updated`)
{ "name": "Bob", "tags": ["a", "b", "c"] }
```

### diffPatch
Returns the original structure with every value replaced by `{ old, new, type }`. Useful for building your own UI.

```javascript
var original = { name: "Ann", age: 30 };
var diff     = JSONDiff.diff(original, { name: "Bob", age: 30, email: "b@x.com" });

JSONDiff.diffPatch(original, diff);

// Result
{
    "name":  { "type": "CHANGE", "old": "Ann", "new": "Bob" },
    "age":   { "type": "SAME",   "old": 30,    "new": 30 },
    "email": { "type": "ADD",    "old": "",    "new": "b@x.com" }
}
```

### displayDiff
Returns an HTML string of nested `<ul>` lists: removed/old values are red with strikethrough, added/new values are green, unchanged values are grey.

```javascript
var original = { name: "Ann", age: 30 };
var diff     = JSONDiff.diff(original, { name: "Bob", age: 30 });

writeOutput( JSONDiff.displayDiff(original, diff) );
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
