/**
* This tests the BDD functionality in TestBox. This is CF10+, Lucee4.5+
*/
component extends="testbox.system.BaseSpec"{
	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		jsondiff = new models.jsondiff();
	}

	/*********************************** BDD SUITES ***********************************/

	function run() {
		describe("Test Text", ()=>{
			it("same text value", () => {
				var obj = { test: "foo" };
				var changed = { test: "foo" };
				var diff = jsondiff.diff(obj,changed);
				var patch = jsondiff.diffpatch(obj,diff);
				debug(patch)
				debug(serializeJSON(patch));
				expect(patch).toBe({
					"TEST":{"type":"SAME","old":"foo","new":"foo"},
				});
			});
			it("new text value", () => {
				var obj = {};
				var changed = { test: "bar" };
				var diff = jsondiff.diff(obj,changed);
				var patch = jsondiff.diffpatch(obj,diff);
				debug(patch)
				debug(serializeJSON(patch));
				expect(patch).toBe({
					"TEST":{"type":"ADD","old":"","new":"bar"}
				});
			});
			it("change text value", () => {
				var obj = { test: "foo" };
				var changed = { test: "bar" };
				var diff = jsondiff.diff(obj,changed);
				var patch = jsondiff.diffpatch(obj,diff);
				debug(patch)
				debug(serializeJSON(patch));
				expect(patch).toBe({
					"TEST":{"type":"CHANGE","old":"foo","new":"bar"}
				});
			});
		});
		describe("Test Arrays", ()=>{
			it("same array value", () => {
				var obj = { test: [1]};
				var changed = { test: [1] };
				var diff = jsondiff.diff(obj,changed);
				var patch = jsondiff.diffpatch(obj,diff);
				debug(patch)
				debug(serializeJSON(patch));
				expect(patch).toBe({
					"TEST":[{"type":"SAME","old":1,"new":1}]
				});
			});
			it("add array value", () => {
				var obj = { test: [1]};
				var changed = { test: [1,2] };
				var diff = jsondiff.diff(obj,changed);
				var patch = jsondiff.diffpatch(obj,diff);
				debug(patch)
				debug(serializeJSON(patch));
				expect(patch).toBe({
					"TEST":[{"type":"SAME","old":1,"new":1},{"type":"ADD","old":"","new":2}]
				});
			});
			it("remove array value", () => {
				var obj = { test: [1,2]};
				var changed = { test: [1] };
				var diff = jsondiff.diff(obj,changed);
				var patch = jsondiff.diffpatch(obj,diff);
				debug(patch)
				debug(serializeJSON(patch));
				expect(patch).toBe({
					"TEST":[{"type":"SAME","old":1,"new":1},{"type":"REMOVE","old":"2","new":""}]
				});
			});
			it("new array", () => {
				var obj = {};
				var changed = { test: [] };
				var diff = jsondiff.diff(obj,changed);
				var patch = jsondiff.diffpatch(obj,diff);
				debug(patch)
				debug(serializeJSON(patch));
				expect(patch).toBe({
					"TEST":{"type":"ADD","old":"","new":[]}
				});
			});
			it("remove array", () => {
				var obj = { test: [] };
				var changed = {};
				var diff = jsondiff.diff(obj,changed);
				var patch = jsondiff.diffpatch(obj,diff);
				debug(patch)
				debug(serializeJSON(patch));
				expect(patch).toBe({
					"TEST":{"type":"REMOVE","old":[],"new":""}
				});
			});
		})
		describe("Nested Objects", ()=>{
			it("add and arrays", () => {
				var obj = { test: { foo: [1] } };
				var changed = { test: { bar: [1] } };
				var diff = jsondiff.diff(obj,changed);
				var patch = jsondiff.diffpatch(obj,diff);
				debug(patch)
				debug(serializeJSON(patch));
				expect(patch).toBe({
					"TEST":{
						"FOO":{"type":"REMOVE","old":[1],"new":""},
						"BAR":{"type":"ADD","old":"","new":[1]}
					}
				});
			});
			it("change nested props", () => {
				var obj = { test: { foo: { bar: "a" } } };
				var changed = { test: { foo: { bar: "b" } } };
				var diff = jsondiff.diff(obj,changed);
				var patch = jsondiff.diffpatch(obj,diff);
				debug(patch)
				debug(serializeJSON(patch));
				expect(patch).toBe({
					"TEST":{
						"FOO":{
							"BAR":{"type":"CHANGE","old":"a","new":"b"}
						}
					}
				});
			});
		});
	}

}
