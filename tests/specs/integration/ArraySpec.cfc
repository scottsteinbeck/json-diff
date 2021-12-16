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
		describe("Test Array Functions", ()=>{
			it("top level array & array diff", () => {
				expect(jsondiff.diff(["test", "testing"], ["test"])).toBe([
					{
						"type": "REMOVE",
						"path": [2],
						"old": "testing",
						"new": ""
					}
				]);
			});

			it("nested array", () => {
				expect(jsondiff.diff(["test", ["test"]], ["test", ["test", "test2"]])).toBe(
					[{
						"type":"ADD",
						"path":[2,2],
						"old":"",
						"new":"test2"
					}]
				);
			});

			it("object in array in object", () => {
				expect(
					jsondiff.diff(
						{ test: ["test", { test: true }] },
						{ test: ["test", { test: false }] }
					)).toBe(
					[
						{
							"type": "CHANGE",
							"path": ["test", 2, "test"],
							"old": true,
							"new": false,
						},
					]
				);
			});
		})
	}

}
