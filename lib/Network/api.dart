class Api {

  static const apiVersion = "macroapis/BpIntel_1_6/";

  static const licenseApi =
      // "https://cstore.catalist-me.com/${apiVersion}getAgencyLicense"
      "https://cstore.catalist-me.com/macroapis/BpIntel/getAgencyLicense";

  // static const LOGIN_API =
  // "https://binzagrdev.catalist-me.com/${apiVersion}loginUser";

  static const LOGIN_API = "${apiVersion}loginUser";

  ///Dashboard Api End Point
  static const USER_DASHBOARD_API = "${apiVersion}getUserDashbaord";

  // static const GETJOURNEYPLAN =
  //     "https://binzagrdev.catalist-me.com/${apiVersion}getJourneyPlan";

  static const GETJOURNEYPLAN = "${apiVersion}getJourneyPlan";

  // static const DROPVISIT =
  //     "https://binzagrdev.catalist-me.com/${apiVersion}dropVisit";

  static const DROPVISIT = "${apiVersion}dropVisit";

  static const UNDROPVISIT = "${apiVersion}unDropVisit";

  // static const STARTVISIT =
  //     "https://binzagrdev.catalist-me.com/${apiVersion}startVisit";

  static const STARTVISIT = "${apiVersion}startVisit";

  static const finishVisit = "${apiVersion}finishVisit";

  // static const SYNCRONISEVISIT =
  //     "https://binzagrdev.catalist-me.com/${apiVersion}syncronise";

  static const SYNCRONISEVISIT = "${apiVersion}synchronize";

  static const sqlOtherPhotoTableSaving = "${apiVersion}saveCapturePhotos";

  static const sqlPlanogramTableSaving = "${apiVersion}savePlanogram";

  static const sqlSosTableSaving = "${apiVersion}saveSos";

  static const sqlOsdcTableSaving = "${apiVersion}saveOSD";

  static const sqlAvailabilityTableSaving = "${apiVersion}saveAvailability";

  static const sqlPickListTableSaving = "${apiVersion}savePicklist";

  static const sqlPlanoguideSaving = "${apiVersion}savePlanoguide";

  static const sqlBrandShareSaving = "${apiVersion}savebrandShares";

  static const getStockerPickList = "${apiVersion}getStockerPickList";

  static const getTmrActualPickList = "${apiVersion}getTmrActualPickList";

  static const makePickListReady = "${apiVersion}makePickListReady";

  static const uploadRtvData = "${apiVersion}saveRTV";

  static const uploadPricingData = "${apiVersion}savePricing";

  static const getPromoPlanData = "${apiVersion}getPromoPlan";

  static const postPromoPlanData = "${apiVersion}savePromoPlan";

  static const postFreshnessData = "${apiVersion}saveFreshness";

  static const postStockData = "${apiVersion}saveStock";

  static const postOSDData = "${apiVersion}saveOSD";

  static const postOnePlusOneData = "${apiVersion}saveOnePlusOne";

  static const postPosData = "${apiVersion}saveProofOfSales";

  static const postMarketIssueData = "${apiVersion}saveMarketIssues";

  static const postReplenishData = "${apiVersion}saveReplenish";

}
