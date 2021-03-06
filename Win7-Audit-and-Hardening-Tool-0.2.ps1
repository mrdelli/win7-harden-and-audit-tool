    # Clear screen for starters
    cls

    ### Functions ###
    
    ### Function to check registry values ###
    
    function CheckRegistryValue {

        param (

             [parameter(Mandatory=$true)][ValidateNotNullOrEmpty()]$Path,
             [parameter(Mandatory=$true)][ValidateNotNullOrEmpty()]$Name,
             [parameter(Mandatory=$true)][ValidateNotNullOrEmpty()]$Data
             
        )

        try {
            
            $ValueCheck = Get-ItemProperty -Path $Path -Name $Name -ErrorAction SilentlyContinue
            
            ### Check if comparable registry data is same as passed  ###
            
            if($ValueCheck.$Name -eq $Data) {
                
                return $true
            }
        
            elseif($ValueCheck.$Name -ne $Data) {
        
                return $false
            }
        }

        catch {
        
            return $false

        }
    }

    function CheckServiceStatus {
        
        param (
        
            [parameter(Mandatory=$true)]$serviceName
        )
        
        $serviceName = get-service $serviceName -ErrorAction SilentlyContinue
        
        if (-Not $serviceName) {
        
            $serviceState = "missing"
        }
        
        elseif ($serviceName.Status -eq "Stopped") {

            $serviceState = "stopped"
        } 
           
        elseif ($serviceName.Status -eq "Disabled") {

            $serviceState = "disabled"
        }
         
        elseIf ($serviceName.status -eq "Running") {

            $serviceState = "running"
        }
        
        return $serviceState

    }

    do {
        do {
              
            write-host " "
            write-host " "
            write-host "###############################################################################"
            write-host " "
            write-host "`tVer. 0.2 "
            write-host " "
            write-host "`tWelcome to use my Windows 7 Security Audit Tool"
            write-host "`tAuthor: Martti Kitunen (CEHv9)"
            write-host "`tLinkedIn: https://www.linkedin.com/in/marttikitunen/"
            write-host " "
            write-host "`tPlease note that:"
            write-host "`t- This tool is made for IT professionals to do a quick security check ups"
            write-host "`t- This tool does not modify your system or make any network connections"
            write-host "`t- This tool does not check every security setting"
            write-host "`t- This tool is tested on Windows 7 Professional 64-bit version"
            write-host "`t- Some settings are user profile related"
            write-host "`t- I do not take any responsiblities of suggested settings."
            write-host "`t- Please test these suggestions in non product environment first"
            write-host " "
            write-host "###############################################################################"
			write-host "`t- Version 0.2 Changes"
			write-host "`t- Added: test-registry adminshare status check"
			write-host "`t- Added: test-registry easy of access hardening"
			write-host "`t- Added: test-registry turn of windows sidebar hardening"
			write-host "`t- Added: test-registry is aero disabled hardening"
			write-host "###############################################################################"
            write-host " "
            write-host "`t1 - Start Security Check-Ups"
            write-host "`t0 - Quit"
            write-host ""
            write-host -nonewline "`tMake your selection and press Enter: "
            
            $selection = read-host
            
            write-host ""
            
            $okay = $selection -match '^[01]{1}$'
            
            if ( -not $okay) {
            
                write-host -ForegroundColor red "`tPlease enter either 1 or 0" 
            }
            
        } until ($okay)
        
        switch -Regex ( $selection ) {
    
				"1"
                {

                    ### EMET checks ###
                    
                    $emetAntidetour = CheckRegistryValue 'HKLM:\SOFTWARE\Microsoft\EMET' 'AntiDetours' '1'
                    $emetBannedFunctions = CheckRegistryValue 'HKLM:\SOFTWARE\Microsoft\EMET' 'BannedFunctions' '1'
                    $emetDeepHooks = CheckRegistryValue 'HKLM:\SOFTWARE\Microsoft\EMET' 'DeepHooks' '1'
                    $emetExploitAction = CheckRegistryValue 'HKLM:\SOFTWARE\Microsoft\EMET' 'ExploitAction' '1'
                    $emetReportingSettings = CheckRegistryValue 'HKLM:\SOFTWARE\Microsoft\EMET' 'ReportingSettings' '7'
                    
                    ### Windows Update checks ###
                    
                    $WindowsUpdateDownloadAndInstallAuto = CheckRegistryValue 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update' 'AUOptions' '4'

                    ### UAC checks ###
                    
                    $uac1 = CheckRegistryValue 'HKLM:\Software\Microsoft\Windows\CurrentVersion\policies\system' 'enablelua' '1'
                    $uac2 = CheckRegistryValue 'HKLM:\Software\Microsoft\Windows\CurrentVersion\policies\system' 'consentpromptbehavioradmin' '2'
                    $uac3 = CheckRegistryValue 'HKLM:\Software\Microsoft\Windows\CurrentVersion\policies\system' 'promptonsecuredesktop' '1'
                    
                    ### Office Hardening ###
                    
                    $word12macro = CheckRegistryValue 'HKCU:\Software\Microsoft\Office\12.0\Word\Security' 'VBAWarnings' '4'
                    $word14macro = CheckRegistryValue 'HKCU:\Software\Microsoft\Office\14.0\Word\Security' 'VBAWarnings' '4'
                    $word15macro = CheckRegistryValue 'HKCU:\Software\Microsoft\Office\15.0\Word\Security' 'VBAWarnings' '4'
                    $word16macro = CheckRegistryValue 'HKCU:\Software\Microsoft\Office\16.0\Word\Security' 'VBAWarnings' '4'
                    $excel12macro = CheckRegistryValue 'HKCU:\Software\Microsoft\Office\12.0\Excel\Security' 'VBAWarnings' '4'
                    $excel14macro = CheckRegistryValue 'HKCU:\Software\Microsoft\Office\14.0\Excel\Security' 'VBAWarnings' '4'
                    $excel15macro = CheckRegistryValue 'HKCU:\Software\Microsoft\Office\15.0\Excel\Security' 'VBAWarnings' '4'
                    $excel16macro = CheckRegistryValue 'HKCU:\Software\Microsoft\Office\16.0\Excel\Security' 'VBAWarnings' '4'
                    $powerpoint12macro = CheckRegistryValue 'HKCU:\Software\Microsoft\Office\12.0\PowerPoint\Security' 'VBAWarnings' '4'
                    $powerpoint14macro = CheckRegistryValue 'HKCU:\Software\Microsoft\Office\14.0\PowerPoint\Security' 'VBAWarnings' '4'
					### In group policy environtment: HKCU:\Software\Policies\Microsoft\office\14.0\powerpoint\security ###
                    $powerpoint15macro = CheckRegistryValue 'HKCU:\Software\Microsoft\Office\15.0\PowerPoint\Security' 'VBAWarnings' '4'
                    $powerpoint16macro = CheckRegistryValue 'HKCU:\Software\Microsoft\Office\16.0\PowerPoint\Security' 'VBAWarnings' '4'
                    $outlook12macro = CheckRegistryValue 'HKCU:\Software\Microsoft\Office\12.0\Outlook\Security' 'VBAWarnings' '4'
                    $outlook14macro = CheckRegistryValue 'HKCU:\Software\Microsoft\Office\14.0\Outlook\Security' 'VBAWarnings' '4'
                    $outlook15macro = CheckRegistryValue 'HKCU:\Software\Microsoft\Office\15.0\Outlook\Security' 'VBAWarnings' '4'
                    $outlook16macro = CheckRegistryValue 'HKCU:\Software\Microsoft\Office\16.0\Outlook\Security' 'VBAWarnings' '4'
                    $officeActiveX = CheckRegistryValue 'HKCU:\Software\Microsoft\Office\Common\Security' 'DisableAllActiveX' '1'
                    $outlook12OleObj = CheckRegistryValue 'HKCU:\SOFTWARE\Microsoft\Office\12.0\Outlook\Security' 'ShowOLEPackageObj' '0'
                    $outlook14OleObj = CheckRegistryValue 'HKCU:\SOFTWARE\Microsoft\Office\14.0\Outlook\Security' 'ShowOLEPackageObj' '0'
                    $outlook15OleObj = CheckRegistryValue 'HKCU:\SOFTWARE\Microsoft\Office\15.0\Outlook\Security' 'ShowOLEPackageObj' '0'
                    $outlook16OleObj = CheckRegistryValue 'HKCU:\SOFTWARE\Microsoft\Office\16.0\Outlook\Security' 'ShowOLEPackageObj' '0'
                    
                    ### Firewall checks ###

                    $fwPrivateState = netsh advfirewall show private state
                    $fwPublicState = netsh advfirewall show public state
                    $fwDomainState = netsh advfirewall show domain state
                    $fwPolicyPrivate = netsh advfirewall show private firewallpolicy
                    $fwPolicyPublic = netsh advfirewall show public firewallpolicy
                    $fwPolicyDomain = netsh advfirewall show domain firewallpolicy
                    
                    ### Security Hardening ###
					
                    ### NetBT checks ###
                    
                    $nbi = 0
                    $nbx = 0
                    $RegKeys = Get-ChildItem HKLM:\System\CurrentControlSet\services\NetBT\Parameters\Interfaces
                    $RegSubKeys = $RegKeys | Foreach-Object {Get-ItemProperty $_.PsPath }
                    
                    ForEach ($RegSubKey in $RegSubKeys) {
                        
                        $nbi = $nbi+1
                        $subKey = $RegSubKey.PSChildName
                        $NetBiosStatus = CheckRegistryValue "HKLM:\SYSTEM\CurrentControlSet\services\NetBT\Parameters\Interfaces\$subKey" 'NetbiosOptions' '2'

                        If ($NetBiosStatus -eq "2" ) {
                            $nbx = $nbx+1
                        }

                    }
                    
                    $AutoPlayCheckAutoPlay = CheckRegistryValue 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers' 'DisableAutoplay' '1'
                    $IPV6status = CheckRegistryValue 'HKLM:\SYSTEM\CurrentControlSet\services\TCPIP6\Parameters' 'DisabledComponents' '255'
                    $SMB1Status = CheckRegistryValue 'HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters' 'SMB1' '0'
                    $SMB2Status = CheckRegistryValue 'HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters' 'SMB2' '0'
                    $PreventClearCreds = CheckRegistryValue 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\WDigest' 'UseLogonCredential' '0'
                    $MemoryDumpsSstatus = CheckRegistryValue 'HKLM:\SYSTEM\CurrentControlSet\Control\CrashControl' 'CrashDumpEnabled' '0'
                    $UPNPSstatus = CheckRegistryValue 'HKLM:\Software\Microsoft\DirectplayNATHelp\DPNHUPnP' 'UPnPMode' '2'
                    $SRPSecLevelDisallow = CheckRegistryValue 'HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers' 'DefaultLevel' '0'
                    $SRPSecLevelUser = CheckRegistryValue 'HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers' 'DefaultLevel' '131072'
                    $SRPSecLevelUnRestricted = CheckRegistryValue 'HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers' 'DefaultLevel' '262144'
                    $MulticastNameReso = CheckRegistryValue 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient' 'EnableMulticast' '1' ### Disable is for some reason 1
                    $disableWSH = CheckRegistryValue 'HKLM:\SOFTWARE\Microsoft\Windows Script Host\Settings' 'Enabled' '0'
                    $ClearPageFile = CheckRegistryValue 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management' 'ClearPageFileAtShutdown' '1'
                    $disableWPAD = CheckRegistryValue 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Wpad' 'WpadOverride' '1'

					$isAdminShareDisabled1 = CheckRegistryValue 'HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters' 'AutoShareServer' '0'
					$isAdminShareDisabled2 = CheckRegistryValue 'HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters' 'AutoShareWks' '0'
					
					$isAeroThemeDisabled = CheckRegistryValue 'HKCU:\Software\Microsoft\Windows\DWM' 'Composition' '0'
					
					$isSidebarDisabledSystem = CheckRegistryValue 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Windows\Sidebar' 'TurnOffSidebar' '1'
					$isSidebarDisabledUser = CheckRegistryValue 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Windows\Sidebar' 'TurnOffSidebar' '1'
					
					$isEasyOfAccessKeyboardResponseDisabled = CheckRegistryValue 'HKCU:\Control Panel\Accessibility\Keyboard Response' 'Flags' '122'
					$isEasyOfAccessMouseKeysDisabled = CheckRegistryValue 'HKCU:\Control Panel\Accessibility\MouseKeys' 'Flags' '58'
					$isEasyOfAccessStickyKeysDisabled = CheckRegistryValue 'HKCU:\Control Panel\Accessibility\StickyKeys' 'Flags' '506'
					$isEasyOfAccessToggleKeysDisabled = CheckRegistryValue 'HKCU:\Control Panel\Accessibility\ToggleKeys' 'Flags' '58'
					$isEasyOfAccessHighContrastDisabled = CheckRegistryValue 'HKCU:\Control Panel\Accessibility\HighContrast' 'Flags' '122'
					
					
                    ### Service checks ###
                    
                    $serviceSysmon = CheckServiceStatus -serviceName sysmon
                    $serviceIphlpsvc = CheckServiceStatus -serviceName iphlpsvc
                    $serviceEMET_Service = CheckServiceStatus -serviceName EMET_Service
                    $serviceSSDPSRV = CheckServiceStatus -serviceName SSDPSRV
                    $serviceMpsSvc = CheckServiceStatus -serviceName MpsSvc
                    $serviceWuauserv = CheckServiceStatus -serviceName wuauserv
                    $serviceEventlog = CheckServiceStatus -serviceName eventlog
                    $serviceRemoteRegistry = CheckServiceStatus -serviceName RemoteRegistry
                    $serviceWinHttpAutoProxySvc = CheckServiceStatus -serviceName WinHttpAutoProxySvc
                    $serviceBrowser = CheckServiceStatus -serviceName Browser
                    $serviceWinDefend = CheckServiceStatus -serviceName WinDefend
                    
                    ### Running checks ###
					
                    cls
                    write-host " "
                    write-host " "
                    write-host "`tStarting Security Checks ...."
                    write-host " "
                    write-host "`tChecking EMET status.."
                    write-host " "
                    
					If ($serviceEMET_Service -eq "running") {
						
						write-host -ForegroundColor green "`tEMET service is running [OK]"; $score = $score+1
						
					}
						
                    elseIf ($serviceEMET_Service -eq "stopped") {
					
						write-host -ForegroundColor red "`tEMET service is stopped [FAIL]"
						
					}
					
                    else {
					
						write-host -ForegroundColor red "`tEMET is not installed [FAIL]"
						
					}
					
					write-host " "
					write-host "`tChecking EMET settings.."
                    write-host " "
					
                    If ($emetAntidetour -eq "1") {
						write-host -ForegroundColor green "`tEMET Anti Detour setting [OK]" | Format-Table; $score = $score+1
					}
					
					else {
						write-host -ForegroundColor red "`tEMET Anti Detour setting is not set [FAIL]"
					}
					
                    If ($emetBannedFunctions -eq "1") {
						
						write-host -ForegroundColor green "`tEMET Banned Functions setting [OK]" | Format-List; $score = $score+1
					}
					
					else {
						write-host -ForegroundColor red "`tEMET Banned Functions setting is not set [FAIL]"
					}
					
                    If ($emetDeepHooks -eq "1") {
						write-host -ForegroundColor green "`tEMET Deep Hooks setting [OK]"; $score = $score+1
					}
					
					else {
						write-host -ForegroundColor red "`tEMET Deep Hooks setting is not set [FAIL]"
					}
					
                    If ($emetExploitAction -eq "1") {
						write-host -ForegroundColor green "`tEMET Exploit Stop Enforced [OK]"; $score = $score+1
					}
					
					else {
						write-host -ForegroundColor red "`tEMET Exploit Stop is not set [FAIL]"
					}
					
                    If ($emetReportingSettings -eq "7") {
						write-host -ForegroundColor green "`tEMET reporting settings [OK]"; $score = $score+1
					} 
					
					else {
						write-host -ForegroundColor red "`tEMET reporting settings are not set [FAIL]"
					}
                    
					write-host " "
                    write-host "`tChecking UAC status.."
                    write-host " "
					
                    If ($uac1 -eq 1) {
						write-host -ForegroundColor green "`tUAC status [OK]"; $score = $score+1
					}
					
					else {
						write-host -ForegroundColor red "`tUAC status [FAIL]"
					}
					
                    If ($uac2 -eq 2 -and $uac3 -eq 1) {
						write-host -ForegroundColor green "`tUAC High security [OK]"; $score = $score+2
					}
					
					else {
						write-host -ForegroundColor yellow "`tUAC default settings [WARNING]"
					}
					
					write-host " "
                    write-host "`tChecking Windows Update status.."
                    write-host " "
					
        			If ($serviceWuauserv -eq "running") {
						write-host -ForegroundColor green "`tWindows Update Service is running [OK]"; $score = $score+1
					}
					
                    elseIf ($serviceWuauserv -eq "stopped") {
						write-host -ForegroundColor yellow "`tWindows Update Service is not running [WARNING]"
					}
					
                    else {
						write-host -ForegroundColor red "`tWindows Update Service is not installed [FAIL]"
					}
					
                    If ($WindowsUpdateDownloadAndInstallAuto -eq "4") {
						write-host -ForegroundColor green "`tWindows Update Automatic Download And Install [OK]"; $score = $score+1
					} 
					else {
						write-host -ForegroundColor red "`tWindows Update Is Not Auto Updating [FAIL]"
					}
                    
                    write-host " "
                    write-host "`tChecking Windows Firewall status.."
                    write-host " "
                    
                    If ($serviceMpsSvc -eq "running") {
						write-host -ForegroundColor green "`tWindows Firewall Service [OK]"; $score = $score+1
					}
					
                    elseIf ($serviceMpsSvc -eq "stopped") {
						write-host -ForegroundColor red "`tWindows Firewall Service is not running [FAIL]"
					}
                    
                    else {
						write-host -ForegroundColor red "`tWindows Firewall Service is not installed [FAIL]"
					}
                    
                    write-host " "
                    
                    if ($fwPrivateState -match "ON") {
                        write-host -ForegroundColor green "`tWindows Firewall with Private Profile Is On [OK]"; $score = $score+1
                        
                        if ($fwPolicyPrivate -match "BlockInbound" -and $fwPolicyPrivate -match "BlockOutbound") {
                            write-host -ForegroundColor green "`tWindows Firewall Is Strictly configured [OK]"; $score = $score+1
                        }

                        elseif ($fwPolicyPrivate -match "BlockInbound" -and $fwPolicyPrivate -match "AllowOutbound") {
                            write-host -ForegroundColor yellow "`tWindows Firewall Is Using Default Configuration [WARNING]"; 
                        }
                        
                        elseif ($fwPolicyPrivate -match "AllowInbound" -and $fwPolicyPrivate -match "AllowOutbound") {
                            write-host -ForegroundColor red "`tWindows Firewall - Everything Allowed, Configuration Error [FAIL]"; 
                        }

                    }

                    else {
                        write-host -ForegroundColor red "`tWindows Firewall with Private Profile Is Not On [FAIL]";
                    }
                    
                    write-host " "

                    if ($fwPublicState -match "ON") {
                        write-host -ForegroundColor green "`tWindows Firewall with Public Profile Is On [OK]"; $score = $score+1
                        
                        if ($fwPolicyPublic -match "BlockInbound" -and $fwPolicyPublic -match "BlockOutbound") {
                            write-host -ForegroundColor green "`tWindows Firewall Is Strictly configured [OK]"; $score = $score+1
                        }
                    
                        elseif ($fwPolicyPublic -match "BlockInbound" -and $fwPolicyPublic -match "AllowOutbound") {
                            write-host -ForegroundColor yellow "`tWindows Firewall Is Using Default Configuration [WARNING]"; 
                        }
                        
                        elseif ($fwPolicyPublic -match "AllowInbound" -and $fwPolicyPublic -match "AllowOutbound") {
                            write-host -ForegroundColor red "`tWindows Firewall - Everything Allowed, Configuration Error [FAIL]"; 
                        }
                    }

                    else {
                        write-host -ForegroundColor red "`tWindows Firewall with Public Profile Is Not On [FAIL]";
                    }
                    
                    write-host " "

                    if ($fwDomainState -match "ON") {
                        write-host -ForegroundColor green "`tWindows Firewall with Domain Profile Is On [OK]"; $score = $score+1
                       
                        if ($fwPolicyDomain -match "BlockInbound" -and $fwPolicyDomain -match "BlockOutbound") {
                            write-host -ForegroundColor green "`tWindows Firewall Is Strictly configured [OK]"; $score = $score+1
                        }
                        
                        elseif ($fwPolicyDomain -match "BlockInbound" -and $fwPolicyDomain -match "AllowOutbound") {
                            write-host -ForegroundColor yellow "`tWindows Firewall Is Using Default Configuration [WARNING]"; 
                        }
                        
                        elseif ($fwPolicyDomain -match "AllowInbound" -and $fwPolicyDomain -match "AllowOutbound") {
                            write-host -ForegroundColor red "`tWindows Firewall - Everything Allowed, Configuration Error [FAIL]"; 
                        }
                    }

                    else {
                        write-host -ForegroundColor red "`tWindows Firewall with Domain Profile Is Not On [FAIL]";
                    }
                    
					write-host " "
                    write-host "`tChecking System Hardening.."
                    write-host " "
					
                    If ($nbi -eq $nbx ) {
                        write-host -ForegroundColor green "`tNetBIOS Registry Key Is Set To Disabled [OK]"; $score = $score+1
                    }
                    
                    else {
                        write-host -ForegroundColor red "`tNetBIOS Registry Key Is Not Set To Disabled [FAIL]"
                    }
					
                    If ($AutoPlayCheckAutoPlay -eq "1") {
						write-host -ForegroundColor green "`tAutoPlay Disabled [OK]"; $score = $score+1
					} 
					
					else {
						write-host -ForegroundColor red "`tAutoPlay Is Not Disabled [FAIL]"
					}
					
                    If ($IPV6status -eq "255") {
						write-host -ForegroundColor green "`tIPV6 Disabled [OK]"; $score = $score+1
					}
					
					else {
						write-host -ForegroundColor yellow "`tIPV6 Is Enabled. Consider Disabling It If Not Needed [WARNING]"
					}
					
                    If ($SMB1Status -eq "0") {
						write-host -ForegroundColor green "`tSMB1 Disabled [OK]"; $score = $score+1
					} 
					
					else {
						write-host -ForegroundColor red "`tSMB1 Is Not Disabled [FAIL]"
					}
                    
                    If ($SMB2Status -eq "0") {
						write-host -ForegroundColor green "`tSMB2 Disabled [OK]"; $score = $score+1
					} 
					
					else {
						write-host -ForegroundColor red "`tSMB2 Is Not Disabled [FAIL]"
					}
					
                    If ($PreventClearCreds -eq "0") {
						write-host -ForegroundColor green "`tWDigest Feature Disabled [OK]"; $score = $score+1
					} 
					
					else {
						write-host -ForegroundColor red "`tWDigest Feature Is Not Disabled [FAIL]"
					}
					
                    If ($MemoryDumpsSstatus -eq "0") {
						write-host -ForegroundColor green "`tMemory dumps Disabled [OK]"; $score = $score+1
					}
					
					else {
						write-host -ForegroundColor red "`tMemory dumps are Enabled [FAIL]"
					}
					
                    If ($UPNPSstatus -eq "2") {
						write-host -ForegroundColor green "`tUPnP Port 1900 Disabled [OK]"; $score = $score+1
					} 
					
					else {
						write-host -ForegroundColor red "`tUPnP Port 1900 Enabled [FAIL]"
					}
					
                    If ($SRPSecLevelDisallow -eq "0") {
						write-host -ForegroundColor green "`tSoftware Restriction Policy with Disallow Enforcement Enabled [OK]"; $score = $score+1
					}
					
                    elseif ($SRPSecLevelUnRestricted -eq "262144") {
						write-host -ForegroundColor yellow "`tSoftware Restriction Policy with Unrestricted Enforcement enabled [WARNING]"
					} 
					
                    elseIf ($SRPSecLevelUser -eq "131072") {
						write-host -ForegroundColor yellow "`tSoftware Restriction Policy with Basic User Enforcement enabled [WARNING]"
					}
					
                    else {
						write-host -ForegroundColor red "`tSoftware Restriction Policy IS Not Set [FAIL]"
					}
					
                    If ($MulticastNameReso -eq "1") {
						write-host -ForegroundColor green "`tMulticast Name Resolution Disabled [OK]"; $score = $score+1
					}
					
					else {
						write-host -ForegroundColor red "`tMulticast Name Resolution Is Not Disabled [FAIL]"
					}
                    
                    If ($disableWSH -eq "0") {
						write-host -ForegroundColor green "`tWindows Scripting Host Platform Disabled [OK]"; $score = $score+1
					} 
					
                    else {
						write-host -ForegroundColor yellow "`tConsider disabling your Windows Scripting Host platform [WARNING]"
					}

                    If ($disableWPAD -eq "1") {
						write-host -ForegroundColor green "`tWeb Proxy Auto-Discovery Protocol Is Disabled [OK]"; $score = $score+1
					} 
					
                    else {
						write-host -ForegroundColor red "`tWeb Proxy Auto-Discovery Protocol Is Not disabled [FAIL]"
					}
					
					If ($isAdminShareDisabled1 -eq "0"-and $isAdminShareDisabled1 -eq "0") {
						write-host -ForegroundColor green "`tWindows Default Admin Shares Disabled [OK]"; $score = $score+1
					} 
					
                    else {
						write-host -ForegroundColor red "`tWindows Default Admin Shares Are Not Disabled [FAIL]"
					}
					
					If ($isAeroThemeDisabled -eq "0") {
						write-host -ForegroundColor green "`tWindows Aero Theme Is Disabled [OK]"; $score = $score+1
					} 
					
                    else {
						write-host -ForegroundColor red "`tWindows Aero Theme Is Not Disabled [FAIL]"
					}
					
					If ($isSidebarDisabledSystem -eq "1" -and $isSidebarDisabledUser -eq "1") {
						write-host -ForegroundColor green "`tWindows Sidebar Is Disabled [OK]"; $score = $score+1
					} 
					
                    else {
						write-host -ForegroundColor red "`tWindows Sidebar Is Not Disabled [FAIL]"
					}
					
					If ($isEasyOfAccessKeyboardResponseDisabled -eq "122" -and $isEasyOfAccessMouseKeysDisabled -eq "58" -and $isEasyOfAccessStickyKeysDisabled -eq "506" -and $isEasyOfAccessToggleKeysDisabled -eq "58" -and $isEasyOfAccessHighContrastDisabled -eq "122") {
						write-host -ForegroundColor green "`tWindows Easy Of Access Is Hardened [OK]"; $score = $score+1
					} 
					
                    else {
						write-host -ForegroundColor red "`tWindows Easy Of Access Is Not Hardened [FAIL]"
					}

                    If ($ClearPageFile -eq "1") {
						write-host -ForegroundColor green "`tClearing the Windows Paging File at Shutdown Is Enabled [OK]"; $score = $score+1
					} 
					
                    else {
						write-host -ForegroundColor red "`tClearing the Windows Paging File at Shutdown Is Not Enabled [FAIL]"
					}

                    write-host " "
                    write-host "`tChecking Office Hardening.."
                    write-host " "
                    
                    If ($word12macro -eq "4") {
						write-host -ForegroundColor green "`tWord 2009 Macro Settings Secure [OK]"; $score = $score+1
					}
					
                    elseIf ($word14macro -eq "4") {
						write-host -ForegroundColor green "`tWord 2010 Macro Settings Secure [OK]"; $score = $score+1
					}
					
                    elseIf ($word15macro -eq "4") {
						write-host -ForegroundColor green "`tWord 2013 Macro Settings Secure [OK]"; $score = $score+1
					}
					
                    elseIf ($word16macro -eq "4") {
						write-host -ForegroundColor green "`tWord 2016 Macro Settings Secure [OK]"; $score = $score+1
					}	
					
                    else {
						write-host -ForegroundColor red "`tCheck Your Word Macro Security Settings [FAIL]"
					}

                    If ($excel12macro -eq "4") {
						write-host -ForegroundColor green "`tExcel 2009 Macro Settings Secure [OK]"; $score = $score+1
					}  
					
                    elseIf ($excel14macro -eq "4") {
						write-host -ForegroundColor green "`tExcel 2010 Macro Settings Secure [OK]"; $score = $score+1
					}
					
                    elseIf ($excel15macro -eq "4") {
						write-host -ForegroundColor green "`tExcel 2013 Macro Settings Secure [OK]"; $score = $score+1
					}
					
                    elseIf ($excel16macro -eq "4") {
						write-host -ForegroundColor green "`tExcel 2016 Macro Settings Secure [OK]"; $score = $score+1
					}
					
                    else {
						write-host -ForegroundColor red "`tCheck Your Excel Macro Security Settings [FAIL]"
					}

                    If ($powerpoint12macro -eq "4") {
						write-host -ForegroundColor green "`tPowerPoint 2009 Macro Settings Secure [OK]"; $score = $score+1
					} 
					
                    elseIf ($powerpoint14macro -eq "4") {
						write-host -ForegroundColor green "`tPowerPoint 2010 Macro Settings Secure [OK]"; $score = $score+1
					}
                    
					elseIf ($powerpoint15macro -eq "4") {
						write-host -ForegroundColor green "`tPowerPoint 2013 Macro Settings Secure [OK]"; $score = $score+1
					}
					
                    elseIf ($powerpoint16macro -eq "4") {
						write-host -ForegroundColor green "`tPowerPoint 2016 Macro Settings Secure [OK]"; $score = $score+1
					}
					
                    else {
						write-host -ForegroundColor red "`tCheck Your PowerPoint Macro Security Settings [FAIL]"}

                    If ($outlook12macro -eq "4") {
						write-host -ForegroundColor green "`tOutlook 2009 Macro Settings Secure [OK]"; $score = $score+1
					} 
					
                    elseIf ($outlook14macro -eq "4") {
						write-host -ForegroundColor green "`tOutlook 2010 Macro Settings Secure [OK]"; $score = $score+1
					}
					
                    elseIf ($outlook15macro -eq "4") {
						write-host -ForegroundColor green "`tOutlook 2013 Macro Settings Secure [OK]"; $score = $score+1
					}
					
                    elseIf ($outlook16macro -eq "4") {
						write-host -ForegroundColor green "`tOutlook 2016 Macro Settings Secure [OK]"; $score = $score+1
					}
					
                    else {
						write-host -ForegroundColor red "`tCheck Your Outlook Macro Security Settings [FAIL]"
					}

                    If ($officeActiveX -eq "1") {
                        write-host -ForegroundColor green "`tOffice ActiveX Settings Secure [OK]"; $score = $score+1
                    } 
                    else {
                        write-host -ForegroundColor red "`tOffice ActiveX Setting Is Not Secured [FAIL]"
                    }

                    If ($outlook12OleObj -eq "0") {
						write-host -ForegroundColor green "`tOutlook 2009 OLE Package Feature Is Disabled [OK]"; $score = $score+1
					} 
                    
					elseIf ($outlook14OleObj -eq "0") {
						write-host -ForegroundColor green "`tOutlook 2010 OLE Package Feature Is Disabled [OK]"; $score = $score+1} 
						
                    elseIf ($outlook15OleObj -eq "0") {
						write-host -ForegroundColor green "`tOutlook 2013 OLE Package Feature Is Disabled [OK]"; $score = $score+1
					}
					
                    elseIf ($outlook16OleObj -eq "0") {
						write-host -ForegroundColor green "`tOutlook 2016 OLE Package Feature Is Disabled [OK]"; $score = $score+1
					} 
					
                    else {
						write-host -ForegroundColor red "`tOutlook OLE Package Feature Is Not Disabled [FAIL]"
					}
                    
					write-host " "
                    write-host "`tChecking Important Services.."            
                    write-host " "
					
                    If ($serviceSysmon -eq "running") {
						write-host -ForegroundColor green "`tSysmon Enhanced Loggin Service [OK]"; $score = $score+1
					}
					
                    elseIf ($serviceSysmon -eq "stopped") {
						write-host -ForegroundColor yellow "`tSysmon Enhanced Loggin Service is not running [WARNING]";
					}
					
                    else {
						write-host -ForegroundColor red "`tSysmon Enhanced Logging Service is Not installed [FAIL]"
					}
					                  
					If ($serviceWinDefend -eq "running") {
						write-host -ForegroundColor green "`tWindows Defender Service [OK]"; $score = $score+1
					}
					
                    elseIf ($serviceWinDefend -eq "stopped") {
						write-host -ForegroundColor red "`tWindows Defender Service is not running [FAIL]";
					}
					
                    else {
						write-host -ForegroundColor red "`tWindows Defender Service is not installed [FAIL]"
					}
					
        			If ($serviceEventlog -eq "running") {
						write-host -ForegroundColor green "`tEventlog Service [OK]"; $score = $score+1
					}
					
                    elseIf ($serviceEventlog -eq "stopped") {
						write-host -ForegroundColor red "`tEventlog Service is not running [FAIL]"
					}
					
                    else {
						write-host -ForegroundColor red "`tEventlog Service is not installed [FAIL]"
					}
                    
					write-host " "
                    write-host "`tChecking unnecessary vulnerable services.." 
                    write-host " "
					
                    If ($serviceIphlpsvc -eq "stopped") {
						write-host -ForegroundColor green "`tIP Helper Service Is Not Running [OK]"; $score = $score+1
					}
					
                    elseIf ($serviceIphlpsvc -eq "running") {
						write-host -ForegroundColor red "`tIP Helper Service Is Running [FAIL]"
					}
					
                    else {
						write-host -ForegroundColor green "`tIP Helper Service Is Not Installed [OK]"; $score = $score+1
					}
        			
        			If ($serviceSSDPSRV -eq "stopped") {
						write-host -ForegroundColor green "`tSSDP Discovery Service Is Not Running [OK]"; $score = $score+1
					}
					
                    elseIf ($serviceSSDPSRV -eq "running") {
						write-host -ForegroundColor red "`tSSDP Discovery Service Running [FAIL]"
					}
                    
					else {
						write-host -ForegroundColor green "`tSSDP Discovery Service Is Not Installed [OK]"; $score = $score+1
					}
        			
        			If ($serviceRemoteRegistry -eq "stopped") {
						write-host -ForegroundColor green "`tRemote Registry Service Is Not Running [OK]"; $score = $score+1
					}
					
                    elseIf ($serviceRemoteRegistry -eq "running") {
						write-host -ForegroundColor red "`tRemote Registry Service Is Running [FAIL]"
					}
					
                    else {
						write-host -ForegroundColor green "`tRemote Registry Service Is Not installed [OK]"; $score = $score+1
					}
        			
        			If ($serviceWinHttpAutoProxySvc -eq "stopped") {
						write-host -ForegroundColor green "`tWinHTTP Web Proxy Auto-Discovery Service Is Not Running [OK]"; $score = $score+1
					}
                    
					elseIf ($serviceWinHttpAutoProxySvc -eq "running") {
						write-host -ForegroundColor red "`tWinHTTP Web Proxy Auto-Discovery Service Is Running [FAIL]"
					}
                    
					else {
						write-host -ForegroundColor green "`tWinHTTP Web Proxy Auto-Discovery Service Is Not installed [OK]"; $score = $score+1
					}
        			
        			If ($serviceBrowser -eq "stopped") {
						write-host -ForegroundColor green "`tComputer Browser Service Is Not Running [OK]"; $score = $score+1
					}
					
                    elseIf ($serviceBrowser -eq "running") {
						write-host -ForegroundColor red "`tComputer Browser Service Is Running [FAIL]"
					}
                    
					else {
						write-host -ForegroundColor green "`tComputer Browser Service Is Not Installed [FAIL]"; $score = $score+1
					}
                    

                    write-host " "
                    write-host " "
                    write-host "`tSecurity Scan Completed!"
                    write-host " "
                    write-host "`tYour Score: $score/$maxScore"
                    write-host " "
                    write-host " "
                    write-host " "
                    write-host "`tSuggestions:"
                    write-host " "
                    write-host " "
                    write-host " "
                    write-host " "
                    write-host " "
                    write-host " "
                    #$selection = 0
                    
                    ### Format score back to 0 ###
                    
                    $score = 0
                }
                        
        }
    	
    } until ($selection -match "0")