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


			it("object in array in object", () => {
				var diff = jsondiff.diffByKey(
					[
						{"oid":48539,"crop_string":"","field_id":"2 Block 1","water_type":2,"field_acres":18.11,"member_id":1988,"gsaid":"GKGSA","landiq_crops":"Olives"},
						{"oid":48382,"crop_string":"","field_id":"2 Block 2","water_type":2,"field_acres":19.08,"member_id":1988,"gsaid":"EKGSA","landiq_crops":"Olives"}
					],
					[
						{"oid":48239,"crop_string":"apple","field_id":"2 Block 1","water_type":2,"field_acres":18.11,"member_id":1988,"gsaid":"EKGSA","landiq_crops":"Citrus"},
						{"oid":48539,"crop_string":"apple","field_id":"2 Block 1","water_type":2,"field_acres":18.11,"member_id":1988,"gsaid":"EKGSA","landiq_crops":"Citrus"}
					],
					['oid','member_id']
				);
				debug(serializeJson(diff));
				var expected = {"remove":[{"data":{"oid":48382,"crop_string":"","field_id":"2 Block 2","water_type":2,"gsaid":"EKGSA","member_id":1988,"field_acres":19.08,"landiq_crops":"Olives"},"key":[48382,1988]}],"update":[{"data":{"oid":48539,"crop_string":"apple","field_id":"2 Block 1","water_type":2,"gsaid":"EKGSA","member_id":1988,"field_acres":18.11,"landiq_crops":"Citrus"},"changes":[{"path":["crop_string"],"key":"crop_string","old":"","new":"apple"},{"path":["gsaid"],"key":"gsaid","old":"GKGSA","new":"EKGSA"},{"path":["landiq_crops"],"key":"landiq_crops","old":"Olives","new":"Citrus"}],"orig":{"oid":48539,"crop_string":"","field_id":"2 Block 1","water_type":2,"gsaid":"GKGSA","member_id":1988,"field_acres":18.11,"landiq_crops":"Olives"},"key":[48539,1988]}],"add":[{"data":{"oid":48239,"crop_string":"apple","field_id":"2 Block 1","water_type":2,"gsaid":"EKGSA","member_id":1988,"field_acres":18.11,"landiq_crops":"Citrus"},"key":[48239,1988]}]};
				expect(diff).toBe(expected);
			});
		})
	}

}
