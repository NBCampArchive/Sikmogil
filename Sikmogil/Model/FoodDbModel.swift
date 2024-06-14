//
//  FoodDbInfoModel.swift
//  Sikmogil
//
//  Created by 희라 on 6/13/24.
//  [Model] **설명** 식단 식품영양성분DB정보 API 모델

import Foundation

struct Response: Codable {
    let body: Body

    struct Body: Codable {
        let pageNo: Int
        let totalCount: Int
        let numOfRows: Int
        let items: [FoodItem]

        enum CodingKeys: String, CodingKey {
            case pageNo, totalCount, numOfRows, items
        }
    }
}

struct FoodItem: Codable {
    let num: String // 번호
    let foodCd: String // 식품코드
    let foodNmKr: String // 식품명 (사용하는 변수 🌝)
    let dbGrpCm: String // 데이터구분코드
    let dbGrpNm: String? // 데이터구분명 (옵셔널)
    let foodOrCd: String // 식품기원코드
    let foodOrNm: String? // 식품기원명 (옵셔널)
    let foodCat1Cd: String // 식품대분류코드
    let foodCat1Nm: String? // 식품대분류명 (옵셔널)
    let foodCat2Cd: String? // 식품중분류코드 (옵셔널)
    let foodCat2Nm: String? // 식품중분류명 (옵셔널)
    let foodCat3Cd: String? // 식품소분류코드 (옵셔널)
    let foodCat3Nm: String? // 식품소분류명 (옵셔널)
    let foodCat4Cd: String? // 식품세분류코드 (옵셔널)
    let foodCat4Nm: String? // 식품세분류명 (옵셔널)
    let servingSize: String // 영양성분함량기준량 (사용하는 변수 🌝)
    let amtNum1: String // 에너지(kcal) (사용하는 변수 🌝)
    let amtNum2: String? // 수분(g) (옵셔널)
    let amtNum3: String? // 단백질(g) (옵셔널)
    let amtNum4: String? // 지방(g) (옵셔널)
    let amtNum5: String? // 회분(g) (옵셔널)
    let amtNum6: String? // 탄수화물(g) (옵셔널)
    let amtNum7: String? // 당류(g) (옵셔널)
    let amtNum8: String? // 식이섬유(g) (옵셔널)
    let amtNum9: String? // 칼슘(mg) (옵셔널)
    let amtNum10: String? // 철(mg) (옵셔널)
    let amtNum11: String? // 인(mg) (옵셔널)
    let amtNum12: String? // 칼륨(mg) (옵셔널)
    let amtNum13: String? // 나트륨(mg) (옵셔널)
    let amtNum14: String? // 비타민 A(μg RAE) (옵셔널)
    let amtNum15: String? // 레티놀(μg) (옵셔널)
    let amtNum16: String? // 베타카로틴(μg) (옵셔널)
    let amtNum17: String? // 티아민(mg) (옵셔널)
    let amtNum18: String? // 리보플라빈(mg) (옵셔널)
    let amtNum19: String? // 니아신(mg) (옵셔널)
    let amtNum20: String? // 비타민 C(mg) (옵셔널)
    let amtNum21: String? // 비타민 D(μg) (옵셔널)
    let amtNum22: String? // 콜레스테롤(mg) (옵셔널)
    let amtNum23: String? // 포화지방산(g) (옵셔널)
    let amtNum24: String? // 트랜스지방산(g) (옵셔널)
    let subRefCm: String // 출처코드
    let subRefName: String // 출처명
    let nutriAmountServing: String? // 1회 섭취참고량 (옵셔널)
    let z10500: String? // 식품중량 (옵셔널)
    let itemReportNo: String? // 품목제조보고번호 (옵셔널)
    let makerNm: String? // 업체명 (옵셔널)
    let impManufacNm: String? // 수입업체명 (옵셔널)
    let sellerManufacNm: String? // 유통업체명 (옵셔널)
    let impYn: String? // 수입여부 (옵셔널)
    let nationCm: String? // 원산지국코드 (옵셔널)
    let nationNm: String? // 원산지국명 (옵셔널)
    let crtMthCd: String // 데이터생성방법코드
    let crtMthNm: String // 데이터생성방법명
    let researchYmd: String? // 데이터생성일자 (옵셔널)
    let updateYmd: String? // 데이터기준일자 (옵셔널)

    enum CodingKeys: String, CodingKey {
        case num = "NUM"
        case foodCd = "FOOD_CD"
        case foodNmKr = "FOOD_NM_KR "
        case dbGrpCm = "DB_GRP_CM"
        case dbGrpNm = "DB_GRP_NM"
        case foodOrCd = "FOOD_OR_CD"
        case foodOrNm = "FOOD_OR_NM"
        case foodCat1Cd = "FOOD_CAT1_CD"
        case foodCat1Nm = "FOOD_CAT1_NM"
        case foodCat2Cd = "FOOD_CAT2_CD"
        case foodCat2Nm = "FOOD_CAT2_NM"
        case foodCat3Cd = "FOOD_CAT3_CD"
        case foodCat3Nm = "FOOD_CAT3_NM"
        case foodCat4Cd = "FOOD_CAT4_CD"
        case foodCat4Nm = "FOOD_CAT4_NM"
        case servingSize = "SERVING_SIZE "
        case amtNum1 = "AMT_NUM1 "
        case amtNum2 = "AMT_NUM2"
        case amtNum3 = "AMT_NUM3"
        case amtNum4 = "AMT_NUM4"
        case amtNum5 = "AMT_NUM5"
        case amtNum6 = "AMT_NUM6"
        case amtNum7 = "AMT_NUM7"
        case amtNum8 = "AMT_NUM8"
        case amtNum9 = "AMT_NUM9"
        case amtNum10 = "AMT_NUM10"
        case amtNum11 = "AMT_NUM11"
        case amtNum12 = "AMT_NUM12"
        case amtNum13 = "AMT_NUM13"
        case amtNum14 = "AMT_NUM14"
        case amtNum15 = "AMT_NUM15"
        case amtNum16 = "AMT_NUM16"
        case amtNum17 = "AMT_NUM17"
        case amtNum18 = "AMT_NUM18"
        case amtNum19 = "AMT_NUM19"
        case amtNum20 = "AMT_NUM20"
        case amtNum21 = "AMT_NUM21"
        case amtNum22 = "AMT_NUM22"
        case amtNum23 = "AMT_NUM23"
        case amtNum24 = "AMT_NUM24"
        case subRefCm = "SUB_REF_CM"
        case subRefName = "SUB_REF_NAME"
        case nutriAmountServing = "NUTRI_AMOUNT_SERVING"
        case z10500 = "Z10500"
        case itemReportNo = "ITEM_REPORT_NO"
        case makerNm = "MAKER_NM"
        case impManufacNm = "IMP_MANUFAC_NM"
        case sellerManufacNm = "SELLER_MANUFAC_NM"
        case impYn = "IMP_YN"
        case nationCm = "NATION_CM"
        case nationNm = "NATION_NM"
        case crtMthCd = "CRT_MTH_CD"
        case crtMthNm = "CRT_MTH_NM"
        case researchYmd = "RESEARCH_YMD"
        case updateYmd = "UPDATE_YMD"
    }
}
