/**
 * Copyright IBM Corporation 2019
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

import Foundation

/**
 Object containing details of the stored credentials.
 Obtain credentials for your source from the administrator of the source.
 */
public struct CredentialDetails: Codable, Equatable {

    /**
     The authentication method for this credentials definition. The  **credential_type** specified must be supported by
     the **source_type**. The following combinations are possible:
     -  `"source_type": "box"` - valid `credential_type`s: `oauth2`
     -  `"source_type": "salesforce"` - valid `credential_type`s: `username_password`
     -  `"source_type": "sharepoint"` - valid `credential_type`s: `saml` with **source_version** of `online`, or
     `ntml_v1` with **source_version** of `2016`
     -  `"source_type": "web_crawl"` - valid `credential_type`s: `noauth` or `basic`
     -  "source_type": "cloud_object_storage"` - valid `credential_type`s: `aws4_hmac`.
     */
    public enum CredentialType: String {
        case oauth2 = "oauth2"
        case saml = "saml"
        case usernamePassword = "username_password"
        case noauth = "noauth"
        case basic = "basic"
        case ntmlV1 = "ntml_v1"
        case aws4Hmac = "aws4_hmac"
    }

    /**
     The type of Sharepoint repository to connect to. Only valid, and required, with a **source_type** of `sharepoint`.
     */
    public enum SourceVersion: String {
        case online = "online"
    }

    /**
     The authentication method for this credentials definition. The  **credential_type** specified must be supported by
     the **source_type**. The following combinations are possible:
     -  `"source_type": "box"` - valid `credential_type`s: `oauth2`
     -  `"source_type": "salesforce"` - valid `credential_type`s: `username_password`
     -  `"source_type": "sharepoint"` - valid `credential_type`s: `saml` with **source_version** of `online`, or
     `ntml_v1` with **source_version** of `2016`
     -  `"source_type": "web_crawl"` - valid `credential_type`s: `noauth` or `basic`
     -  "source_type": "cloud_object_storage"` - valid `credential_type`s: `aws4_hmac`.
     */
    public var credentialType: String?

    /**
     The **client_id** of the source that these credentials connect to. Only valid, and required, with a
     **credential_type** of `oauth2`.
     */
    public var clientID: String?

    /**
     The **enterprise_id** of the Box site that these credentials connect to. Only valid, and required, with a
     **source_type** of `box`.
     */
    public var enterpriseID: String?

    /**
     The **url** of the source that these credentials connect to. Only valid, and required, with a **credential_type**
     of `username_password`, `noauth`, and `basic`.
     */
    public var url: String?

    /**
     The **username** of the source that these credentials connect to. Only valid, and required, with a
     **credential_type** of `saml`, `username_password`, `basic`, or `ntml_v1`.
     */
    public var username: String?

    /**
     The **organization_url** of the source that these credentials connect to. Only valid, and required, with a
     **credential_type** of `saml`.
     */
    public var organizationURL: String?

    /**
     The **site_collection.path** of the source that these credentials connect to. Only valid, and required, with a
     **source_type** of `sharepoint`.
     */
    public var siteCollectionPath: String?

    /**
     The **client_secret** of the source that these credentials connect to. Only valid, and required, with a
     **credential_type** of `oauth2`. This value is never returned and is only used when creating or modifying
     **credentials**.
     */
    public var clientSecret: String?

    /**
     The **public_key_id** of the source that these credentials connect to. Only valid, and required, with a
     **credential_type** of `oauth2`. This value is never returned and is only used when creating or modifying
     **credentials**.
     */
    public var publicKeyID: String?

    /**
     The **private_key** of the source that these credentials connect to. Only valid, and required, with a
     **credential_type** of `oauth2`. This value is never returned and is only used when creating or modifying
     **credentials**.
     */
    public var privateKey: String?

    /**
     The **passphrase** of the source that these credentials connect to. Only valid, and required, with a
     **credential_type** of `oauth2`. This value is never returned and is only used when creating or modifying
     **credentials**.
     */
    public var passphrase: String?

    /**
     The **password** of the source that these credentials connect to. Only valid, and required, with
     **credential_type**s of `saml`, `username_password`, `basic`, or `ntml_v1`.
     **Note:** When used with a **source_type** of `salesforce`, the password consists of the Salesforce password and a
     valid Salesforce security token concatenated. This value is never returned and is only used when creating or
     modifying **credentials**.
     */
    public var password: String?

    /**
     The ID of the **gateway** to be connected through (when connecting to intranet sites). Only valid with a
     **credential_type** of `noauth`, `basic`, or `ntml_v1`. Gateways are created using the
     `/v1/environments/{environment_id}/gateways` methods.
     */
    public var gatewayID: String?

    /**
     The type of Sharepoint repository to connect to. Only valid, and required, with a **source_type** of `sharepoint`.
     */
    public var sourceVersion: String?

    /**
     SharePoint OnPrem WebApplication URL. Only valid, and required, with a **source_version** of `2016`.
     */
    public var webApplicationURL: String?

    /**
     The domain used to log in to your OnPrem SharePoint account. Only valid, and required, with a **source_version** of
     `2016`.
     */
    public var domain: String?

    /**
     The endpoint associated with the cloud object store that your are connecting to. Only valid, and required, with a
     **credential_type** of `aws4_hmac`.
     */
    public var endpoint: String?

    /**
     The access key ID associated with the cloud object store. Only valid, and required, with a **credential_type** of
     `aws4_hmac`. For more infomation, see the [cloud object store
     documentation](https://cloud.ibm.com/docs/services/cloud-object-storage?topic=cloud-object-storage-using-hmac-credentials#using-hmac-credentials).
     */
    public var accessKeyID: String?

    /**
     The secret access key associated with the cloud object store. Only valid, and required, with a **credential_type**
     of `aws4_hmac`. This value is never returned and is only used when creating or modifying **credentials**. For more
     infomation, see the [cloud object store
     documentation](https://cloud.ibm.com/docs/services/cloud-object-storage?topic=cloud-object-storage-using-hmac-credentials#using-hmac-credentials).
     */
    public var secretAccessKey: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case credentialType = "credential_type"
        case clientID = "client_id"
        case enterpriseID = "enterprise_id"
        case url = "url"
        case username = "username"
        case organizationURL = "organization_url"
        case siteCollectionPath = "site_collection.path"
        case clientSecret = "client_secret"
        case publicKeyID = "public_key_id"
        case privateKey = "private_key"
        case passphrase = "passphrase"
        case password = "password"
        case gatewayID = "gateway_id"
        case sourceVersion = "source_version"
        case webApplicationURL = "web_application_url"
        case domain = "domain"
        case endpoint = "endpoint"
        case accessKeyID = "access_key_id"
        case secretAccessKey = "secret_access_key"
    }

    /**
     Initialize a `CredentialDetails` with member variables.

     - parameter credentialType: The authentication method for this credentials definition. The  **credential_type**
       specified must be supported by the **source_type**. The following combinations are possible:
       -  `"source_type": "box"` - valid `credential_type`s: `oauth2`
       -  `"source_type": "salesforce"` - valid `credential_type`s: `username_password`
       -  `"source_type": "sharepoint"` - valid `credential_type`s: `saml` with **source_version** of `online`, or
       `ntml_v1` with **source_version** of `2016`
       -  `"source_type": "web_crawl"` - valid `credential_type`s: `noauth` or `basic`
       -  "source_type": "cloud_object_storage"` - valid `credential_type`s: `aws4_hmac`.
     - parameter clientID: The **client_id** of the source that these credentials connect to. Only valid, and
       required, with a **credential_type** of `oauth2`.
     - parameter enterpriseID: The **enterprise_id** of the Box site that these credentials connect to. Only valid,
       and required, with a **source_type** of `box`.
     - parameter url: The **url** of the source that these credentials connect to. Only valid, and required, with a
       **credential_type** of `username_password`, `noauth`, and `basic`.
     - parameter username: The **username** of the source that these credentials connect to. Only valid, and
       required, with a **credential_type** of `saml`, `username_password`, `basic`, or `ntml_v1`.
     - parameter organizationURL: The **organization_url** of the source that these credentials connect to. Only
       valid, and required, with a **credential_type** of `saml`.
     - parameter siteCollectionPath: The **site_collection.path** of the source that these credentials connect to.
       Only valid, and required, with a **source_type** of `sharepoint`.
     - parameter clientSecret: The **client_secret** of the source that these credentials connect to. Only valid, and
       required, with a **credential_type** of `oauth2`. This value is never returned and is only used when creating or
       modifying **credentials**.
     - parameter publicKeyID: The **public_key_id** of the source that these credentials connect to. Only valid, and
       required, with a **credential_type** of `oauth2`. This value is never returned and is only used when creating or
       modifying **credentials**.
     - parameter privateKey: The **private_key** of the source that these credentials connect to. Only valid, and
       required, with a **credential_type** of `oauth2`. This value is never returned and is only used when creating or
       modifying **credentials**.
     - parameter passphrase: The **passphrase** of the source that these credentials connect to. Only valid, and
       required, with a **credential_type** of `oauth2`. This value is never returned and is only used when creating or
       modifying **credentials**.
     - parameter password: The **password** of the source that these credentials connect to. Only valid, and
       required, with **credential_type**s of `saml`, `username_password`, `basic`, or `ntml_v1`.
       **Note:** When used with a **source_type** of `salesforce`, the password consists of the Salesforce password and
       a valid Salesforce security token concatenated. This value is never returned and is only used when creating or
       modifying **credentials**.
     - parameter gatewayID: The ID of the **gateway** to be connected through (when connecting to intranet sites).
       Only valid with a **credential_type** of `noauth`, `basic`, or `ntml_v1`. Gateways are created using the
       `/v1/environments/{environment_id}/gateways` methods.
     - parameter sourceVersion: The type of Sharepoint repository to connect to. Only valid, and required, with a
       **source_type** of `sharepoint`.
     - parameter webApplicationURL: SharePoint OnPrem WebApplication URL. Only valid, and required, with a
       **source_version** of `2016`.
     - parameter domain: The domain used to log in to your OnPrem SharePoint account. Only valid, and required, with
       a **source_version** of `2016`.
     - parameter endpoint: The endpoint associated with the cloud object store that your are connecting to. Only
       valid, and required, with a **credential_type** of `aws4_hmac`.
     - parameter accessKeyID: The access key ID associated with the cloud object store. Only valid, and required,
       with a **credential_type** of `aws4_hmac`. For more infomation, see the [cloud object store
       documentation](https://cloud.ibm.com/docs/services/cloud-object-storage?topic=cloud-object-storage-using-hmac-credentials#using-hmac-credentials).
     - parameter secretAccessKey: The secret access key associated with the cloud object store. Only valid, and
       required, with a **credential_type** of `aws4_hmac`. This value is never returned and is only used when creating
       or modifying **credentials**. For more infomation, see the [cloud object store
       documentation](https://cloud.ibm.com/docs/services/cloud-object-storage?topic=cloud-object-storage-using-hmac-credentials#using-hmac-credentials).

     - returns: An initialized `CredentialDetails`.
    */
    public init(
        credentialType: String? = nil,
        clientID: String? = nil,
        enterpriseID: String? = nil,
        url: String? = nil,
        username: String? = nil,
        organizationURL: String? = nil,
        siteCollectionPath: String? = nil,
        clientSecret: String? = nil,
        publicKeyID: String? = nil,
        privateKey: String? = nil,
        passphrase: String? = nil,
        password: String? = nil,
        gatewayID: String? = nil,
        sourceVersion: String? = nil,
        webApplicationURL: String? = nil,
        domain: String? = nil,
        endpoint: String? = nil,
        accessKeyID: String? = nil,
        secretAccessKey: String? = nil
    )
    {
        self.credentialType = credentialType
        self.clientID = clientID
        self.enterpriseID = enterpriseID
        self.url = url
        self.username = username
        self.organizationURL = organizationURL
        self.siteCollectionPath = siteCollectionPath
        self.clientSecret = clientSecret
        self.publicKeyID = publicKeyID
        self.privateKey = privateKey
        self.passphrase = passphrase
        self.password = password
        self.gatewayID = gatewayID
        self.sourceVersion = sourceVersion
        self.webApplicationURL = webApplicationURL
        self.domain = domain
        self.endpoint = endpoint
        self.accessKeyID = accessKeyID
        self.secretAccessKey = secretAccessKey
    }

}
