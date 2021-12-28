component singleton {

	function isSame(first, second) {
        if(isNull(first) && isNull(second)) return true;
        if(isNull(first) || isNull(second)) return false;
        if(getMetadata(first).getName() != getMetadata(second).getName() ) return false;
        if(isSimpleValue(first) && first == second ){
            return true;
        }

        // We know that first and second have the same type so we can just check the
        // first type from now on.1
        if (isArray(first) && isArray(second)) {
            // Short circuit if they're not the same length;
            if (first.len() != second.len()) {
                return false;
            }
            for (var i = 1; i <= first.len(); i++) {
                if (isSame(first[i], second[i]) == false) {
                    return false;
                }
            }
            return true;
        }
        if (isStruct(first)  && isStruct(second)) {
            // echo('we are here')
            // An object is equal if it has the same key/value pairs.
            var keysSeen = {};
            for (var key in first) {
                // echo('first -> ' & key & '<br/>');
                if (structKeyExists(first, key) && structKeyExists(second,key)) {
                    if (isSame(first[key], second[key]) == false) {
                        return false;
                    }
                    keysSeen[key] = true;
                }
            }
            // Now check that there aren't any keys in second that weren't
            // in first.
            for (var key2 in second) {
                // echo('second -> ' & key2 &  '<br/>');
                if (!structKeyExists(second, key2) || !structKeyExists(keysSeen,key2)) {
                        return false;
                }
            }
            return true;
        }
        return false;
    }

	function diff(first, second) {
		var diffs = [];

		if (isSimpleValue(first) && isSimpleValue(second) && first != second) {
			diffs.append({
				"path": [],
				"type": "CHANGE",
				"old": first,
				"new": second
			});
		} else if (isArray(first) && isArray(second)) {
			for (var i = 1; i <= first.len(); i++) {
				var path = i;

				if(second.len() < i){
					diffs.append({
						"path": [path],
						"type": "REMOVE",
						"old": first[i],
						"new": ""
					});
				} else if(
					getMetadata(first[i]).getName() != getMetadata(second[i]).getName()
					|| (isSimpleValue(first[i]) && isSimpleValue(second[i]) && first[i] != second[i])
				){
					diffs.append({
						"path": [path],
						"type": "CHANGE",
						"old": first[i],
						"new": second[i]
					});
				} else {
					var nestedDiffs = diff(first[i], second[i]);
					nestedDiffs = nestedDiffs.each((difference) => {
						difference.path.prepend(path);
						diffs.append(difference);
					});
				}
            }
			for (var t = first.len()+1; t <= second.len(); t++) {
				var path = t;
				diffs.append({
					"type": "ADD",
					"path": [path],
					"old": "",
					"new": second[path]
				});
			}

		} else if (isStruct(first) && isStruct(second)) {
            var keysSeen = {};
            for (var key in first) {
				var path = key;
				if(!first.keyExists(key)) first[key] = "";
				if(!second.keyExists(key)){
					diffs.append({
						"path": [path],
						"type": "REMOVE",
						"old": first[key],
						"new": ""
					});
				} else if(
					getMetadata(first[key]).getName() != getMetadata(second[key]).getName()
					|| (isSimpleValue(first[key]) && isSimpleValue(second[key]) && first[key] != second[key])
				){
					diffs.append({
						"path": [path],
						"type": "CHANGE",
						"old": first[key],
						"new": second[key]
					});
				} else {
					if (structKeyExists(first, key) && structKeyExists(second,key)) {
						var nestedDiffs = diff(first[key], second[key]);
						nestedDiffs = nestedDiffs.each((difference) => {
							difference.path.prepend(path);
							diffs.append(difference);
						})
					}
				}
				keysSeen[key] = true;
            }
            // Now check that there aren't any keys in second that weren't
            // in first.
            for (var key2 in second) {
                if (!structKeyExists(second, key2) || !structKeyExists(keysSeen,key2)) {
                    diffs.append({
						"type": "ADD",
						"path": [key2],
						"old": "",
						"new": second[key2]
					});
                }
            }
        }

        return diffs;
    }
}
