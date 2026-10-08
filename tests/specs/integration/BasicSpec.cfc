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

			it("identical structs have no diff", () => {
				expect(jsondiff.diff({ "a": 1 }, { "a": 1 })).toBe([]);
			});

			it("treats numerically equal values as the same", () => {
				var scaled = createObject("java", "java.math.BigDecimal").init("18.110");
				expect(jsondiff.diff({ "a": 1 }, { "a": 1.0 })).toBe([]);
				expect(jsondiff.diff({ "a": 18.11 }, { "a": scaled })).toBe([]);
			});

			it("changes a number", () => {
				expect(jsondiff.diff({ "a": 1 }, { "a": 2 })).toBe([
					{
						type: "CHANGE",
						path: ["a"],
						key: "a",
						old: 1,
						new: 2
					},
				]);
			});

			it("skips ignored keys", () => {
				expect(jsondiff.diff(
					{ "test": true, "dirty": false },
					{ "test": false, "dirty": true },
					["dirty"]
				)).toBe([
					{
						type: "CHANGE",
						path: ["test"],
						key: "test",
						old: true,
						new: false
					},
				]);
			});

			it("skips an ignored nested key", () => {
				expect(jsondiff.diff(
					{ "outer": { "id": 1, "name": "a" } },
					{ "outer": { "id": 2, "name": "b" } },
					["id"]
				)).toBe([
					{
						type: "CHANGE",
						path: ["outer", "name"],
						key: "name",
						old: "a",
						new: "b"
					},
				]);
			});

			it("diffs empty structs", () => {
				expect(jsondiff.diff({}, {})).toBe([]);
				expect(jsondiff.diff({}, { "a": 1 })).toBe([
					{
						type: "ADD",
						path: ["a"],
						old: "",
						new: 1
					},
				]);
				expect(jsondiff.diff({ "a": 1 }, {})).toBe([
					{
						type: "REMOVE",
						path: ["a"],
						old: 1,
						new: ""
					},
				]);
			});

			it("diffs root values", () => {
				expect(jsondiff.diff(1, 1)).toBe([]);
				expect(jsondiff.diff(1, 2)).toBe([
					{
						type: "CHANGE",
						path: [],
						old: 1,
						new: 2
					},
				]);
			});
		})
	}

}
