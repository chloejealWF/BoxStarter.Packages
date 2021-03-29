try 
{
    # Boxstarter options 
    $Boxstarter.RebootOk = $true # Allow reboots? 
    $Boxstarter.NoPassword = $false # Is this a machine with no login password? 
    $Boxstarter.AutoLogin = $true # Save my password securely and auto-login after a reboot

    choco feature enable -n allowEmptyChecksums

    # Basic setup
    Update-ExecutionPolicy Unrestricted    
    Set-ExplorerOptions -showHidenFilesFoldersDrives -showProtectedOSFiles -showFileExtensions
    Set-TaskbarSmall
    Enable-RemoteDesktop

    # Remove the Windows logon message which prevents auto-logon
    $CurrrentLocation = Get-Location
    Set-Location HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system
    Remove-ItemProperty -Path . -Name "LegalNoticeCaption" -ErrorAction Ignore
    Remove-ItemProperty -Path . -Name "LegalNoticeText" -ErrorAction Ignore
    Set-Location $CurrrentLocation

    if (Test-PendingReboot) { Invoke-Reboot }

    Install-WindowsUpdate -AcceptEula
    
    if (Test-PendingReboot) { Invoke-Reboot }       

    # Essential Tools
    choco install zip    
    choco install conemu
    choco install windirstat
    choco install baretail
    choco install greenshot
    choco install grepwin

    #Messaging apps
    cinst -y slack
    cinst -y skype

    # Text Editors
    cinst -y atom
    cinst -y notepadplusplus
    cinst -y vim

    #Browsers
    cinst -y firefox
    cinst -y google-chrome-x64
    cinst -y opera
    
    #DevTools - Frameworks
    cinst -y DotNet3.5 
    cinst -y DotNet4.0 
    cinst -y DotNet4.5 
    cinst -y dotnet4.6    
    cinst -y nodejs

    if (Test-PendingReboot) { Invoke-Reboot }
       
    #DevTools - Source Control
    cinst -y git
    cinst -y git-credential-manager-for-windows
    cinst -y sourcetree
    cinst -y gittfs    
    cinst -y poshgit
    cinst -y kdiff3
        
    # DevTools - IDE's    
    cinst -y linqpad4
    cinst -y linqpad5
    cinst -y mssql2014-dev --ignorechecksums
    cinst -y tfpt

    if (Test-PendingReboot) { Invoke-Reboot }
    
    # DevTool - VS Extensions
    cinst -y resharper-platform
    Install-ChocolateyVsixPackage 'CodeMaid' 'https://visualstudiogallery.msdn.microsoft.com/76293c4d-8c16-4f4a-aee6-21f83a571496/file/9356/32/CodeMaid_v0.8.1.vsix'
    Install-ChocolateyVsixPackage 'VsVim' 'https://visualstudiogallery.msdn.microsoft.com/59ca71b3-a4a3-46ca-8fe1-0e90e3f79329/file/6390/57/VsVim.vsix'
    Install-ChocolateyVsixPackage 'ProductivityPowerTools' 'https://visualstudiogallery.msdn.microsoft.com/34ebc6a2-2777-421d-8914-e29c1dfa7f5d/file/169971/1/ProPowerTools.vsix'
    Install-ChocolateyVsixPackage 'ConEmuLauncher' 'https://visualstudiogallery.msdn.microsoft.com/1ce30e82-c27c-40fd-b2d8-310ab234ab74/file/91435/6/ConEmuLauncher.vsix'    
    Install-ChocolateyVsixPackage 'GitHubExtensionVisualStudio' 'https://visualstudiogallery.msdn.microsoft.com/75be44fb-0794-4391-8865-c3279527e97d/file/159055/11/GitHub.VisualStudio.vsix'        
    Install-ChocolateyVsixPackage 'PowershellTools' 'https://visualstudiogallery.msdn.microsoft.com/c9eb3ba8-0c59-4944-9a62-6eee37294597/file/199313/1/PowerShellTools.14.0.vsix'    
        
    #DevTools - Misc
    cinst -y nugetpackageexplorer
    cinst -y dotPeek
    cinst -y ilspy
    cinst -y fiddler
    cinst -y lastpass
    
    #DevTools - MSI Tools and Frameworks
    cinst -y insted
    cinst -y wixtoolset
    
    # Virtualisation              
    Enable-WindowsOptionalFeature -online -FeatureName Containers
    Enable-WindowsOptionalFeature -online -FeatureName Microsoft-Hyper-V-All
    cinst -y vagrant
    
    # SystemTools  
    cinst -y sysinternals
    cinst -y windbg
    (new-object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | iex

    Install-ChocolateyPinnedTaskBarItem "$($Boxstarter.programFiles86)\Google\Chrome\Application\chrome.exe"
    git a
    mkdir C:\source        

    Write-ChocolateySuccess 'Dev-Machine-Setup'
} 
catch 
{
    Write-ChocolateyFailure 'Dev-Machine-Setup' $($_.Exception.Message)
    throw
}
