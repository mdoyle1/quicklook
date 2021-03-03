//
//  PoliciesAPI.swift
//  quicklook
//
//  Created by Toxicspu on 4/14/20.
//  Copyright © 2020 developer. All rights reserved.
//

//https://stackoverflow.com/questions/38952420/swift-wait-until-datataskwithrequest-has-finished-to-call-the-return

import Foundation
import SwiftUI


class PoliciesAPI {
    
    @ObservedObject var viewModel = Defaults()
    @EnvironmentObject var controlCenter: ControlCenter
    
    
    func getPolicies(completion: @escaping ([Responses.Policies.Response]) -> ()){
        let url = $viewModel.defaultURL.wrappedValue+"/JSSResource/policies"
        // Request options
        var request = URLRequest(url: URL(string:url)!)
        request.httpMethod = "GET"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let config = URLSessionConfiguration.default
        
        //API Authentication
        let userPasswordString = "\($viewModel.usernameStore.wrappedValue):\($viewModel.passwordStore.wrappedValue)"
        let userPasswordData = userPasswordString.data(using: String.Encoding.utf8)
        let base64EncodedCredential = userPasswordData!.base64EncodedString(options: [])
        let authString = "Basic \(base64EncodedCredential)"
        config.httpAdditionalHeaders = ["Authorization" : authString]
        
        
        URLSession(configuration: config).dataTask(with: request) { (data, response, err) in
            guard let data = data else { return }
            guard let policies = try? JSONDecoder().decode(Responses.Policies.self, from: data) else {
                print ("Sacko")
                return}
            print("Got Policies?")
            DispatchQueue.main.async {
                completion(policies.policies)
                
            }
        }.resume()
    }
    
    
    func policyDetails (id:Int,completion: @escaping (Responses.PolicyCodable) -> ()){
        
        let url = $viewModel.defaultURL.wrappedValue+"/JSSResource/policies/id/\(id)"
        print(url)
        // Request options
        var request = URLRequest(url: URL(string:url)!)
        request.httpMethod = "GET"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let config = URLSessionConfiguration.default
        
        //API Authentication
        let userPasswordString = "\($viewModel.usernameStore.wrappedValue):\($viewModel.passwordStore.wrappedValue)"
        let userPasswordData = userPasswordString.data(using: String.Encoding.utf8)
        let base64EncodedCredential = userPasswordData!.base64EncodedString(options: [])
        let authString = "Basic \(base64EncodedCredential)"
        config.httpAdditionalHeaders = ["Authorization" : authString]
        
        URLSession(configuration: config).dataTask(with: request) { (data, response, err) in
            guard let data = data else { return }
            
            guard let policy = try? JSONDecoder().decode(Responses.PolicyCodable?.self, from: data) else {
                
                print ("Failed")
                print(String(data:data, encoding: .utf8))
                return}
            print("Got Policies.")
            print(policy.policy.general?.jamfId)
            // print(policy.policy.scope)
            DispatchQueue.main.async {
                completion(policy.self)
            }
        }.resume()
        
    }
    
    
    func deletePolicy (id: String, completion:()->()) {
        
        let sem = DispatchSemaphore.init(value: 0)
        let url = $viewModel.defaultURL.wrappedValue+"/JSSResource/policies/id/"+"\(id.description)"
        print(url)
        
        // Request options
        
        var request = URLRequest(url: URL(string:url)!)
        request.httpMethod = "DELETE"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let config = URLSessionConfiguration.default
        
        //API Authentication
        let userPasswordString = "\($viewModel.usernameStore.wrappedValue):\($viewModel.passwordStore.wrappedValue)"
        let userPasswordData = userPasswordString.data(using: String.Encoding.utf8)
        let base64EncodedCredential = userPasswordData!.base64EncodedString(options: [])
        let authString = "Basic \(base64EncodedCredential)"
        config.httpAdditionalHeaders = ["Authorization" : authString]
        
        URLSession(configuration: config).dataTask(with: request) { (data, response, err) in
            defer { sem.signal() }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    print("Bad Credentials")
                    return
            }
            
            print("Just Deleted Policy")
        }.resume()
        sem.wait()
        completion()
    }
    
    
    
    func updatePolicy(policyToggle:Bool, deviceId:String){
        let sem = DispatchSemaphore.init(value: 0)
        var xml:String
        if policyToggle == false {
            xml = "<policy><general><enabled>true</enabled></general></policy>" }
        else { xml = "<policy><general><enabled>false</enabled></general></policy>" }
        
        let xmldata = xml.data(using: .utf8)
        let url = $viewModel.defaultURL.wrappedValue+"/JSSResource/policies/id/\(deviceId)"
        print(url)
        // Request options
        var request = URLRequest(url: URL(string:url)!)
        request.httpMethod = "PUT"
        request.httpBody = xmldata
        let config = URLSessionConfiguration.default
        
        //API Authentication
        let userPasswordString = "\($viewModel.usernameStore.wrappedValue):\($viewModel.passwordStore.wrappedValue)"
        let userPasswordData = userPasswordString.data(using: String.Encoding.utf8)
        let base64EncodedCredential = userPasswordData!.base64EncodedString(options: [])
        let authString = "Basic \(base64EncodedCredential)"
        config.httpAdditionalHeaders = ["Authorization" : authString]
        URLSession(configuration: config).dataTask(with: request) { (data, response, err) in
            defer { sem.signal() }
            
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    print("Bad Credentials")
                    print(response)
                    return
            }
        }.resume()
        sem.wait()
    }
    
    
    
    //MARK: - Create Policy
    func pushPackage(control: ControlCenter, packageName:String, packageID:Int, computerID:Int, computerName:String,computerUDID:String){
        let sem = DispatchSemaphore.init(value: 0)
        var xml:String
        let date = String(DateFormatter.localizedString(from: NSDate() as Date, dateStyle: .short, timeStyle: .short))
        
        
        xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <policy>
            <general>
                <id>0</id>
                <name>\(date + " | " + $viewModel.usernameStore.wrappedValue)</name>
                <enabled>true</enabled>
                <trigger>CHECKIN</trigger>
                <trigger_checkin>true</trigger_checkin>
                <trigger_enrollment_complete>false</trigger_enrollment_complete>
                <trigger_login>false</trigger_login>
                <trigger_logout>false</trigger_logout>
                <trigger_network_state_changed>false</trigger_network_state_changed>
                <trigger_startup>false</trigger_startup>
                <trigger_other/>
                <frequency>Once per computer</frequency>
                <retry_event>check-in</retry_event>
                <retry_attempts>3</retry_attempts>
                <notify_on_each_failed_retry>false</notify_on_each_failed_retry>
                <location_user_only>false</location_user_only>
                <target_drive>/</target_drive>
                <offline>false</offline>
                <date_time_limitations>
                    <activation_date/>
                    <activation_date_epoch>0</activation_date_epoch>
                    <activation_date_utc/>
                    <expiration_date/>
                    <expiration_date_epoch>0</expiration_date_epoch>
                    <expiration_date_utc/>
                    <no_execute_on/>
                    <no_execute_start/>
                    <no_execute_end/>
                </date_time_limitations>
                <network_limitations>
                    <minimum_network_connection>No Minimum</minimum_network_connection>
                    <any_ip_address>true</any_ip_address>
                    <network_segments/>
                </network_limitations>
                <override_default_settings>
                    <target_drive>default</target_drive>
                    <distribution_point/>
                    <force_afp_smb>false</force_afp_smb>
                    <sus>default</sus>
                    <netboot_server>current</netboot_server>
                </override_default_settings>
                <network_requirements>Any</network_requirements>
                <site>
                    <id>-1</id>
                    <name>None</name>
                </site>
            </general>
            <scope>
                <all_computers>false</all_computers>
                <computers>
                    <computer>
                        <id>\(computerID)</id>
                        <name>\(computerName)</name>
                        <udid>\(computerUDID)</udid>
                    </computer>
                </computers>
                <computer_groups/>
                <buildings/>
                <departments/>
                <limit_to_users>
                    <user_groups/>
                </limit_to_users>
                <limitations>
                    <users/>
                    <user_groups/>
                    <network_segments/>
                    <ibeacons/>
                </limitations>
                <exclusions>
                    <computers/>
                    <computer_groups/>
                    <buildings/>
                    <departments/>
                    <users/>
                    <user_groups/>
                    <network_segments/>
                    <ibeacons/>
                </exclusions>
            </scope>
            <self_service>
                <use_for_self_service>false</use_for_self_service>
                <self_service_display_name/>
                <install_button_text>Install</install_button_text>
                <reinstall_button_text>Reinstall</reinstall_button_text>
                <self_service_description/>
                <force_users_to_view_description>false</force_users_to_view_description>
                <self_service_icon/>
                <feature_on_main_page>false</feature_on_main_page>
                <self_service_categories/>
                <notification>false</notification>
                <notification>Self Service</notification>
                <notification_subject>Deploy Package</notification_subject>
                <notification_message/>
            </self_service>
            <package_configuration>
                <packages>
                    <size>1</size>
                    <package>
                        <id>\(packageID)</id>
                        <name>\(packageName)</name>
                        <action>Install</action>
                        <fut>false</fut>
                        <feu>false</feu>
                        <update_autorun>false</update_autorun>
                    </package>
                </packages>
            </package_configuration>
            <scripts>
                <size>0</size>
            </scripts>
            <printers>
                <size>0</size>
                <leave_existing_default/>
            </printers>
            <dock_items>
                <size>0</size>
            </dock_items>
            <account_maintenance>
                <accounts>
                    <size>0</size>
                </accounts>
                <directory_bindings>
                    <size>0</size>
                </directory_bindings>
                <management_account>
                    <action>doNotChange</action>
                </management_account>
            </account_maintenance>
            <reboot>
                <message>This computer will restart in 5 minutes. Please save anything you are working on and log out by choosing Log Out from the bottom of the Apple menu.</message>
                <startup_disk>Current Startup Disk</startup_disk>
                <specify_startup/>
                <no_user_logged_in>Do not restart</no_user_logged_in>
                <user_logged_in>Do not restart</user_logged_in>
                <minutes_until_reboot>5</minutes_until_reboot>
                <start_reboot_timer_immediately>false</start_reboot_timer_immediately>
                <file_vault_2_reboot>false</file_vault_2_reboot>
            </reboot>
            <maintenance>
                <recon>true</recon>
                <reset_name>false</reset_name>
                <install_all_cached_packages>false</install_all_cached_packages>
                <heal>false</heal>
                <prebindings>false</prebindings>
                <permissions>false</permissions>
                <byhost>false</byhost>
                <system_cache>false</system_cache>
                <user_cache>false</user_cache>
                <verify>false</verify>
            </maintenance>
            <files_processes>
                <search_by_path/>
                <delete_file>false</delete_file>
                <locate_file/>
                <update_locate_database>false</update_locate_database>
                <spotlight_search/>
                <search_for_process/>
                <kill_process>false</kill_process>
                <run_command/>
            </files_processes>
            <user_interaction>
                <message_start>Installing Package</message_start>
                <allow_users_to_defer>false</allow_users_to_defer>
                <allow_deferral_until_utc/>
                <allow_deferral_minutes>0</allow_deferral_minutes>
                <message_finish>Package Installed</message_finish>
            </user_interaction>
            <disk_encryption>
                <action>none</action>
            </disk_encryption>
        </policy>
        """
        
        
        let xmldata = xml.data(using: .utf8)
        let url = $viewModel.defaultURL.wrappedValue+"/JSSResource/policies/id/0"
        
        print(url)
        // Request options
        var request = URLRequest(url: URL(string:url)!)
        request.httpMethod = "POST"
        request.setValue("application/xml", forHTTPHeaderField: "Content-Type")
        request.setValue("application/xml", forHTTPHeaderField: "Accept")
        request.httpBody = xmldata
        let config = URLSessionConfiguration.default
        //API Authentication
        let userPasswordString = "\($viewModel.usernameStore.wrappedValue):\($viewModel.passwordStore.wrappedValue)"
        let userPasswordData = userPasswordString.data(using: String.Encoding.utf8)
        let base64EncodedCredential = userPasswordData!.base64EncodedString(options: [])
        let authString = "Basic \(base64EncodedCredential)"
        config.httpAdditionalHeaders = ["Authorization" : authString]
        URLSession(configuration: config).dataTask(with: request) { (data, response, err) in
            defer { sem.signal() }
            
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    control.pushPackageResponse = false
                    print("Bad Credentials")
                    print(response!)
                    return
            }
            
                 DispatchQueue.main.async {
                    control.pushPackageResponse = true
            }
        }.resume()
        sem.wait()
    }
    
    
    //MARK: - PUSH SCRIPTS
    func pushScript(control: ControlCenter, scriptName:String, scriptID:String, computerID:Int, computerName:String,computerUDID:String){
        let sem = DispatchSemaphore.init(value: 0)
        var xml:String
        let date = String(DateFormatter.localizedString(from: NSDate() as Date, dateStyle: .short, timeStyle: .short))

        xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <policy>
          <general>
            <id>0</id>
            <name>\(date + " | " + $viewModel.usernameStore.wrappedValue)</name>
            <enabled>true</enabled>
            <trigger>CHECKIN</trigger>
            <trigger_checkin>true</trigger_checkin>
            <trigger_enrollment_complete>false</trigger_enrollment_complete>
            <trigger_login>false</trigger_login>
            <trigger_logout>false</trigger_logout>
            <trigger_network_state_changed>false</trigger_network_state_changed>
            <trigger_startup>false</trigger_startup>
            <trigger_other/>
            <frequency>Once per computer</frequency>
            <retry_event>check-in</retry_event>
            <retry_attempts>3</retry_attempts>
            <notify_on_each_failed_retry>false</notify_on_each_failed_retry>
            <location_user_only>false</location_user_only>
            <target_drive>/</target_drive>
            <offline>false</offline>
            <category>
              <id>-1</id>
              <name>No category assigned</name>
            </category>
            <date_time_limitations>
              <activation_date/>
              <activation_date_epoch>0</activation_date_epoch>
              <activation_date_utc/>
              <expiration_date/>
              <expiration_date_epoch>0</expiration_date_epoch>
              <expiration_date_utc/>
              <no_execute_on/>
              <no_execute_start/>
              <no_execute_end/>
            </date_time_limitations>
            <network_limitations>
              <minimum_network_connection>No Minimum</minimum_network_connection>
              <any_ip_address>true</any_ip_address>
              <network_segments/>
            </network_limitations>
            <override_default_settings>
              <target_drive>default</target_drive>
              <distribution_point/>
              <force_afp_smb>false</force_afp_smb>
              <sus>default</sus>
              <netboot_server>current</netboot_server>
            </override_default_settings>
            <network_requirements>Any</network_requirements>
            <site>
              <id>-1</id>
              <name>None</name>
            </site>
          </general>
          <scope>
            <all_computers>false</all_computers>
            <computers>
              <computer>
                <id>\(computerID)</id>
                <name>\(computerName)</name>
                <udid>\(computerUDID)</udid>
              </computer>
            </computers>
            <computer_groups/>
            <buildings/>
            <departments/>
            <limit_to_users>
              <user_groups/>
            </limit_to_users>
            <limitations>
              <users/>
              <user_groups/>
              <network_segments/>
              <ibeacons/>
            </limitations>
            <exclusions>
              <computers/>
              <computer_groups/>
              <buildings/>
              <departments/>
              <users/>
              <user_groups/>
              <network_segments/>
              <ibeacons/>
            </exclusions>
          </scope>
          <self_service>
            <use_for_self_service>false</use_for_self_service>
            <self_service_display_name/>
            <install_button_text>Install</install_button_text>
            <reinstall_button_text>Reinstall</reinstall_button_text>
            <self_service_description/>
            <force_users_to_view_description>false</force_users_to_view_description>
            <self_service_icon/>
            <feature_on_main_page>false</feature_on_main_page>
            <self_service_categories/>
            <notification>false</notification>
            <notification>Self Service</notification>
            <notification_subject>Deploy Script</notification_subject>
            <notification_message/>
          </self_service>
          <package_configuration>
            <packages>
              <size>0</size>
            </packages>
          </package_configuration>
          <scripts>
            <size>1</size>
            <script>
              <id>\(scriptID)</id>
              <name>\(scriptName)</name>
              <priority>After</priority>
              <parameter4/>
              <parameter5/>
              <parameter6/>
              <parameter7/>
              <parameter8/>
              <parameter9/>
              <parameter10/>
              <parameter11/>
            </script>
          </scripts>
          <printers>
            <size>0</size>
            <leave_existing_default/>
          </printers>
          <dock_items>
            <size>0</size>
          </dock_items>
          <account_maintenance>
            <accounts>
              <size>0</size>
            </accounts>
            <directory_bindings>
              <size>0</size>
            </directory_bindings>
            <management_account>
              <action>doNotChange</action>
            </management_account>
          </account_maintenance>
          <reboot>
            <message>This computer will restart in 5 minutes. Please save anything you are working on and log out by choosing Log Out from the bottom of the Apple menu.</message>
            <startup_disk>Current Startup Disk</startup_disk>
            <specify_startup/>
            <no_user_logged_in>Do not restart</no_user_logged_in>
            <user_logged_in>Do not restart</user_logged_in>
            <minutes_until_reboot>5</minutes_until_reboot>
            <start_reboot_timer_immediately>false</start_reboot_timer_immediately>
            <file_vault_2_reboot>false</file_vault_2_reboot>
          </reboot>
          <maintenance>
            <recon>false</recon>
            <reset_name>false</reset_name>
            <install_all_cached_packages>false</install_all_cached_packages>
            <heal>false</heal>
            <prebindings>false</prebindings>
            <permissions>false</permissions>
            <byhost>false</byhost>
            <system_cache>false</system_cache>
            <user_cache>false</user_cache>
            <verify>false</verify>
          </maintenance>
          <files_processes>
            <search_by_path/>
            <delete_file>false</delete_file>
            <locate_file/>
            <update_locate_database>false</update_locate_database>
            <spotlight_search/>
            <search_for_process/>
            <kill_process>false</kill_process>
            <run_command/>
          </files_processes>
          <user_interaction>
            <message_start/>
            <allow_users_to_defer>false</allow_users_to_defer>
            <allow_deferral_until_utc/>
            <allow_deferral_minutes>0</allow_deferral_minutes>
            <message_finish/>
          </user_interaction>
          <disk_encryption>
            <action>none</action>
          </disk_encryption>
        </policy>
        """
        
        
        let xmldata = xml.data(using: .utf8)
        let url = $viewModel.defaultURL.wrappedValue+"/JSSResource/policies/id/0"
        
        print(url)
        // Request options
        var request = URLRequest(url: URL(string:url)!)
        request.httpMethod = "POST"
        request.setValue("application/xml", forHTTPHeaderField: "Content-Type")
        request.setValue("application/xml", forHTTPHeaderField: "Accept")
        request.httpBody = xmldata
        let config = URLSessionConfiguration.default
        //API Authentication
        let userPasswordString = "\($viewModel.usernameStore.wrappedValue):\($viewModel.passwordStore.wrappedValue)"
        let userPasswordData = userPasswordString.data(using: String.Encoding.utf8)
        let base64EncodedCredential = userPasswordData!.base64EncodedString(options: [])
        let authString = "Basic \(base64EncodedCredential)"
        config.httpAdditionalHeaders = ["Authorization" : authString]
        URLSession(configuration: config).dataTask(with: request) { (data, response, err) in
            defer { sem.signal() }
            
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
        
                    control.pushScriptResponse = false
                
                    print("Bad Credentials")
                    print(response!)
                    return
            }
            
                 DispatchQueue.main.async {
                    control.pushPackageResponse = true
            }
        }.resume()
        sem.wait()
    }
    
    
}










