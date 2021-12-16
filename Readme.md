# JSON Diff
An ColdFusion utility for checking if 2 JSON objects have differences


## Installation
```javascript
property name="jsondiff" inject="jsondiff"; //wirebox

JMESPath = new path.to.the.cfc.jsondiff(); //Instantiate Object

```
## Basic Usage
Call `jsondiff.diff` with a valid JMESPath search expression and data to search. It will return the extracted values.

```javascript
    jsondiff.diff(
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

Call `jsondiff.isSame` with a valid JMESPath search expression and data to search. It will return the extracted values.

```javascript
    jsondiff.isSame(
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