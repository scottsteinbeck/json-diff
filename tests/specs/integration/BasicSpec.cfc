/**
* This tests the BDD functionality in TestBox. This is CF10+, Lucee4.5+
*/
component extends="testbox.system.BaseSpec"{
	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		application.debug = debug;
		jsondiff = new models.jsondiff();
	}

	/*********************************** BDD SUITES ***********************************/

	function run() {
		describe("Test Basic Functions", ()=>{
			it("new raw value", () => {
				expect(jsondiff.diff({ test: true }, { test: true, test2: true })).toBe([
					{
						type: "ADD",
						path: ["test2"],
						old: "",
						new: true
					},
				]);
			});
			it("change raw value", () => {
				expect(jsondiff.diff({ test: true }, { test: false })).toBe([
					{
						type: "CHANGE",
						path: ["test"],
						key: "test",
						old: true,
						new: false
					},
				]);
			});
			it("remove raw value", () => {
				expect(jsondiff.diff({ test: true, test2: true }, { test: true })).toBe([
					{
						type: "REMOVE",
						path: ["test2"],
						old: true,
						new: ""
					},
				]);
			});
			
			it("replace object with null", () => {
				expect(jsondiff.diff({ object: { test: true } }, { object: "null" })).toBe([
					{
						type: "CHANGE",
						path: ["object"],
						old: { test: true },
						new: "null",
					},
				]);
			});
			
			it("replace object with other value", () => {
				expect(jsondiff.diff({ object: { test: true } }, { object: "string" })).toBe([
					{
						type: "CHANGE",
						path: ["object"],
						old: { test: true },
						new: "string",
					},
				]);
			});
			
			it("add array", () => {
				expect(jsondiff.diff({ }, { array: [] })).toBe([
					{
						type: "ADD",
						path: ["array"],
						old: "",
						new: [],
					},
				]);
			});
			
			it("change property to null", () => {
				var obj = { test: "foo"};
				var changed = { test: nullValue() };
				var diff = jsondiff.diff(obj,changed);
				debug( diff );
				debug( serializeJSON( diff ) );
				expect(diff).toBe([{
					path: ["TEST"],
					old: "foo",
					type: "REMOVE",
					new: ""
				}]);
			});
			
			it("remove null property", () => {
				var obj = { test: nullValue() };
				var changed = {};
				var diff = jsondiff.diff(obj,changed);
				debug( diff );
				debug( serializeJSON( diff ) );
				expect(diff).toBe([{
					path:["TEST"],
					old:"",
					type:"REMOVE",
					new:""
				}]);
			});
			
			it("add null property", () => {
				var obj = {};
				var changed = { test: nullValue() };
				var diff = jsondiff.diff(obj,changed);
				debug( changed );
				debug( diff );
				debug( serializeJSON( diff ) );
				expect(diff).toBe([{
					path: ["TEST"],
					old: "",
					type: "ADD",
					new: ""
				}]);
			});
		})
		describe("Test Case Sensitivity", ()=>{
			it("change case with sensitivity off", () => {
				expect(jsondiff.diff( "foo", "FOO" )).toBe([]);
			});
			it("change case with sensitivity on", () => {
				expect(jsondiff.diff( "foo", "FOO", [], true)).toBe([
					{
						type: "CHANGE",
						path: [],
						old: "foo",
						new: "FOO"
					},
				]);
			});
			it("change struct value case", () => {
				expect(jsondiff.diff({ test: "foo" }, { test: "FOO" }, [], true)).toBe([
					{
						type: "CHANGE",
						path: ["test"],
						key: "test",
						old: "foo",
						new: "FOO"
					},
				]);
			});
			
			it("change array value case", () => {
				expect(jsondiff.diff({ test: ["foo"] }, { test: ["FOO"] }, [], true)).toBe([
					{
						type: "CHANGE",
						path: ["TEST", 1],
						old: "foo",
						new: "FOO"
					},
				]);
			});
			
		})
	}

}
