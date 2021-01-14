import Foundation

// https://gist.github.com/mxcl/c7cf26ca4e19f37cafcece9f5fc3a777

public struct AppleReceiptValidationResponse: Decodable {
    let status: Int
    let environment: String
    struct Receipt: Decodable {
        let receipt_type: String
        let adam_id: Int
        let app_item_id: Int
        let bundle_id: String
        let application_version: String
        let download_id: Int
        let version_external_identifier: Int
        let receipt_creation_date_ms: Date
        let request_date_ms: Date
        let original_purchase_date_ms: Date
        let original_application_version: String
        struct InApp: Decodable {
            let is_trial_period: String
            let original_purchase_date_ms: Date
            let original_transaction_id: String
            let product_id: String
            let purchase_date_ms: Date
            let quantity: String
            let transaction_id: String
        }
        let in_app: [InApp]
    }
    let receipt: Receipt
    struct LatestReceiptInfo: Decodable {
      let is_trial_period: String
      let original_purchase_date_ms: Date
      let original_transaction_id: String
      let product_id: String
      let purchase_date_ms: Date
      let quantity: String
      let transaction_id: String
    }
    let latest_receipt_info: [LatestReceiptInfo]
    let latest_receipt: String

}
