component singleton {

    variables.uniqueKeyName = '________key';
    boolean function numericCheck(value) {
        if (
            getMetadata(arguments.value).getName() == 'java.lang.Double' ||
            getMetadata(arguments.value).getName() == 'java.lang.Integer'
        ) {
            return true;
        }
        return false
    }
    
    boolean function isSameSimpleValue(any first, any second, boolean caseSensitive = false) {
        if(!isSimpleValue(arguments.first) || !isSimpleValue(arguments.second)) {
            return false;
        } else if (this.numericCheck(arguments.first) && this.numericCheck(arguments.second) && precisionEvaluate(arguments.first - arguments.second) != 0) {
            return false;
        } else if (arguments.caseSensitive && compare(arguments.first, arguments.second) != 0) {
            return false;
        } else if (arguments.first != arguments.second) {
            return false;
        }
        return true;
    }

    boolean function isSame(any first, any second, boolean caseSensitive = false) {
        if (isNull(arguments.first) && isNull(arguments.second)) {
            return true;
        }
        if (isNull(arguments.first) || isNull(arguments.second)) {
            return false;
        }
        if (this.isSameSimpleValue(arguments.first, arguments.second, arguments.caseSensitive)) {
            return true;
        }

        // We know that first and second have the same type so we can just check the
        // first type from now on.1
        if (isArray(arguments.first) && isArray(arguments.second)) {
            // Short circuit if they're not the same length;
            if (arguments.first.len() != arguments.second.len()) {
                return false;
            }
            for (var i = 1; i <= arguments.first.len(); i++) {
                if (this.isSame(arguments.first[i], arguments.second[i], arguments.caseSensitive) == false) {
                    return false;
                }
            }
            return true;
        }

        if (isStruct(arguments.first) && isStruct(arguments.second)) {
            // echo('we are here')
            // An object is equal if it has the same key/value pairs.
            var keysSeen = {};
            for (var key in arguments.first) {
                // echo('first -> ' & key & '<br/>');
                if (structKeyExists(arguments.first, key) && structKeyExists(arguments.second, key)) {
                    if (this.isSame(arguments.first[key], arguments.second[key], arguments.caseSensitive) == false) {
                        return false;
                    }
                    keysSeen[key] = true;
                }
            }
            // Now check that there aren't any keys in second that weren't
            // in first.
            for (var key2 in arguments.second) {
                // echo('second -> ' & key2 &  '<br/>');
                if (!structKeyExists(arguments.second, key2) || !structKeyExists(keysSeen, key2)) {
                    return false;
                }
            }
            return true;
        }
        return false;
    }

    struct function groupData(required array data, required array uniqueKeys) {
        var out = {};
        for( var x in data ) {
            var uniqueKey = [];
            for( var key in arguments.uniqueKeys ) {
                uniqueKey.append(x[key]);
            }
            uniqueKey = serializeJSON(uniqueKey);
            x[variables.uniqueKeyName] = uniqueKey;
            out[uniqueKey] = x;
        }
        return out;
    }

    struct function diffByKey(
        array first = [],
        array second = [],
        required any uniqueKeys,
        array ignoreKeys = [],
        boolean caseSensitive = false
    ) {
        if (!isArray(arguments.uniqueKeys)) {
            arguments.uniqueKeys = [arguments.uniqueKeys];
        }
        var data1 = this.groupData(arguments.first, arguments.uniqueKeys);
        var data2 = this.groupData(arguments.second, arguments.uniqueKeys);
        var diffData = this.diff(data1, data2, arguments.ignoreKeys, arguments.caseSensitive);
        var groupedDiff = {'add': [], 'remove': [], 'change': {}};
        for( var x in diffData ) {
            if (x.type == 'add') {
                var key = x.new[variables.uniqueKeyName];
                x.new.delete(variables.uniqueKeyName)
                groupedDiff[x.type].append({'key': this.deserializeKey(key), 'data': x.new});
            } else if (x.type == 'remove') {
                var key = x.old[variables.uniqueKeyName];
                x.old.delete(variables.uniqueKeyName)
                groupedDiff[x.type].append({'key': this.deserializeKey(key), 'data': x.old});
            } else if (x.type == 'change') {
                if (!groupedDiff[x.type].keyExists(x.path[1])) {
                    groupedDiff[x.type][x.path[1]] = [];
                }
                var pathRest = arraySlice(x.path, 2);
                groupedDiff[x.type][x.path[1]].append({
                    'key': pathRest[1],
                    'path': pathRest,
                    'new': x.new,
                    'old': x.old
                });
            }
        }
        groupedDiff['update'] = [];
        for( var key in groupedDiff.change ) {
            var value = groupedDiff.change[ key ];
            data1[key].delete(variables.uniqueKeyName);
            data2[key].delete(variables.uniqueKeyName);
            groupedDiff['update'].push({
                'key': this.deserializeKey(key),
                'orig': data1[key],
                'data': data2[key],
                'changes': value
            });
        }
        groupedDiff.delete('change');
        for( var row in arguments.first ) {
            row.delete(variables.uniqueKeyName);
        }
        for( var row in arguments.second ) {
            row.delete(variables.uniqueKeyName);
        }
        return groupedDiff;
    }

    any function deserializeKey(required string serializedKey) {
        var valueArr = deserializeJSON(serializedKey);
        if (valueArr.len() == 1) return valueArr[1];
        return valueArr;
    }

    // Now check that there aren't any keys in second that weren't
    array function diff(any first = '', any second = '', array ignoreKeys = [], boolean caseSensitive = false) {
        var diffs = [];
        if (
            (isSimpleValue(arguments.first) && !isSimpleValue(arguments.second))
            || (!isSimpleValue(arguments.first) && isSimpleValue(arguments.second))
        ) {
            diffs.append({
                'path': [],
                'type': 'CHANGE',
                'old': arguments.first,
                'new': arguments.second
            });
        } else if (isSimpleValue(arguments.first) && isSimpleValue(arguments.second)) {
            if(!this.isSameSimpleValue(arguments.first, arguments.second, arguments.caseSensitive)) {
                diffs.append({
                    'path': [],
                    'type': 'CHANGE',
                    'old': arguments.first,
                    'new': arguments.second
                });
            }
        } else if (isArray(arguments.first) && isArray(arguments.second)) {
            for (var i = 1; i <= arguments.first.len(); i++) {
                var path = i;
                arguments.first[i] = isNull(arguments.first[i]) ? '' : arguments.first[i];

                if (arguments.second.len() < i) {
                    diffs.append({
                        'path': [path],
                        'type': 'REMOVE',
                        'old': arguments.first[i],
                        'new': ''
                    });
                } else {
                    arguments.second[i] = isNull(arguments.second[i]) ? '' : arguments.second[i];
                    if (isSimpleValue(arguments.first[i]) && isSimpleValue(arguments.second[i])) {
                        if(!this.isSameSimpleValue(arguments.first[i], arguments.second[i], arguments.caseSensitive)) {
                            diffs.append({
                                'path': [path],
                                'type': 'CHANGE',
                                'old': arguments.first[i],
                                'new': arguments.second[i]
                            });
                        }
                    } else {
                        var nestedDiffs = this.diff(arguments.first[i], arguments.second[i], arguments.ignoreKeys, arguments.caseSensitive);
                        for( var difference in nestedDiffs ) {
                            difference.path.prepend(path);
                            diffs.append(difference);
                        }
                    }
                }
            }
            for (var t = arguments.first.len() + 1; t <= arguments.second.len(); t++) {
                var path = t;
                diffs.append({
                    'type': 'ADD',
                    'path': [path],
                    'old': '',
                    'new': isNull( arguments.second[path] ) ? '' : arguments.second[path]
                });
            }
        } else if (isStruct(arguments.first) && isStruct(arguments.second)) {
            var keysSeen = [];
            var firstKeys = structKeyArray(arguments.first);
            var secondKeys = structKeyArray(arguments.second);
            for (var key in arguments.first) {
                var path = key;
                if (arguments.ignoreKeys.find(key) > 0) {
                    continue;
                }
                if (!firstKeys.findNoCase(key) || isNull( arguments.first[key])) {
                    arguments.first[key] = '';
                }
                if (!secondKeys.findNoCase(key) || isNull( arguments.second[key])) {
                    diffs.append({
                        'path': [path],
                        'type': 'REMOVE',
                        'old': arguments.first[key],
                        'new': ''
                    });
                } else {
                    if (isNull(arguments.second[key])) {
                        arguments.second[key] = '';
                    }
                    if (isSimpleValue(arguments.first[key]) && isSimpleValue(arguments.second[key])) {
                        if(!this.isSameSimpleValue(arguments.first[key], arguments.second[key], arguments.caseSensitive)) {
                            diffs.append({
                                'key': path,
                                'path': [path],
                                'type': 'CHANGE',
                                'old': arguments.first[key],
                                'new': arguments.second[key]
                            });
                        }
                    } else if (firstKeys.findNoCase(key) && secondKeys.findNoCase(key)) {
                        var nestedDiffs = this.diff(arguments.first[key], arguments.second[key], arguments.ignoreKeys, arguments.caseSensitive);
                        for( var difference in nestedDiffs ) {
                            difference.path.prepend(path);
                            diffs.append(difference);
                        }
                    }
                }
                keysSeen.append( key );
            }
            // Now check that there aren't any keys in second that weren't
            // in first.
            for (var key2 in arguments.second) {
                if (arguments.ignoreKeys.find(key2) > 0) {
                    continue;
                }
                if (secondKeys.findNoCase(key2) && !keysSeen.findNoCase(key2)) {
                    if (isNull(arguments.second[key2])) {
                        arguments.second[key2] = '';
                    }
                    diffs.append({
                        'type': 'ADD',
                        'path': [key2],
                        'old': '',
                        'new': arguments.second[key2]
                    });
                }
            }
        } else {
            diffs = ["something went wrong"];
        }

        return diffs;
    }

    any function patch(required any original, array diff = []) {
        var _original = duplicate(arguments.original);
        var _diff = duplicate(arguments.diff);
        var diffPatchObj = this.diffPatch(original, diff);
        return this.runPatch(diffPatchObj);
    }

    any function runPatch(required struct diffPatchObj) {
        var _diffPatchObj = duplicate(arguments.diffPatchObj);
        if (isArray(_diffPatchObj)) {
            for (var i = 1; i <= _diffPatchObj.len(); i++) {
                _diffPatchObj[i] = this.runPatch(_diffPatchObj[i]);
            }
        } else if (isStruct(_diffPatchObj)) {
            if (isStruct(_diffPatchObj) && _diffPatchObj.keyExists('new')) {
                _diffPatchObj = _diffPatchObj.new;
            } else {
                for (var key in _diffPatchObj) {
                    _diffPatchObj[key] = this.runPatch(_diffPatchObj[key]);
                }
            }
        }
        return _diffPatchObj;
    }

    string function displayDiff(required any original, array diff = []) {
        var _original = duplicate(arguments.original);
        var _diff = duplicate(arguments.diff);
        var _diffPatchObj = this.diffPatch(_original, _diff);
        return arrayToList(this.diffToHTML(_diffPatchObj), '');
    }

    array function diffToHTML(required diffPatchObj, array nodes = []) {
        var _diffPatchObj = duplicate(arguments.diffPatchObj);
        if (isArray(_diffPatchObj)) {
            arguments.nodes.append('<ul>');
            for (var i = 1; i <= _diffPatchObj.len(); i++) {
                arguments.nodes.append('<li>');
                arguments.nodes.append('<span style="font-weight:bold">#i#</span> ');
                arguments.nodes = this.diffToHTML(_diffPatchObj[i], arguments.nodes);
                arguments.nodes.append('</li>');
            }
            arguments.nodes.append('</ul>');
        } else if (isStruct(_diffPatchObj)) {
            if (isStruct(_diffPatchObj) && _diffPatchObj.keyExists('new')) {
                if (_diffPatchObj.type == 'CHANGE') {
                    arguments.nodes.append('<span style="background: ##ffbbbb;text-decoration: line-through;">#serializeJson( _diffPatchObj.old )#</span> ');
                    arguments.nodes.append('<span style="background: ##bbffbb;">#serializeJson( _diffPatchObj.new )#</span> (change)');
                } else if (_diffPatchObj.type == 'ADD') {
                    arguments.nodes.append('<span style="background: ##bbffbb;">#serializeJson( _diffPatchObj.new )#</span> (add)');
                } else if (_diffPatchObj.type == 'REMOVE') {
                    arguments.nodes.append('<span style="background: ##ffbbbb;text-decoration: line-through;">#serializeJson( _diffPatchObj.old )#</span> (remove) ');
                } else {
                    arguments.nodes.append('<span style="color:##666">#serializeJson( _diffPatchObj.old )#</span> (same)');
                }
            } else {
                arguments.nodes.append('<ul>');
                for (var key in _diffPatchObj) {
                    arguments.nodes.append('<li>');
                    arguments.nodes.append('<span style="font-weight:bold">#key#</span>: ');
                    arguments.nodes = this.diffToHTML(_diffPatchObj[key], arguments.nodes);
                    arguments.nodes.append('</li>');
                }
                arguments.nodes.append('</ul>');
            }
        }
        return arguments.nodes;
    }

    any function diffPatch(required any original, array diff = []) {
        var _original = duplicate(arguments.original);
        var _diff = duplicate(arguments.diff);
        var filterDiffs = {matches: {}, unmatched: []};
        for( var changeItem in _diff ) {
            if (changeItem.path.len() == 1) {
                filterDiffs.matches[changeItem.path[1]] = {
                    'old': changeItem.old,
                    'new': changeItem.new,
                    'type': changeItem.type
                };
            } else {
                filterDiffs.unmatched.append(changeItem);
            }
        }

        var levelDiffs = filterDiffs.matches;

        if (isSimpleValue(_original)) {
            if (_diff.len()) {
                _original = {'old': _diff[1].old, 'new': _diff[1].new, 'type': _diff[1].type};
            } else {
                arguments.original = {'old': _original, 'new': _original, 'type': 'SAME'}
            }
        } else if (isArray(_original)) {
            for (var i = 1; i <= _original.len(); i++) {
                var path = i;
                if (isSimpleValue(_original[i])) {
                    if (levelDiffs.keyExists(path)) {
                        _original[i] = levelDiffs[path];
                        structDelete(levelDiffs, path);
                    } else {
                        _original[i] = {'old': _original[i], 'new': _original[i], 'type': 'SAME'}
                    }
                } else {
                    var subDiffs = [];
                    for( var changeItem in filterDiffs.unmatched ) {
                        if (changeItem.path.len() > 1 && changeItem.path[1] == path) {
                            arrayDeleteAt(changeItem.path, 1);
                            subDiffs.append(changeItem);
                        }
                    }
                    _original[i] = this.diffPatch(_original[i], subDiffs);
                }
            }
        } else if (isStruct(_original)) {
            for (var key in _original) {
                var path = key;
                if (isSimpleValue(_original[key])) {
                    if (levelDiffs.keyExists(path)) {
                        _original[key] = levelDiffs[path];
                        structDelete(levelDiffs, path);
                    } else {
                        _original[key] = {'old': _original[key], 'new': _original[key], 'type': 'SAME'}
                    }
                } else {
                    var subDiffs = [];
                    for( var changeItem in filterDiffs.unmatched ) {
                        if (changeItem.path.len() > 1 && changeItem.path[1] == path) {
                            arrayDeleteAt(changeItem.path, 1);
                            subDiffs.append(changeItem);
                        }
                    }
                    _original[key] = this.diffPatch(_original[key], subDiffs);
                }
            }
        }

        // ADDED Items
        for (var diffKey in levelDiffs) {
            if (isSimpleValue(levelDiffs[diffKey]['new'])) {
                _original[diffKey] = levelDiffs[diffKey];
            } else if (isStruct(levelDiffs[diffKey]['new'])) {
                _original[diffKey] = {};
                for (var subDiffKey in levelDiffs[diffKey]['new']) {
                    _original[diffKey][subDiffKey] = {
                        'old': '',
                        'new': levelDiffs[diffKey]['new'][subDiffKey],
                        'type': 'ADD'
                    }
                }
            } else if (isArray(levelDiffs[diffKey]['new'])) {
                _original[diffKey] = {
                    'old': '',
                    'new': levelDiffs[diffKey]['new'],
                    'type': 'ADD'
                }
            }
        }
        return _original;
    }

}
