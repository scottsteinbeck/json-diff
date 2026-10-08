/**
* Tests for isSame
*/
component extends="testbox.system.BaseSpec"{

	function beforeAll(){
		jsondiff = new models.jsondiff();
	}

	function run(){
		describe("Test isSame", ()=>{
			it("matches equal structs, arrays, and numbers", ()=>{
				var scaled = createObject("java", "java.math.BigDecimal").init("18.110");
				expect(jsondiff.isSame({ "a": 1 }, { "a": 1 })).toBeTrue();
				expect(jsondiff.isSame([1, "a"], [1, "a"])).toBeTrue();
				expect(jsondiff.isSame(1, 1.0)).toBeTrue();
				expect(jsondiff.isSame(18.11, scaled)).toBeTrue();
			});

			it("rejects different values", ()=>{
				expect(jsondiff.isSame({ "a": 1 }, { "a": 2 })).toBeFalse();
				expect(jsondiff.isSame({ "a": 1 }, { "a": 1, "b": 2 })).toBeFalse();
				expect(jsondiff.isSame([1], [1, 2])).toBeFalse();
				expect(jsondiff.isSame([1, 2], [2, 1])).toBeFalse();
				expect(jsondiff.isSame({ "a": 1 }, [1])).toBeFalse();
			});

			it("treats nulls as equal only to each other", ()=>{
				expect(jsondiff.isSame(javacast("null", ""), javacast("null", ""))).toBeTrue();
				expect(jsondiff.isSame(javacast("null", ""), 1)).toBeFalse();
			});
		});
	}

}
