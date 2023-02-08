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
				dump(jsondiff.diffByKey(
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
					'oid'));
				expect(
					jsondiff.diffByKey(
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
				)).toBe(
					{
						"remove":[{"data":{"oid":48280,"crop_string":"apple","field_id":"2 Block 1","water_type":2,"gsaid":"EKGSA","member_id":1988,"field_acres":18.11,"landiq_crops":"Citrus"},"key":[48280,1988]}],"update":[{"data":{"oid":48380,"crop_string":"","field_id":"Block 4","water_type":2,"gsaid":"GKGSA","member_id":1988,"field_acres":2.45,"landiq_crops":"Citrus"},
						"changes":[{"path":["gsaid"],"key":"gsaid","old":"EKGSA","new":"GKGSA"}],"orig":{"oid":48380,"crop_string":"","field_id":"Block 4","water_type":2,"gsaid":"EKGSA","member_id":1988,"field_acres":2.45,"landiq_crops":"Citrus"},"key":[48380,1988]},{"data":{"oid":48382,"crop_string":"items","field_id":"2 Block s2","water_type":2,"gsaid":"GKGSA","member_id":1988,"field_acres":19.08,"landiq_crops":"Olives"},"changes":[{"path":["crop_string"],"key":"crop_string","old":"","new":"items"},{"path":["field_id"],"key":"field_id","old":"2 Block 2","new":"2 Block s2"},{"path":["gsaid"],"key":"gsaid","old":"EKGSA","new":"GKGSA"}],"orig":{"oid":48382,"crop_string":"","field_id":"2 Block 2","water_type":2,"gsaid":"EKGSA","member_id":1988,"field_acres":19.08,"landiq_crops":"Olives"},"key":[48382,1988]},{"data":{"oid":48378,"crop_string":"","field_id":"Block 2","water_type":2,"gsaid":"GKGSA","member_id":1988,"field_acres":11.02,"landiq_crops":"Citrus"},"changes":[{"path":["gsaid"],"key":"gsaid","old":"EKGSA","new":"GKGSA"}],"orig":{"oid":48378,"crop_string":"","field_id":"Block 2","water_type":2,"gsaid":"EKGSA","member_id":1988,"field_acres":11.02,"landiq_crops":"Citrus"},"key":[48378,1988]},{"data":{"oid":48379,"crop_string":"","field_id":"Block 3","water_type":2,"gsaid":"EKGSA","member_id":1988,"field_acres":8.38,"landiq_crops":"Olives"},"changes":[{"path":["landiq_crops"],"key":"landiq_crops","old":"Citrus","new":"Olives"}],"orig":{"oid":48379,"crop_string":"","field_id":"Block 3","water_type":2,"gsaid":"EKGSA","member_id":1988,"field_acres":8.38,"landiq_crops":"Citrus"},"key":[48379,1988]},
						{"data":{"oid":48381,"crop_string":"tops","field_id":"Block 15","water_type":2,"gsaid":"EKGSA","member_id":1988,"field_acres":12.2,"landiq_crops":"Citrus"},"changes":[{"path":["crop_string"],"key":"crop_string","old":"","new":"tops"},{"path":["field_id"],"key":"field_id","old":"Block 5","new":"Block 15"}],"orig":{"oid":48381,"crop_string":"","field_id":"Block 5","water_type":2,"gsaid":"EKGSA","member_id":1988,"field_acres":12.2,"landiq_crops":"Citrus"},"key":[48381,1988]},{"data":{"oid":48539,"crop_string":"apple","field_id":"2 Block 1","water_type":2,"gsaid":"EKGSA","member_id":1988,"field_acres":18.11,"landiq_crops":"Citrus"},"changes":[{"path":["crop_string"],"key":"crop_string","old":"","new":"apple"},{"path":["gsaid"],"key":"gsaid","old":"GKGSA","new":"EKGSA"},{"path":["landiq_crops"],"key":"landiq_crops","old":"Olives","new":"Citrus"}],"orig":{"oid":48539,"crop_string":"","field_id":"2 Block 1","water_type":2,"gsaid":"GKGSA","member_id":1988,"field_acres":18.11,"landiq_crops":"Olives"},"key":[48539,1988]}],
						"add":[{"data":{"oid":48239,"crop_string":"apple","field_id":"2 Block 1","water_type":2,"gsaid":"EKGSA","member_id":1988,"field_acres":18.11,"landiq_crops":"Citrus"},"key":[48239,1988]}]}

				);
			});
		})
	}

}
