//
//  Responses.swift
//  quicklook
//
//  Created by Toxicspu on 3/25/20.
//  Copyright © 2020 developer. All rights reserved.
//

//https://app.quicktype.io
//https://medium.com/swiftly-swift/swift-4-decodable-beyond-the-basics-990cc48b7375

import Foundation
import Combine



// MARK: GLOBAL VARIABLES
var printerArray:[Responses.PrinterClass] = []


struct Responses: Codable {
    
    //MARK: - JAMF TOKEN
    struct Token: Codable, Hashable {
        var token: String
        var expires: Int
    }
    
    
    //MARK: - BUILDINGS
    struct Buildings: Codable, Hashable {
        struct Response: Codable, Hashable {
            var id: Int
            var name: String
        }
        var buildings: [Response]
    }
    
    
    //MARK: - PACKAGES
    struct Packages: Codable, Hashable {
        struct Response: Codable, Hashable, Identifiable {
            var id = UUID()
            var jamfId: Int
            var name: String
            enum CodingKeys:String, CodingKey{
                case jamfId = "id"
                case name = "name"
            }
        }
        var packages: [Response]
    }
    
    
    //MARK: - SCRIPTS
    struct Scripts: Codable, Identifiable, Hashable{
        var id = UUID()
        var totalCount:Int
        var results:[Results]
        enum CodingKeys:String, CodingKey{
            case totalCount = "totalCount"
            case results = "results"
        }
        
        
        struct Results:Codable, Identifiable, Hashable {
            var id = UUID()
            var jamfId: Int
            var name: String
            var categoryId: Int
            var categoryName: String
            var info: String
            var notes: String
            var priority: String
            var scriptContents: String
            
            enum  CodingKeys:String, CodingKey{
                case jamfId = "id"
                case name = "name"
                case categoryId = "categoryId"
                case categoryName = "categoryName"
                case info = "info"
                case notes = "notes"
                case priority = "priority"
                case scriptContents = "scriptContents"
            }
        }
        
    }
    
    
    //MARK: - COMPUTERS
    struct Computers: Codable {
        struct Response: Codable, Identifiable {
            var id = UUID()
            var jamfId: Int
            var name: String?
            var username: String?
            var realname: String?
            var serial_number: String
            var mac_address: String
            var alt_mac_address: String?
            var asset_tag: String?
            var ip_address: String?
            var last_reported_ip: String?
            var location: Location?
            
            enum CodingKeys:String, CodingKey{
                case jamfId = "id"
                case name = "name"
                case username = "username"
                case realname = "realname"
                case serial_number = "serial_number"
                case mac_address = "mac_address"
                case alt_mac_address = "alt_mac_address"
                case asset_tag = "asset_tag"
                case ip_address = "ip_address"
                case last_reported_ip = "last_reported_ip"
                case location = "location"
                
            }
            
        }
        var computers: [Response]
        
    }
    
    
    
    // MARK: - User
    struct User: Codable {
        var username, passwordHistoryDepth, passwordMinLength, passwordMaxAge: String
        var passwordMinComplexCharacters, passwordRequireAlphanumeric: String
        
        enum CodingKeys: String, CodingKey {
            case username
            case passwordHistoryDepth
            case passwordMinLength
            case passwordMaxAge
            case passwordMinComplexCharacters
            case passwordRequireAlphanumeric
        }
    }
    
    //MARK: - POLICIES
    
    struct Policies: Codable, Hashable {
        
        struct Response: Codable, Hashable, Identifiable {
            var id = UUID()
            var jamfId: Int
            var name: String
            enum CodingKeys:String, CodingKey{
                case jamfId = "id"
                case name = "name"
            }
        }
        var policies: [Response]
    }
    
    
    struct PolicyCodable: Codable{
        let policy: Policy }
    
    struct Policy: Codable, Hashable, Identifiable {
        var id = UUID()
        let general: General?
        let scope: Scope?
        let package_configuration: PackageConfiguration?
        let scripts: [PolicyScripts]?
        let printers: [PrinterElement]?
        let files_processes: FilesProcesses?
        let printer:[PrinterClass]?
        
        enum CodingKeys: String, CodingKey {
            case general = "general"
            case scope = "scope"
            case package_configuration = "package_configuration"
            case scripts = "scripts"
            case printers = "printers"
            case files_processes = "files_processes"
            case printer
        }
    }
    
    
    
    struct General: Codable, Hashable, Identifiable {
        var id = UUID()
        let jamfId: Int?
        let name: String?
        let enabled: Bool?
        let trigger: String?
        let triggerCheckin, triggerEnrollmentComplete, triggerLogin, triggerLogout: Bool?
        let triggerNetworkStateChanged, triggerStartup: Bool?
        let triggerOther, frequency: String?
        let locationUserOnly: Bool?
        let targetDrive: String?
        let offline: Bool?
        let category: Category?
        let dateTimeLimitations: DateTimeLimitations?
        let networkLimitations: NetworkLimitations?
        let overrideDefaultSettings: OverrideDefaultSettings?
        let networkRequirements: String?
        let site: Category?
        let mac_address: String?
        let ip_address: String?
        let payloads: String?
        
        enum CodingKeys: String, CodingKey {
            case jamfId = "id"
            case name = "name"
            case enabled = "enabled"
            case trigger = "trigger"
            case triggerCheckin = "trigger_checkin"
            case triggerEnrollmentComplete = "trigger_enrollment_complete"
            case triggerLogin = "trigger_login"
            case triggerLogout = "trigger_logout"
            case triggerNetworkStateChanged = "trigger_network_state_changed"
            case triggerStartup = "trigger_startup"
            case triggerOther = "trigger_other"
            case frequency = "frequency"
            case locationUserOnly = "location_user_only"
            case targetDrive = "target_drive"
            case offline = "offline"
            case category = "category"
            case dateTimeLimitations = "date_time_limitations"
            case networkLimitations = "network_limitations"
            case overrideDefaultSettings = "override_default_settings"
            case networkRequirements = "network_requirements"
            case site = "site"
            case mac_address = "mac_address"
            case ip_address = "ip_address"
            case payloads = "payloads"
        }
        
    }
    
    // MARK: - Category
    struct Category: Codable, Hashable, Identifiable  {
        let id = UUID()
        var jamfId: Int
        var name: String
        
        enum CodingKeys: String, CodingKey {
            case jamfId = "id"
            case name = "name"
        }
    }
    
    
    // MARK: - DateTimeLimitations
    struct DateTimeLimitations: Codable, Hashable, Identifiable {
        let id = UUID()
        let activationDate: String
        let activationDateEpoch: Int
        let activationDateUTC, expirationDate: String
        let expirationDateEpoch: Int
        let expirationDateUTC: String
        //let noExecuteOn:[SelfServiceIcon]
        let noExecuteStart, noExecuteEnd: String
        
        enum CodingKeys: String, CodingKey {
            case activationDate = "activation_date"
            case activationDateEpoch = "activation_date_epoch"
            case activationDateUTC = "activation_date_utc"
            case expirationDate = "expiration_date"
            case expirationDateEpoch = "expiration_date_epoch"
            case expirationDateUTC = "expiration_date_utc"
            // case noExecuteOn = "no_execute_on"
            case noExecuteStart = "no_execute_start"
            case noExecuteEnd = "no_execute_end"
        }
    }
    
    // MARK: - SelfServiceIcon
    struct SelfServiceIcon: Codable, Hashable, Identifiable {
        var id = UUID()
    }
    
    // MARK: - NetworkLimitations
    struct NetworkLimitations: Codable, Hashable, Identifiable {
        var id = UUID()
        let minimumNetworkConnection: String
        let anyIPAddress: Bool
        let networkSegments: [GenericItem]?
        
        enum CodingKeys: String, CodingKey {
            case minimumNetworkConnection = "minimum_network_connection"
            case anyIPAddress = "any_ip_address"
            case networkSegments = "network_segments"
        }
    }
    
    // MARK: - OverrideDefaultSettings
    struct OverrideDefaultSettings: Codable, Hashable, Identifiable {
        var id = UUID()
        let targetDrive, distributionPoint: String
        let forceAFPSMB: Bool
        let sus, netbootServer: String
        
        enum CodingKeys: String, CodingKey {
            case targetDrive = "target_drive"
            case distributionPoint = "distribution_point"
            case forceAFPSMB = "force_afp_smb"
            case sus = "sus"
            case netbootServer = "netboot_server"
            
        }
    }
    
    
    // MARK: - Maintenance
    struct Maintenance: Codable, Hashable, Identifiable {
        var id = UUID()
        let recon, resetName, installAllCachedPackages, heal: Bool?
        let prebindings, permissions, byhost, systemCache: Bool?
        let userCache, verify: Bool?
        
        enum CodingKeys: String, CodingKey {
            case recon = "recon"
            case resetName = "reset_name"
            case installAllCachedPackages = "install_all_cached_packages"
            case heal = "heal"
            case prebindings = "prebindings"
            case permissions = "permissions"
            case byhost = "byhost"
            case systemCache = "system_cache"
            case userCache = "user_cache"
            case verify = "verify"
        }
    }
    
    // MARK: - PackageConfiguration
    struct PackageConfiguration: Codable, Hashable, Identifiable  {
        var id = UUID()
        let packages: [Package]
        enum CodingKeys: String, CodingKey {
            case packages = "packages"
        }
    }
    
    struct Package: Codable, Hashable, Identifiable {
        var id = UUID()
        let jamfId: Int?
        let name, udid: String?
        enum CodingKeys: String, CodingKey {
            case jamfId = "id"
            case name = "name"
            case udid = "udid"
        }
    }
    
    //MARK: - PRINTER
    struct Printers: Codable, Hashable, Identifiable {
        var id = UUID()
        var any: String?
        var printer: Result?
        struct Result: Codable, Hashable, Identifiable {
            var id = UUID()
            var jamfId: Int?
            var name: String?
            var makeDefault: Bool?
            
            enum CodingKeys: String, CodingKey {
                case jamfId = "id"
                case name = "name"
                case makeDefault = "makeDefault"
            }
        }
        
    }
    
    
    // MARK: - PolicyScripts
    struct PolicyScripts: Codable, Hashable, Identifiable {
        var id = UUID()
        var jamfId: Int?
        var name: String?
        var priority: String?
        enum CodingKeys: String, CodingKey {
            case jamfId = "id"
            case name = "name"
            case priority = "priority"
        }
    }
    
    //MARK: - FileProcesses
    
    struct FilesProcesses:Codable, Hashable, Identifiable {
        var id = UUID()
        var run_command:String?
        enum CodingKeys: String, CodingKey {
            case run_command = "run_command"
        }
    }
    
    // MARK: - Reboot
    struct Reboot: Codable, Hashable, Identifiable  {
        var id = UUID()
        let message, startupDisk, specifyStartup, noUserLoggedIn: String?
        let userLoggedIn: String?
        let minutesUntilReboot: Int?
        let startRebootTimerImmediately, fileVault2_Reboot: Bool?
        
        enum CodingKeys: String, CodingKey {
            case message = "message"
            case startupDisk = "startup_disk"
            case specifyStartup = "specify_startup"
            case noUserLoggedIn = "no_user_logged_in"
            case userLoggedIn = "user_logged_in"
            case minutesUntilReboot = "minutes_until_reboot"
            case startRebootTimerImmediately = "start_reboot_timer_immediately"
            case fileVault2_Reboot = "file_vault2_reboot"
        }
    }
    
    // MARK: - Scope
    struct Scope: Codable, Hashable, Identifiable  {
        var id = UUID()
        let allComputers: Bool?
        let all_mobile_devices: Bool?
        let all_jss_users:Bool?
        let mobile_device_groups: [ComputerGroups]?
        let jss_users:[GenericItem]?
        //  let jss_user_groups:[GenericItem]?
        let computers: [Computer]?
        let mobile_devices: [GenericItem]?
        let computerGroups: [ComputerGroups]?
        let buildings: [Building]?
        let departments: [Departments]?
        let limitToUsers: LimitToUsers?
        let limitations: Limitations?
        let exclusions: Exclusions?
        
        enum CodingKeys: String, CodingKey {
            case allComputers = "all_computers"
            case all_mobile_devices = "all_mobile_devices"
            case all_jss_users = "all_jss_users"
            case mobile_device_groups = "mobile_device_groups"
            case jss_users = "jss_users"
            //   case jss_user_groups = "jss_user_groups"
            case computers = "computers"
            case mobile_devices = "mobile_devices"
            case computerGroups = "computer_groups"
            case buildings = "buildings"
            case departments = "departments"
            case limitToUsers = "limit_to_users"
            case limitations = "limitations"
            case exclusions = "exclusions"
        }
    }
    
    // MARK: - Computer
    struct Computer: Codable, Hashable, Identifiable {
        var id = UUID()
        let jamfId: Int?
        let name, udid: String?
        let computer: ComputerDetail?
        
        enum CodingKeys: String, CodingKey {
            case jamfId = "id"
            case name = "name"
            case udid = "udid"
            case computer = "computer"
        }
    }
    
    struct ComputerDetail: Codable, Hashable, Identifiable {
        var id = UUID()
        let general: GeneralComputer
        enum CodingKeys: String, CodingKey {
            case general = "general"
        }
        
        
        struct GeneralComputer: Codable, Hashable, Identifiable {
            var id = UUID()
            let ip_address: String?
            let last_reported_ip: String?
            let mac_address: String?
            let alt_mac_address: String?
            var name, networkAdapterType, altNetworkAdapterType: String?
            var serialNumber: String?
            var udid, jamfVersion, platform, barcode1: String?
            var barcode2, assetTag: String?
            var remoteManagement: RemoteManagement?
            var supervised, mdmCapable: Bool?
            var mdmCapableUsers: MdmCapableUsers?
            var reportDate: String?
            var reportDateEpoch: Int?
            var reportDateUTC, lastContactTime: String?
            var lastContactTimeEpoch: Int?
            var lastContactTimeUTC, initialEntryDate: String?
            var initialEntryDateEpoch: Int?
            var initialEntryDateUTC: String?
            var lastCloudBackupDateEpoch: Int?
            var lastCloudBackupDateUTC: String?
            var lastEnrolledDateEpoch: Int?
            var lastEnrolledDateUTC, distributionPoint, sus, netbootServer: String?
            //              var site: Site?
            var itunesStoreAccountIsActive: Bool?
            
            enum CodingKeys: String, CodingKey {
                case ip_address = "ip_address"
                case last_reported_ip = "last_reported_ip"
                case mac_address = "mac_address"
                case alt_mac_address = "alt_mac_address"
                case name = "name"
                case networkAdapterType = "network_adapter_type"
                case altNetworkAdapterType = "alt_network_adapter_type"
                case serialNumber = "serial_number"
                case udid = "udid"
                case jamfVersion = "jamf_version"
                case platform = "platform"
                case barcode1 = "barcode1"
                case barcode2 = "barcode2"
                case assetTag = "asset_tag"
                case remoteManagement = "remote_management"
                case supervised = "supervised"
                case mdmCapable = "mdm_capable"
                case mdmCapableUsers = "mdm_capable_users"
                case reportDate = "report_date"
                case reportDateEpoch = "report_date_epoch"
                case reportDateUTC = "report_date_utc"
                case lastContactTime = "last_contact_time"
                case lastContactTimeEpoch = "last_contact_time_epoch"
                case lastContactTimeUTC = "last_contact_time_utc"
                case initialEntryDate = "initial_entry_date"
                case initialEntryDateEpoch = "initial_entry_date_epoch"
                case initialEntryDateUTC = "initial_entry_date_utc"
                case lastCloudBackupDateEpoch = "last_cloud_backup_date_epoch"
                case lastCloudBackupDateUTC = "last_cloud_backup_date_utc"
                case lastEnrolledDateEpoch = "last_enrolled_date_epoch"
                case lastEnrolledDateUTC = "last_enrolled_date_utc"
                case distributionPoint = "distribution_point"
                case sus = "sus"
                case netbootServer = "netboot_server"
                case itunesStoreAccountIsActive = "itunes_store_account_is_active"
                
            }
        }
        
        // MARK: - MdmCapableUsers
        struct MdmCapableUsers: Codable, Identifiable, Hashable {
            var id = UUID()
            var mdmCapableUser: String?
            
            enum CodingKeys: String, CodingKey {
                case mdmCapableUser = "mdm_capable_user"
            }
        }
        // MARK: - RemoteManagement
        struct RemoteManagement: Codable, Identifiable, Hashable {
            var id = UUID()
            var managed: Bool?
            var managementUsername, managementPasswordSha256: String?
            
            enum CodingKeys: String, CodingKey {
                case managed = "managed"
                case managementUsername = "management_username"
                case managementPasswordSha256 = "management_password_sha256"
            }
        }
        
    }
    
    
    struct ComputerGroups: Codable, Hashable, Identifiable {
        var id = UUID()
        let jamfId: Int?
        let name: String?
        enum CodingKeys: String, CodingKey {
            case jamfId = "id"
            case name = "name"
        }
    }
    
    
    //MARK: - BUILDING
    
    struct Building: Codable, Hashable, Identifiable {
        var id = UUID()
        let jamfId: Int?
        let name: String?
        enum CodingKeys: String, CodingKey {
            case jamfId = "id"
            case name = "name"
        }
    }
    
    
    // MARK: - DEPARTMENT
    struct Departments: Codable, Hashable, Identifiable {
        var id = UUID()
        let jamfId: Int?
        let name: String?
        
        enum CodingKeys: String, CodingKey {
            case jamfId = "id"
            case name = "name"
        }
    }
    
    
    // MARK: - Location
    struct Location: Codable, Identifiable, Hashable {
        var id = UUID()
        var username, realname, emailAddress: String?
        var position, phone, phoneNumber, department: String?
        var building, room: String?
        
        enum CodingKeys: String, CodingKey {
            case username = "username"
            case realname = "realname"
            case emailAddress = "emailAddress"
            case position = "position"
            case phone = "phone"
            case phoneNumber = "phone_number"
            case department = "department"
            case building = "building"
            case room = "room"
        }
    }
    
    
    // MARK: - Exclusions
    struct Exclusions: Codable, Hashable, Identifiable  {
        var id = UUID()
        let computers, computerGroups, buildings, departments: [GenericItem]?
        let users, userGroups, networkSegments, ibeacons: [GenericItem]?
        let mobile_devices, mobile_device_groups, jss_users, jss_user_groups: [GenericItem]?
        
        enum CodingKeys: String, CodingKey {
            case computers = "computers"
            case computerGroups = "computer_groups"
            case buildings = "buildings"
            case departments = "departments"
            case users = "users"
            case userGroups = "user_groups"
            case networkSegments = "network_segments"
            case ibeacons = "ibeacons"
            case mobile_devices = "mobile_devices"
            case mobile_device_groups = "mobile_device_groups"
            case jss_users = "jss_users"
            case jss_user_groups = "jss_user_groups"
        }
        
    }
    
    // MARK: - LimitToUsers
    struct LimitToUsers: Codable, Hashable, Identifiable  {
        var id = UUID()
        let users: [Users]?
        enum CodingKeys:String, CodingKey {
            case users = "users"
        }
    }
    
    // MARK: - Limitations
    struct Limitations: Codable, Hashable, Identifiable  {
        var id = UUID()
        let userGroups: [UserGroups]?
        let users: [GenericItem]?
        let network_segments: [GenericItem]?
        let ibeacons: [GenericItem]?
        let jss_users: [GenericItem]?
        let jss_user_groups: [GenericItem]?
        
        enum CodingKeys:String, CodingKey {
            case userGroups = "user_groups"
            case users = "users"
            case network_segments = "network_segments"
            case ibeacons = "ibeacons"
            case jss_users = "jss_users"
            case jss_user_groups = "jss_user_groups"
        }
    }
    // MARK: - SelfServiceCategory
    struct SelfServiceCategory: Codable, Hashable, Identifiable {
        var id = UUID()
        let jamfId: Int?
        let name: String?
        let displayIn, featureIn: Bool?
        
        enum CodingKeys:String, CodingKey {
            case jamfId = "id"
            case name = "name"
            case displayIn = "display_in"
            case featureIn = "feature_in"
        }
    }
    //    // MARK: - SelfService
    struct SelfService: Codable, Hashable, Identifiable  {
        var id = UUID()
        let useForSelfService: Bool?
        let selfServiceDisplayName, installButtonText, reinstallButtonText, selfServiceDescription: String?
        let forceUsersToViewDescription: Bool?
        // let selfServiceIcon: SelfServiceIcon
        let featureOnMainPage: Bool?
        let selfServiceCategories: [SelfServiceCategory]?
        let notification, notificationSubject, notificationMessage: String?
        enum CodingKeys:String, CodingKey {
            case useForSelfService = "use_for_self_service"
            case selfServiceDisplayName = "self_service_display_name"
            case installButtonText = "install_button_text"
            case reinstallButtonText = "reinstall_button_text"
            case selfServiceDescription = "self_service_description"
            case forceUsersToViewDescription = "force_users_to_view_description"
            // case selfServiceIcon = "self_service_icon"
            case featureOnMainPage = "feature_on_main_page"
            case selfServiceCategories = "self_service_categories"
            case notification = "notification"
            case notificationSubject = "notification_subject"
            case notificationMessage = "notification_message"
            
        }
    }
    //
    //    // MARK: - UserInteraction
    //    struct UserInteraction {
    //        let messageStart: String?
    //        let allowUsersToDefer: Bool?
    //        let allowDeferralUntilUTC, messageFinish: String?
    //    }
    
    
    //MARK: - PrinterElement
    enum PrinterElement: Codable, Hashable {
        case printerClass(PrinterClass)
        case string(String)
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            printerArray = []
            if let x = try? container.decode(String.self) {
                self = .string(x)
                return
            }
            if let x = try? container.decode(PrinterClass.self) {
                self = .printerClass(x)
                printerArray.append(x)
                return
            }
            throw DecodingError.typeMismatch(PrinterElement.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for PrinterElement"))
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .printerClass(let x):
                try container.encode(x)
            case .string(let x):
                try container.encode(x)
            }
        }
    }
    
    // MARK: - PrinterClass
    struct PrinterClass: Codable, Hashable, Identifiable {
        var id = UUID()
        var jamfId: Int?
        var name, action: String?
        var makeDefault: Bool?
        
        enum CodingKeys: String, CodingKey {
            case jamfId = "id"
            case name = "name"
            case action = "action"
            case makeDefault = "makeDefault"
        }
        
    }
    
    struct Users: Codable, Hashable, Identifiable {
        var id = UUID()
        var name: String?
        enum CodingKeys: String, CodingKey {
            case name = "name"
        }
    }
    
    
    struct UserGroups: Codable, Hashable, Identifiable {
        var id = UUID()
        var name: String?
        enum CodingKeys: String, CodingKey {
            case name = "name"
        }
    }
    
    struct GenericItem: Codable, Hashable, Identifiable {
        var id = UUID()
        var name: String?
        enum CodingKeys: String, CodingKey {
            case name = "name"
        }
    }
    
    
    
    //MARK: - DEVICES
    struct MobileDeviceMatch: Codable, Identifiable, Hashable {
        var id = UUID()
        var mobileDevices:[MobileDevices]?
        enum CodingKeys: String, CodingKey {
            case mobileDevices = "mobile_devices"
        }
        struct MobileDevices: Codable, Identifiable, Hashable {
            var id = UUID()
            var jamfId: Int
            var name, udid, serialNumber, macAddress: String?
            var wifiMACAddress, username, realname, email: String?
            var emailAddress, room, position, building: String?
            var buildingName, department, departmentName: String?
            var assetTag, lastInventoryUpdate:String?
            var capacity, capacity_mb, available, percentageUsed: Int?
            var osVersion, phoneNumber, ipAddress: String?
            var model: String?
            var supervised: Bool?
            
            enum CodingKeys: String, CodingKey {
                case jamfId = "id"
                case name = "name"
                case udid = "udid"
                case serialNumber = "serial_number"
                case macAddress = "mac_address"
                case wifiMACAddress = "wifi_mac_address"
                case username = "username"
                case realname = "realname"
                case email = "email"
                case emailAddress = "email_address"
                case room = "room"
                case position = "position"
                case building = "building"
                case buildingName = "building_name"
                case department = "department"
                case departmentName = "department_name"
                case assetTag = "asset_tag"
                case lastInventoryUpdate = "last_inventory_update"
                case capacity = "capacity"
                case capacity_mb = "capacity_mb"
                case available = "available"
                case percentageUsed = "precentage_used"
                case osVersion = "os_version"
                case phoneNumber = "phone_number"
                case ipAddress = "ip_address"
                case model = "model"
                case supervised = "supervised"
            }
            
        }
    }
    
    // MARK: - MobileDevice
    struct MobileDevice: Codable, Identifiable, Hashable {
        var id = UUID()
        let name, udid: String?
        var mobileDevice:Response?
        
        enum CodingKeys: String, CodingKey {
            case name = "name"
            case udid = "udid"
            case mobileDevice = "mobile_device"
        }
        
        struct Response: Codable, Identifiable, Hashable {
            var id = UUID()
            var jamfId: Int?
            var general: MobileGeneral?
            var location: Location?
            var network: Network?
            
            enum CodingKeys: String, CodingKey {
                case general = "general"
                case jamfId = "id"
                case location = "location"
                case network = "network"
            }
            struct MobileGeneral:  Codable, Identifiable, Hashable {
                var id: Int?
                var displayName, deviceName, name, assetTag: String?
                var lastInventoryUpdate: String?
                var lastInventoryUpdateEpoch: Int?
                var lastInventoryUpdateUTC: String?
                var capacity, capacityMB, available, availableMB: Int?
                var percentageUsed: Int?
                var osType, osVersion, osBuild, serialNumber: String?
                var udid: String?
                var initialEntryDateEpoch: Int?
                var initialEntryDateUTC, phoneNumber, ipAddress, wifiMACAddress: String?
                var bluetoothMACAddress, modemFirmware, model, modelIdentifier: String?
                var modelNumber, modelDisplay, generalModelDisplay, deviceOwnershipLevel: String?
                var lastEnrollmentEpoch: Int?
                var lastEnrollmentUTC: String?
                var managed, supervised: Bool?
                var exchangeActivesyncDeviceIdentifier, shared, diagnosticSubmission, appAnalytics: String?
                var tethered: String?
                var batteryLevel: Int?
                var bleCapable, deviceLocatorServiceEnabled, doNotDisturbEnabled, cloudBackupEnabled: Bool?
                var lastCloudBackupDateEpoch: Int?
                var lastCloudBackupDateUTC: String?
                var locationServicesEnabled, itunesStoreAccountIsActive: Bool?
                var lastBackupTimeEpoch: Int?
                var lastBackupTimeUTC: String?
                //  var site: Site?
                
                enum CodingKeys: String, CodingKey {
                    case id = "id"
                    case displayName = "display_name"
                    case deviceName = "device_name"
                    case name = "name"
                    case assetTag = "asset_tag"
                    case lastInventoryUpdate = "last_inventory_update"
                    case lastInventoryUpdateEpoch = "last_inventory_update_epoch"
                    case lastInventoryUpdateUTC = "last_inventory_update_utc"
                    case capacity = "capacity"
                    case capacityMB = "capacity_mb"
                    case available = "available"
                    case availableMB = "available_mb"
                    case percentageUsed = "percentage_used"
                    case osType = "os_type"
                    case osVersion = "os_version"
                    case osBuild = "os_build"
                    case serialNumber = "serial_number"
                    case udid = "udid"
                    case initialEntryDateEpoch = "initial_entry_date_epoch"
                    case initialEntryDateUTC = "initial_entry_date_utc"
                    case phoneNumber = "phone_number"
                    case ipAddress = "ip_address"
                    case wifiMACAddress = "wifi_mac_address"
                    case bluetoothMACAddress = "bluetooth_mac_address"
                    case modemFirmware = "modem_firmware"
                    case model = "model"
                    case modelIdentifier = "model_identifier"
                    case modelNumber = "model_number"
                    case modelDisplay = "model_display"
                    case generalModelDisplay = "general_model_display"
                    case deviceOwnershipLevel = "device_ownership_level"
                    case lastEnrollmentEpoch = "last_enrollment_epoch"
                    case lastEnrollmentUTC = "last_enrollment_utc"
                    case managed = "managed"
                    case supervised = "supervised"
                    case exchangeActivesyncDeviceIdentifier = "exchange_activesync_identifier"
                    case shared = "shared"
                    case diagnosticSubmission = "diagnostic_submission"
                    case appAnalytics = "app_analytics"
                    case tethered = "tethered"
                    case batteryLevel = "battery_level"
                    case bleCapable = "ble_capable"
                    case deviceLocatorServiceEnabled = "device_locator_service_enabled"
                    case doNotDisturbEnabled = "do_not_disturb_enabled"
                    case cloudBackupEnabled = "cloud_backup_enabled"
                    case lastCloudBackupDateEpoch = "last_cloud_backup_date_epoch"
                    case lastCloudBackupDateUTC = "last_cloud_backup_date_UTC"
                    case locationServicesEnabled = "location_services_enabled"
                    case itunesStoreAccountIsActive = "itunes_store_account_is_active"
                    case lastBackupTimeEpoch = "last_backup_time_epoch"
                    case lastBackupTimeUTC = "last_backup_time_utc"
                    // case site = "site"
                }
            }
            
        }
        
    }
    
    
    
    // MARK: - ConfigurationProfile
    struct ConfigurationProfiles: Codable, Identifiable, Hashable {
        var id = UUID()
        var configurationProfiles: [ConfigurationProfile]?
        var computerConfigurations: [ConfigurationProfile]?
        enum CodingKeys: String, CodingKey {
            case configurationProfiles = "configuration_profiles"
            case computerConfigurations = "os_x_configuration_profiles"
        }
        struct ConfigurationProfile: Codable, Identifiable, Hashable {
            var id = UUID()
            var jamfId: Int?
            var name: String?
            
            enum CodingKeys: String, CodingKey {
                case jamfId = "id"
                case name = "name"
            }
        }
    }
    
    
    //THE NAME HAS TO BE IDENTICAL TO THE JSON RESPONSE IF ITS NOT IDENTIFIABLE
    struct OsXConfigurationProfile: Codable, Hashable {
        //var os_x_configuration_profiles: ConfigurationProfile?
        var os_x_configuration_profile: ConfigurationProfile?
    }
    
    struct MobileConfigurationProfile: Codable, Hashable {
        var configuration_profile: ConfigurationProfile?
    }
    
    struct ConfigurationProfile: Codable, Hashable {
        var general: General?
        var scope: Scope?
        var selfService: SelfService?
        var payloads: ConfigPayload?
        
        
        enum CodingKeys: String, CodingKey {
            case general = "general"
            case scope = "scope"
            case selfService = "self_service"
            case payloads = "payloads"
            
        }
    }
    
    
    //MARK: - MOBILE CONFIGURATION PROFILE
    
    struct ConfigPayload: Codable, Identifiable, Hashable {
        var id = UUID()
        var payload:String?
    }
    
    
    // MARK: - Network
    struct Network: Codable, Hashable {
        var homeCarrierNetwork, cellularTechnology, voiceRoamingEnabled, imei: String?
        var iccid, meid, currentCarrierNetwork, carrierSettingsVersion: String?
        var currentMobileCountryCode, currentMobileNetworkCode, homeMobileCountryCode, homeMobileNetworkCode: String?
        var dataRoamingEnabled, roaming: Bool?
        var phoneNumber: String?
        
        enum CodingKeys: String, CodingKey {
            case homeCarrierNetwork = "home_carrier_network"
            case cellularTechnology = "cellular_technology"
            case voiceRoamingEnabled = "voice_roaming_enabled"
            case imei = "imei"
            case iccid = "iccid"
            case meid = "meid"
            case currentCarrierNetwork = "current_carrier_network"
            case carrierSettingsVersion = "carrier_settings_version"
            case currentMobileCountryCode = "current_mobile_country_code"
            case currentMobileNetworkCode = "current_mobile_network_code"
            case homeMobileCountryCode = "home_mobile_country_code"
            case homeMobileNetworkCode = "home_mobile_network_code"
            case dataRoamingEnabled = "data_roaming_enabled"
            case roaming = "roaming"
            case phoneNumber = "phone_number"
        }
    }
    
    
}



