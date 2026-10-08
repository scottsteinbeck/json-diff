/**
* This tests the BDD functionality in TestBox. This is CF10+, Lucee4.5+
*/
component extends="testbox.system.BaseSpec"{
	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		jsondiff = new models.jsondiff();
	}

	/**
	* Grouped results follow struct iteration order, which is not the same on every engine.
	* Sort grouped rows and field changes before comparing so the spec checks the same changes on every engine.
	*/
	private function normalizeGroupedDiff(required struct diff) {
		var result = duplicate(arguments.diff);
		for (var bucket in ["add", "remove", "update"]) {
			if (!result.keyExists(bucket) || !isArray(result[bucket])) {
				continue;
			}
			result[bucket].sort(function(a, b) {
				return compare(serializeJSON(a.key), serializeJSON(b.key));
			});
		}
		if (result.keyExists("update")) {
			result.update.each(function(row) {
				row.changes.sort(function(a, b) {
					return compare(a.key, b.key);
				});
			});
		}
		return result;
	}

	/*********************************** BDD SUITES ***********************************/

	function run() {
		describe("Test Array Functions", ()=>{


			it("object in array in object", () => {
				expect(
					normalizeGroupedDiff(jsondiff.diffByKey(
					[
						{"oid":48539,"crop_string":"","field_id":"2 Block 1","water_type":2,"field_acres":18.11,"member_id":1988,"gsaid":"GKGSA","landiq_crops":"Olives"},
						{"oid":48382,"crop_string":"","field_id":"2 Block 2","water_type":2,"field_acres":19.08,"member_id":1988,"gsaid":"EKGSA","landiq_crops":"Olives"},
						{"oid":48381,"crop_string":"","field_id":"Block 5","water_type":2,"field_acres":12.2,"member_id":1988,"gsaid":"EKGSA","landiq_crops":"Citrus"},
						{"oid":48380,"crop_string":"","field_id":"Block 4","water_type":2,"field_acres":2.45,"member_id":1988,"gsaid":"EKGSA","landiq_crops":"Citrus"},
						{"oid":48379,"crop_string":"","field_id":"Block 3","water_type":2,"field_acres":8.38,"member_id":1988,"gsaid":"EKGSA","landiq_crops":"Citrus"},
						{"oid":48378,"crop_string":"","field_id":"Block 2","water_type":2,"field_acres":11.02,"member_id":1988,"gsaid":"EKGSA","landiq_crops":"Citrus"},
						{"oid":48280,"crop_string":"apple","field_id":"2 Block 1","water_type":2,"field_acres":18.11,"member_id":1988,"gsaid":"EKGSA","landiq_crops":"Citrus"},
						{"oid":48377,"crop_string":"","field_id":"Block 1","water_type":2,"field_acres":3.62,"member_id":1988,"gsaid":"EKGSA","landiq_crops":"Citrus"}
					],
					[
						{"oid":48239,"crop_string":"apple","field_id":"2 Block 1","water_type":2,"field_acres":18.11,"member_id":1988,"gsaid":"EKGSA","landiq_crops":"Citrus"},
						{"oid":48539,"crop_string":"apple","field_id":"2 Block 1","water_type":2,"field_acres":18.11,"member_id":1988,"gsaid":"EKGSA","landiq_crops":"Citrus"},
						{"oid":48382,"crop_string":"items","field_id":"2 Block s2","water_type":2,"field_acres":19.08,"member_id":1988,"gsaid":"GKGSA","landiq_crops":"Olives"},
						{"oid":48381,"crop_string":"tops","field_id":"Block 15","water_type":2,"field_acres":12.2,"member_id":1988,"gsaid":"EKGSA","landiq_crops":"Citrus"},
						{"oid":48380,"crop_string":"","field_id":"Block 4","water_type":2,"field_acres":2.45,"member_id":1988,"gsaid":"GKGSA","landiq_crops":"Citrus"},
						{"oid":48379,"crop_string":"","field_id":"Block 3","water_type":2,"field_acres":8.38,"member_id":1988,"gsaid":"EKGSA","landiq_crops":"Olives"},
						{"oid":48378,"crop_string":"","field_id":"Block 2","water_type":2,"field_acres":11.02,"member_id":1988,"gsaid":"GKGSA","landiq_crops":"Citrus"},
						{"oid":48377,"crop_string":"","field_id":"Block 1","water_type":2,"field_acres":3.62,"member_id":1988,"gsaid":"EKGSA","landiq_crops":"Citrus"}
					],
					['oid','member_id']
				))).toBe(normalizeGroupedDiff(
					{
						"remove":[{"data":{"oid":48280,"crop_string":"apple","field_id":"2 Block 1","water_type":2,"gsaid":"EKGSA","member_id":1988,"field_acres":18.11,"landiq_crops":"Citrus"},"key":[48280,1988]}],"update":[{"data":{"oid":48380,"crop_string":"","field_id":"Block 4","water_type":2,"gsaid":"GKGSA","member_id":1988,"field_acres":2.45,"landiq_crops":"Citrus"},
						"changes":[{"path":["gsaid"],"key":"gsaid","old":"EKGSA","new":"GKGSA"}],"orig":{"oid":48380,"crop_string":"","field_id":"Block 4","water_type":2,"gsaid":"EKGSA","member_id":1988,"field_acres":2.45,"landiq_crops":"Citrus"},"key":[48380,1988]},{"data":{"oid":48382,"crop_string":"items","field_id":"2 Block s2","water_type":2,"gsaid":"GKGSA","member_id":1988,"field_acres":19.08,"landiq_crops":"Olives"},"changes":[{"path":["crop_string"],"key":"crop_string","old":"","new":"items"},{"path":["field_id"],"key":"field_id","old":"2 Block 2","new":"2 Block s2"},{"path":["gsaid"],"key":"gsaid","old":"EKGSA","new":"GKGSA"}],"orig":{"oid":48382,"crop_string":"","field_id":"2 Block 2","water_type":2,"gsaid":"EKGSA","member_id":1988,"field_acres":19.08,"landiq_crops":"Olives"},"key":[48382,1988]},{"data":{"oid":48378,"crop_string":"","field_id":"Block 2","water_type":2,"gsaid":"GKGSA","member_id":1988,"field_acres":11.02,"landiq_crops":"Citrus"},"changes":[{"path":["gsaid"],"key":"gsaid","old":"EKGSA","new":"GKGSA"}],"orig":{"oid":48378,"crop_string":"","field_id":"Block 2","water_type":2,"gsaid":"EKGSA","member_id":1988,"field_acres":11.02,"landiq_crops":"Citrus"},"key":[48378,1988]},{"data":{"oid":48379,"crop_string":"","field_id":"Block 3","water_type":2,"gsaid":"EKGSA","member_id":1988,"field_acres":8.38,"landiq_crops":"Olives"},"changes":[{"path":["landiq_crops"],"key":"landiq_crops","old":"Citrus","new":"Olives"}],"orig":{"oid":48379,"crop_string":"","field_id":"Block 3","water_type":2,"gsaid":"EKGSA","member_id":1988,"field_acres":8.38,"landiq_crops":"Citrus"},"key":[48379,1988]},
						{"data":{"oid":48381,"crop_string":"tops","field_id":"Block 15","water_type":2,"gsaid":"EKGSA","member_id":1988,"field_acres":12.2,"landiq_crops":"Citrus"},"changes":[{"path":["crop_string"],"key":"crop_string","old":"","new":"tops"},{"path":["field_id"],"key":"field_id","old":"Block 5","new":"Block 15"}],"orig":{"oid":48381,"crop_string":"","field_id":"Block 5","water_type":2,"gsaid":"EKGSA","member_id":1988,"field_acres":12.2,"landiq_crops":"Citrus"},"key":[48381,1988]},{"data":{"oid":48539,"crop_string":"apple","field_id":"2 Block 1","water_type":2,"gsaid":"EKGSA","member_id":1988,"field_acres":18.11,"landiq_crops":"Citrus"},"changes":[{"path":["crop_string"],"key":"crop_string","old":"","new":"apple"},{"path":["gsaid"],"key":"gsaid","old":"GKGSA","new":"EKGSA"},{"path":["landiq_crops"],"key":"landiq_crops","old":"Olives","new":"Citrus"}],"orig":{"oid":48539,"crop_string":"","field_id":"2 Block 1","water_type":2,"gsaid":"GKGSA","member_id":1988,"field_acres":18.11,"landiq_crops":"Olives"},"key":[48539,1988]}],
						"add":[{"data":{"oid":48239,"crop_string":"apple","field_id":"2 Block 1","water_type":2,"gsaid":"EKGSA","member_id":1988,"field_acres":18.11,"landiq_crops":"Citrus"},"key":[48239,1988]}]}

				));
			});

			it("diffs by a single key", () => {
				expect(jsondiff.diffByKey(
					[
						{ "id": 1, "name": "a" },
						{ "id": 2, "name": "b" }
					],
					[
						{ "id": 2, "name": "c" },
						{ "id": 3, "name": "d" }
					],
					"id"
				)).toBe({
					"remove": [{ "data": { "id": 1, "name": "a" }, "key": 1 }],
					"update": [{
						"data": { "id": 2, "name": "c" },
						"changes": [{ "path": ["name"], "key": "name", "old": "b", "new": "c" }],
						"orig": { "id": 2, "name": "b" },
						"key": 2
					}],
					"add": [{ "data": { "id": 3, "name": "d" }, "key": 3 }]
				});
			});

			it("reports no groups when rows match", () => {
				var first = [{ "id": 1, "name": "a" }];
				var second = [{ "id": 1, "name": "a" }];
				expect(jsondiff.diffByKey(first, second, "id")).toBe({
					"add": [],
					"remove": [],
					"update": []
				});
				expect(structKeyExists(first[1], "________key")).toBeFalse();
				expect(structKeyExists(second[1], "________key")).toBeFalse();
			});

			it("skips ignored keys when grouping", () => {
				expect(jsondiff.diffByKey(
					[{ "id": 1, "name": "a", "dirty": false }],
					[{ "id": 1, "name": "b", "dirty": true }],
					"id",
					["dirty"]
				)).toBe({
					"remove": [],
					"update": [{
						"data": { "id": 1, "name": "b", "dirty": true },
						"changes": [{ "path": ["name"], "key": "name", "old": "a", "new": "b" }],
						"orig": { "id": 1, "name": "a", "dirty": false },
						"key": 1
					}],
					"add": []
				});
			});

			it("returns empty groups for empty arrays", () => {
				expect(jsondiff.diffByKey([], [], "id")).toBe({
					"add": [],
					"remove": [],
					"update": []
				});
			});
		})
	}

}
