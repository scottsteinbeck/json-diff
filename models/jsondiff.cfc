component singleton {

	function numericCheck(value){
        if (
            getMetadata(value).getName() == 'java.lang.Double' ||
            getMetadata(value).getName() == 'java.lang.Integer'
        ) return true;
		return false
	}

	function isSame(first, second) {

        if(isNull(first) && isNull(second)) return true;
        if(isNull(first) || isNull(second)) return false;
        if(isSimpleValue(first) && isSimpleValue(second) ){
				if(numericCheck(first) && numericCheck(second) &&  precisionEvaluate(first - second) != 0 ){
					return false;
				} else if(first != second){
					return false;
				}
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


	function diffByKey(array first = [], array second = [], required string uniqueKey,  array ignoreKeys = []) {
		var data1 = first.reduce((acc,x)=>{acc[x[uniqueKey]] = x; return acc},{});
		var data2 = second.reduce((acc,x)=>{acc[x[uniqueKey]] = x; return acc},{});
		var diffData = diff(data1, data2, ignoreKeys);
		var groupedDiff = diffData.reduce((acc,x)=>{
			if(x.type == 'add'){
				acc[x.type].append({
					'key': x.new[uniqueKey],
					'data': x.new
				});
			} else if(x.type == 'remove'){
				acc[x.type].append({
					'key': x.old[uniqueKey],
					'data': x.old
				});
			} else if(x.type == 'change'){
				if(!acc[x.type].keyExists(x.path[1])) acc[x.type][x.path[1]] = []; 
				var pathRest =  arraySlice(x.path, 2);
				acc[x.type][x.path[1]].append({
					'key': pathRest[1],
					'path': pathRest,
					'new': x.new,
					'old': x.old
				});
			}
			return acc
		},{add = [], remove=[], change={}});
		groupedDiff.update = groupedDiff.change.reduce((acc,key,value)=>{
			acc.push({
				'key':key,
				'oldData': data1[key],
				'newData': data2[key],
				'changes': value
			})
			return acc;
		},[]);
		groupedDiff.delete('change');
		return groupedDiff;
	}
	

	// Now check that there aren't any keys in second that weren't
	function diff(any first = "", any second = "", array ignoreKeys = []) {

		var diffs = [];
		if(
			(isSimpleValue(first) && !isSimpleValue(second))
			|| (!isSimpleValue(first) && isSimpleValue(second))
		) {
			diffs.append({
				"path": [],
				"type": "CHANGE",
				"old": first,
				"new": second
			});
		} else if(isSimpleValue(first) && isSimpleValue(second)) {
			if(
				numericCheck(first)
				&& numericCheck(second)
			){
				if( precisionEvaluate(first - second) != 0) {

					diffs.append({
						"path": [],
						"type": "CHANGE",
						"old": first,
						"new": second
					});
				}
			} else if(first != second){
				diffs.append({
					"path": [],
					"type": "CHANGE",
					"old": first,
					"new": second
				});
			}
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
				} else if(isSimpleValue(first[i]) && isSimpleValue(second[i])) {
					if(
						numericCheck(first[i])
						&& numericCheck(second[i])
					){
						if( precisionEvaluate(first[i] - second[i]) != 0) {

							diffs.append({
								"path": [path],
								"type": "CHANGE",
								"old": first[i],
								"new": second[i]
							});
						}
					} else if(first[i] != second[i]){
						diffs.append({
							"path": [path],
							"type": "CHANGE",
							"old": first[i],
							"new": second[i]
						});
					}
				} else {
					var nestedDiffs = diff(first[i], second[i],ignoreKeys);
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
				if(ignoreKeys.find(key) > 0){
					 continue;
				}
				if(!first.keyExists(key)) first[key] = "";
				if(!second.keyExists(key)){
					diffs.append({
						"path": [path],
						"type": "REMOVE",
						"old": first[key],
						"new": ""
					});
				} else if(isSimpleValue(first[key]) && isSimpleValue(second[key])) {
					if(
						numericCheck(first[key])
						&& numericCheck(second[key])
					){
						if( precisionEvaluate(first[key] - second[key]) != 0) {

							diffs.append({
								"path": [path],
								"type": "CHANGE",
								"old": first[key],
								"new": second[key]
							});
						}
					} else if(first[key] != second[key]){
						diffs.append({
							"path": [path],
							"type": "CHANGE",
							"old": first[key],
							"new": second[key]
						});
					}
				} else {
					if (structKeyExists(first, key) && structKeyExists(second,key)) {
						var nestedDiffs = diff(first[key], second[key],ignoreKeys);
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
				if(ignoreKeys.find(key2) > 0) {
					continue;
				};
                if (structKeyExists(second, key2) && !structKeyExists(keysSeen,key2)) {
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
